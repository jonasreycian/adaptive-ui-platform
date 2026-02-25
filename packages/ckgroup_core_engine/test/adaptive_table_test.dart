import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Simple test model.
class _Person {
  const _Person(this.name, this.age);
  final String name;
  final int age;
}

const _people = [
  _Person('Alice', 30),
  _Person('Bob', 25),
  _Person('Charlie', 35),
  _Person('Diana', 28),
];

List<AdaptiveTableColumn<_Person>> _columns() => [
      AdaptiveTableColumn<_Person>(
        key: 'name',
        label: 'Name',
        cellBuilder: (ctx, p) => Text(p.name),
        sortable: true,
        sortValue: (p) => p.name,
      ),
      AdaptiveTableColumn<_Person>(
        key: 'age',
        label: 'Age',
        cellBuilder: (ctx, p) => Text('${p.age}'),
        sortable: true,
        sortValue: (p) => p.age,
      ),
    ];

Widget _buildUnderTest({
  required Widget child,
  bool isDark = false,
}) {
  final colors = isDark ? ColorTokens.dark : ColorTokens.light;
  return MaterialApp(
    home: TokenResolver(
      colors: colors,
      spacing: SpacingTokens.instance,
      typography: TypographyTokens.instance,
      radius: RadiusTokens.instance,
      elevation: ElevationTokens.instance,
      motion: MotionTokens.instance,
      child: Scaffold(body: child),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AdaptiveTable', () {
    testWidgets('renders column headers', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people,
          ),
        ),
      );
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
    });

    testWidgets('renders row data', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people,
          ),
        ),
      );
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Charlie'), findsOneWidget);
      expect(find.text('Diana'), findsOneWidget);
    });

    testWidgets('shows empty message when rows is empty', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: const [],
            emptyMessage: 'Nothing here',
          ),
        ),
      );
      expect(find.text('Nothing here'), findsOneWidget);
    });

    testWidgets('renders search field by default (searchable defaults to true)',
        (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people,
          ),
        ),
      );
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('hides search field when searchable is false', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people,
            searchable: false,
          ),
        ),
      );
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('filters rows by search query using filterRow', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people,
            filterRow: (p, q) =>
                p.name.toLowerCase().contains(q.toLowerCase()),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'ali');
      await tester.pump();

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsNothing);
      expect(find.text('Charlie'), findsNothing);
      expect(find.text('Diana'), findsNothing);
    });

    testWidgets('shows empty message when search matches nothing',
        (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people,
            filterRow: (p, q) =>
                p.name.toLowerCase().contains(q.toLowerCase()),
            emptyMessage: 'No results',
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'zzzz');
      await tester.pump();

      expect(find.text('No results'), findsOneWidget);
    });

    testWidgets('calls onSearchChanged when search text changes',
        (tester) async {
      String? captured;
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people,
            onSearchChanged: (q) => captured = q,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Bob');
      await tester.pump();

      expect(captured, 'Bob');
    });

    testWidgets('sortable column header shows sort icon', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people,
          ),
        ),
      );
      // unfold_more icon shown for unsorted sortable columns
      expect(find.byIcon(Icons.unfold_more), findsWidgets);
    });

    testWidgets('tapping sortable header sorts rows ascending', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people,
          ),
        ),
      );

      // Tap the "Name" header to sort ascending
      await tester.tap(find.text('Name'));
      await tester.pump();

      // Arrow up icon should appear
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    });

    testWidgets('tapping sorted header toggles to descending', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people,
          ),
        ),
      );

      // First tap: ascending
      await tester.tap(find.text('Name'));
      await tester.pump();
      // Second tap: descending
      await tester.tap(find.text('Name'));
      await tester.pump();

      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('calls onSort callback when header tapped', (tester) async {
      String? sortedKey;
      AdaptiveTableSortDirection? sortedDir;

      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people,
            onSort: (key, dir) {
              sortedKey = key;
              sortedDir = dir;
            },
          ),
        ),
      );

      await tester.tap(find.text('Age'));
      await tester.pump();

      expect(sortedKey, 'age');
      expect(sortedDir, AdaptiveTableSortDirection.ascending);
    });

    testWidgets('pagination is hidden when all rows fit on one page',
        (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people, // 4 rows
            rowsPerPage: 10,
          ),
        ),
      );
      // No pagination controls should be rendered
      expect(find.byIcon(Icons.chevron_left), findsNothing);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('pagination shows when rows exceed rowsPerPage', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people, // 4 rows
            rowsPerPage: 2,
          ),
        ),
      );
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('next page button shows second page rows', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people, // 4 rows
            rowsPerPage: 2,
          ),
        ),
      );

      // First page: Alice, Bob
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Charlie'), findsNothing);

      // Tap next
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();

      // Second page: Charlie, Diana
      expect(find.text('Charlie'), findsOneWidget);
      expect(find.text('Diana'), findsOneWidget);
      expect(find.text('Alice'), findsNothing);
    });

    testWidgets('renders filter widget alongside search field', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveTable<_Person>(
            columns: _columns(),
            rows: _people,
            filterWidget:
                const Text('filter-widget', key: Key('filter-widget')),
          ),
        ),
      );
      expect(find.byKey(const Key('filter-widget')), findsOneWidget);
    });
  });
}
