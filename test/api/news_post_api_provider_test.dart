import 'package:flutter_test/flutter_test.dart';
import 'package:latin_news/models/news_post.dart';
import 'package:latin_news/providers/db_provider.dart';
import 'package:latin_news/utils/constants.dart';
import 'package:latin_news/providers/api_provider.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:mocktail/mocktail.dart';

class MockResponse extends Mock implements Response {}

class MockDBProvider extends Mock implements DBProvider {}

class MockHttpClient extends Mock implements Client {}

void main() {
  late NewsPostApiProvider apiProvider;
  late Client mockHttpClient;
  late MockDBProvider mockDBProvider;
  late Response mockedResponseObject;
  final pageOneUri = Uri.parse("$baseApiEndpoint?_page=1&_limit=$apiPageSize");

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockDBProvider = MockDBProvider();
    mockedResponseObject = MockResponse();

    apiProvider = NewsPostApiProvider(
      httpClient: mockHttpClient,
      dbProvider: mockDBProvider,
    );
  });

  group('getNextPage Tests', () {
    test(
      'should return parsed posts count when API call is successful',
      () async {
        final mockResponse = jsonEncode([
          {"id": 1, "title": "Test Post", "userId": 1, "body": "Content here"},
          {"id": 2, "title": "Second Post", "userId": 1, "body": "More content"},
        ]);

        final newsPost = NewsPost(
          id: 1,
          userId: 1,
          title: "title",
          body: "body",
        );

        when(
          () => mockHttpClient.get(pageOneUri),
        ).thenAnswer((_) async => mockedResponseObject);

        when(() => mockedResponseObject.statusCode).thenReturn(200);
        when(() => mockedResponseObject.body).thenReturn(mockResponse);

        when(() => mockDBProvider.deleteAllPosts()).thenAnswer((_) async => 10);

        when(() => mockDBProvider.createNews(newsPost)).thenAnswer((_) async => {});

        final result = await apiProvider.getNextPage(1, false);

        expect(result.newsPostsCount, 2);
      },
    );

    test('should return error message when API call fails', () async {
      when(
        () => mockHttpClient.get(pageOneUri),
      ).thenThrow(Exception("Something went wrong. Please try again."));

      final result = await apiProvider.getNextPage(1, false);

      expect(result.newsPostsCount, 0);
      expect(result.responseMessage, contains("Something went wrong. Please try again."));
    });

    test('should clear DB when isRefresh is true and data exists', () async {
      final mockResponse = jsonEncode([
        {"id": 1, "title": "Test Post", "userId": 1, "body": "Content here"},
      ]);

      when(
        () => mockHttpClient.get(pageOneUri),
      ).thenAnswer((_) async => Response(mockResponse, 200));

      when(() => mockDBProvider.deleteAllPosts()).thenAnswer((_) async => 1);
      when(
        () => mockDBProvider.createNews(
          NewsPost(id: 2, userId: 2, title: "title", body: "body"),
        ),
      ).thenAnswer((_) async => {});

      final result = await apiProvider.getNextPage(1, true);

      verify(() => mockDBProvider.deleteAllPosts()).called(1); // Verify DB cleared
      expect(result.newsPostsCount, 1);
    });
  });
}
