import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:latin_news/main.dart';
import 'package:latin_news/providers/api_provider.dart';
import 'package:latin_news/providers/db_provider.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Selection & Navigation Tests', () {
    testWidgets(
      'Verify that selecting a post opens it in another screen',
      (tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              Provider<http.Client>(create: (_) => http.Client()),
              Provider<DBProvider>(create: (_) => DBProvider.db),
              ProxyProvider2<http.Client, DBProvider, NewsPostApiProvider>(
                update: (_, httpClient, dbProvider, __) => NewsPostApiProvider(
                  httpClient: httpClient,
                  dbProvider: dbProvider,
                ),
              ),
            ],
            child: MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        final firstPost = find.text("# 2");
        await tester.tap(firstPost);

        await tester.pumpAndSettle();

        final detailsTitle = find.byKey(const Key('header_title'));

        expect(find.descendant(of: detailsTitle, matching: find.text("Qui Est Esse")), findsOneWidget);
      },
    );
  });
}
