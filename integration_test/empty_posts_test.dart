import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:latin_news/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:latin_news/providers/api_provider.dart';
import 'package:latin_news/providers/db_provider.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('First Screen test', () {

    testWidgets('Verify that the first screen can be pulled to refresh', (
        tester,
        ) async {
      // Load app widget.
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

      expect(find.text("# 1"), findsOneWidget);
    });
  });

  testWidgets('Verify that load more will fetch to the 20th item', (
      tester,
      ) async {
    // Load app widget.
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

    // Find the scrollable list (make sure it has a Key)
    final listFinder = find.byType(Scrollable);

    await tester.scrollUntilVisible(
      find.text("Load More"), // Target widget
      500.0, // Scroll step size
      scrollable: listFinder,
    );

    // Locate the load more button
    final loadMore = find.byKey(const Key('load_more'));
    await tester.tap(loadMore);

    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 4));

    await tester.scrollUntilVisible(
      find.text("Load More"), // Target widget
      500.0, // Scroll step size
      scrollable: listFinder,
    );

    expect(find.text("# 20"), findsOneWidget);
  });

}