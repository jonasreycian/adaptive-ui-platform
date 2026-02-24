import 'package:flutter/material.dart';
import 'package:core_engine/core_engine.dart';

/// Sort direction for an [AdaptiveTable] column.
enum AdaptiveTableSortDirection { ascending, descending }

/// Defines a single column in an [AdaptiveTable].
///
/// [key] uniquely identifies the column and is used to report sort events.
/// [label] is the header text.
/// [cellBuilder] returns the widget rendered in each data cell.
/// Set [sortable] to `true` to show a sort indicator in the header.
/// Provide [sortValue] for built-in client-side sorting.
/// [width] fixes the column width in logical pixels; flexible by default (160 dp).
class AdaptiveTableColumn<T> {
  const AdaptiveTableColumn({
    required this.key,
    required this.label,
    required this.cellBuilder,
    this.sortable = false,
    this.sortValue,
    this.width,
  });

  final String key;
  final String label;
  final Widget Function(BuildContext context, T row) cellBuilder;
  final bool sortable;

  /// Extracts a [Comparable] from a row for built-in client-side sorting.
  final Comparable<dynamic> Function(T row)? sortValue;

  /// Fixed column width in logical pixels. Defaults to 160 dp when null.
  final double? width;
}

/// A token-driven data table with search, filter, pagination, and sorting.
///
/// **Client-side usage** — supply [filterRow] and column [sortValue]s so the
/// widget handles filtering and sorting internally:
///
/// ```dart
/// AdaptiveTable<Person>(
///   columns: [
///     AdaptiveTableColumn(
///       key: 'name', label: 'Name',
///       cellBuilder: (ctx, p) => Text(p.name),
///       sortable: true, sortValue: (p) => p.name,
///     ),
///   ],
///   rows: people,
///   filterRow: (person, query) =>
///       person.name.toLowerCase().contains(query.toLowerCase()),
/// )
/// ```
///
/// **Server-side usage** — omit [filterRow]/[sortValue] and listen to
/// [onSearchChanged] / [onSort] to fetch updated data from your backend.
class AdaptiveTable<T> extends StatefulWidget {
  const AdaptiveTable({
    super.key,
    required this.columns,
    required this.rows,
    this.rowsPerPage = 10,
    this.searchable = true,
    this.searchHint = 'Search…',
    this.filterWidget,
    this.filterRow,
    this.onSearchChanged,
    this.onSort,
    this.emptyMessage = 'No data available',
  });

  /// Column definitions (order determines display order).
  final List<AdaptiveTableColumn<T>> columns;

  /// Full data set to display (or the current page for server-side mode).
  final List<T> rows;

  /// Maximum number of rows shown per page. Defaults to 10.
  final int rowsPerPage;

  /// Whether to show the search text field. Defaults to true.
  final bool searchable;

  /// Placeholder text for the search field.
  final String searchHint;

  /// Optional widget placed to the right of the search field (e.g., dropdowns).
  final Widget? filterWidget;

  /// Client-side row predicate. Return `true` to include the row.
  final bool Function(T row, String query)? filterRow;

  /// Called whenever the search query changes (for server-side search).
  final ValueChanged<String>? onSearchChanged;

  /// Called whenever a sortable column header is tapped.
  final void Function(String columnKey, AdaptiveTableSortDirection direction)?
      onSort;

  /// Message shown when there are no rows to display.
  final String emptyMessage;

  @override
  State<AdaptiveTable<T>> createState() => _AdaptiveTableState<T>();
}

class _AdaptiveTableState<T> extends State<AdaptiveTable<T>> {
  late final TextEditingController _searchController;
  String _searchQuery = '';
  int _currentPage = 0;
  String? _sortColumnKey;
  AdaptiveTableSortDirection _sortDirection =
      AdaptiveTableSortDirection.ascending;

  static const double _defaultColumnWidth = 160;
  static const double _borderOpacity = 0.2;
  static const double _enabledBorderOpacity = 0.5;
  static const double _dividerOpacity = 0.1;
  static const double _rowStripeOpacity = 0.5;
  static const double _disabledIconOpacity = 0.3;

  /// Maximum number of page-number buttons shown at once in the pagination bar.
  /// Seven is a common UX convention that keeps controls compact while still
  /// providing useful context around the current page.
  static const int _maxVisiblePages = 7;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Derived data ─────────────────────────────────────────────────────────────

  List<T> get _processedRows {
    var rows = widget.rows;

    if (_searchQuery.isNotEmpty && widget.filterRow != null) {
      rows = rows.where((r) => widget.filterRow!(r, _searchQuery)).toList();
    }

    if (_sortColumnKey != null) {
      AdaptiveTableColumn<T>? col;
      if (widget.columns.isNotEmpty) {
        for (final c in widget.columns) {
          if (c.key == _sortColumnKey) {
            col = c;
            break;
          }
        }
      }
      if (col != null && col.sortValue != null) {
        rows = List<T>.from(rows)
          ..sort((a, b) {
            final cmp = col!.sortValue!(a).compareTo(col.sortValue!(b));
            return _sortDirection == AdaptiveTableSortDirection.ascending
                ? cmp
                : -cmp;
          });
      }
    }

    return rows;
  }

  int get _pageCount {
    final count =
        (_processedRows.length / widget.rowsPerPage).ceil();
    return count < 1 ? 1 : count;
  }

  List<T> get _currentPageRows {
    final total = _processedRows.length;
    if (total == 0) return [];
    final page = _currentPage.clamp(0, _pageCount - 1);
    final start = page * widget.rowsPerPage;
    final end = (start + widget.rowsPerPage).clamp(0, total);
    return _processedRows.sublist(start, end);
  }

  // ── Event handlers ────────────────────────────────────────────────────────────

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 0;
    });
    widget.onSearchChanged?.call(query);
  }

  void _onSortColumn(String columnKey) {
    setState(() {
      if (_sortColumnKey == columnKey) {
        _sortDirection =
            _sortDirection == AdaptiveTableSortDirection.ascending
                ? AdaptiveTableSortDirection.descending
                : AdaptiveTableSortDirection.ascending;
      } else {
        _sortColumnKey = columnKey;
        _sortDirection = AdaptiveTableSortDirection.ascending;
      }
    });
    widget.onSort?.call(columnKey, _sortDirection);
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.searchable || widget.filterWidget != null)
          _buildToolbar(tokens),
        _buildTableContainer(tokens),
        if (_pageCount > 1) _buildPagination(tokens),
      ],
    );
  }

  // ── Toolbar (search + filter widget) ─────────────────────────────────────────

  Widget _buildToolbar(TokenResolver tokens) {
    final spacing = tokens.spacing;
    return Padding(
      padding: EdgeInsets.only(bottom: spacing.md),
      child: Row(
        children: [
          if (widget.searchable)
            Expanded(child: _buildSearchField(tokens)),
          if (widget.searchable && widget.filterWidget != null)
            SizedBox(width: spacing.md),
          if (widget.filterWidget != null) widget.filterWidget!,
        ],
      ),
    );
  }

  Widget _buildSearchField(TokenResolver tokens) {
    final colors = tokens.colors;
    final radius = tokens.radius;
    final typography = tokens.typography;
    final spacing = tokens.spacing;

    return TextField(
      controller: _searchController,
      onChanged: _onSearch,
      style: typography.bodyMedium.copyWith(color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.searchHint,
        hintStyle: TextStyle(color: colors.textSecondary),
        prefixIcon:
            Icon(Icons.search, color: colors.textSecondary, size: spacing.lg),
        filled: true,
        fillColor: colors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: spacing.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: colors.textSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide:
              BorderSide(color: colors.textSecondary.withValues(alpha: _enabledBorderOpacity)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
    );
  }

  // ── Table ─────────────────────────────────────────────────────────────────────

  /// Total width occupied by all column cells.
  double get _totalColumnWidth => widget.columns.fold<double>(
        0,
        (sum, col) => sum + (col.width ?? _defaultColumnWidth),
      );

  Widget _buildTableContainer(TokenResolver tokens) {
    final colors = tokens.colors;
    final radius = tokens.radius;

    return LayoutBuilder(
      builder: (ctx, constraints) {
        // Ensure the table is at least as wide as its container.
        final tableWidth = _totalColumnWidth < constraints.maxWidth &&
                constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : _totalColumnWidth;

        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(radius.md),
            border: Border.all(
              color: colors.textSecondary.withValues(alpha: _borderOpacity),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius.md),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(tokens),
                    Container(
                      height: 1,
                      color: colors.textSecondary.withValues(alpha: _borderOpacity),
                    ),
                    _currentPageRows.isEmpty
                        ? _buildEmptyState(tokens)
                        : _buildBody(tokens),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(TokenResolver tokens) {
    final colors = tokens.colors;
    final spacing = tokens.spacing;
    final typography = tokens.typography;

    return Container(
      color: colors.background,
      child: Row(
        children: widget.columns.map((col) {
          final isSorted = _sortColumnKey == col.key;

          Widget labelWidget = Text(
            col.label,
            style:
                typography.labelLarge.copyWith(color: colors.textPrimary),
          );

          if (col.sortable) {
            labelWidget = GestureDetector(
              onTap: () => _onSortColumn(col.key),
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  labelWidget,
                  SizedBox(width: spacing.xs),
                  Icon(
                    isSorted
                        ? (_sortDirection ==
                                AdaptiveTableSortDirection.ascending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward)
                        : Icons.unfold_more,
                    size: spacing.md,
                    color:
                        isSorted ? colors.primary : colors.textSecondary,
                  ),
                ],
              ),
            );
          }

          return _buildCell(
            width: col.width,
            padding: EdgeInsets.symmetric(
              horizontal: spacing.md,
              vertical: spacing.md,
            ),
            child: labelWidget,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBody(TokenResolver tokens) {
    final pageRows = _currentPageRows;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageRows.length, (i) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDataRow(tokens, pageRows[i], i),
            if (i < pageRows.length - 1)
              Container(
                height: 1,
                color: tokens.colors.textSecondary.withValues(alpha: _dividerOpacity),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildDataRow(TokenResolver tokens, T row, int index) {
    final colors = tokens.colors;
    final spacing = tokens.spacing;

    return Container(
      color: index.isEven
          ? colors.surface
          : colors.background.withValues(alpha: _rowStripeOpacity),
      child: Row(
        children: widget.columns.map((col) {
          return _buildCell(
            width: col.width,
            padding: EdgeInsets.symmetric(
              horizontal: spacing.md,
              vertical: spacing.md,
            ),
            child: col.cellBuilder(context, row),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCell({
    required Widget child,
    required EdgeInsets padding,
    double? width,
  }) {
    return SizedBox(
      width: width ?? _defaultColumnWidth,
      child: Padding(padding: padding, child: child),
    );
  }

  Widget _buildEmptyState(TokenResolver tokens) {
    final colors = tokens.colors;
    final spacing = tokens.spacing;
    final typography = tokens.typography;

    return Padding(
      padding: EdgeInsets.all(spacing.xxxl),
      child: Text(
        widget.emptyMessage,
        style: typography.bodyMedium.copyWith(color: colors.textSecondary),
      ),
    );
  }

  // ── Pagination ────────────────────────────────────────────────────────────────

  Widget _buildPagination(TokenResolver tokens) {
    final colors = tokens.colors;
    final spacing = tokens.spacing;
    final typography = tokens.typography;
    final radius = tokens.radius;

    final total = _processedRows.length;
    final page = _currentPage.clamp(0, _pageCount - 1);
    final start = total == 0 ? 0 : page * widget.rowsPerPage + 1;
    final end = (page + 1) * widget.rowsPerPage > total
        ? total
        : (page + 1) * widget.rowsPerPage;

    return Padding(
      padding: EdgeInsets.only(top: spacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            total == 0 ? 'No results' : '$start–$end of $total',
            style: typography.bodySmall.copyWith(color: colors.textSecondary),
          ),
          Row(
            children: [
              _buildNavButton(
                icon: Icons.chevron_left,
                enabled: _currentPage > 0,
                onTap: () => setState(() => _currentPage--),
                tokens: tokens,
              ),
              SizedBox(width: spacing.xs),
              ..._buildPageButtons(tokens, radius),
              SizedBox(width: spacing.xs),
              _buildNavButton(
                icon: Icons.chevron_right,
                enabled: _currentPage < _pageCount - 1,
                onTap: () => setState(() => _currentPage++),
                tokens: tokens,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageButtons(TokenResolver tokens, RadiusTokens radius) {
    final colors = tokens.colors;
    final spacing = tokens.spacing;
    final typography = tokens.typography;

    // Show at most _maxVisiblePages buttons; use ellipsis for large page counts.
    final pages = _visiblePageIndices(_pageCount, _currentPage, _maxVisiblePages);

    final widgets = <Widget>[];
    int? prev;
    for (final i in pages) {
      if (prev != null && i - prev > 1) {
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.xs),
            child: Text(
              '…',
              style: typography.bodySmall
                  .copyWith(color: colors.textSecondary),
            ),
          ),
        );
      }
      final isActive = i == _currentPage;
      widgets.add(
        Padding(
          padding: EdgeInsets.only(right: spacing.xs),
          child: GestureDetector(
            onTap: () => setState(() => _currentPage = i),
            child: Container(
              width: spacing.xxl,
              height: spacing.xxl,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive ? colors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(radius.sm),
                border: isActive
                    ? null
                    : Border.all(
                        color: colors.textSecondary.withValues(alpha: _disabledIconOpacity),
                      ),
              ),
              child: Text(
                '${i + 1}',
                style: typography.labelSmall.copyWith(
                  color: isActive ? colors.onPrimary : colors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      );
      prev = i;
    }
    return widgets;
  }

  /// Returns the page indices to display in the pagination bar, with gaps
  /// representing ellipsis positions.
  static List<int> _visiblePageIndices(
      int pageCount, int current, int maxVisible) {
    if (pageCount <= maxVisible) {
      return List.generate(pageCount, (i) => i);
    }
    // Always include first and last page; fill remaining slots around current.
    final half = maxVisible ~/ 2;
    var start = (current - half).clamp(0, pageCount - maxVisible);
    final end = (start + maxVisible - 1).clamp(0, pageCount - 1);
    start = (end - maxVisible + 1).clamp(0, pageCount - 1);
    return List.generate(maxVisible, (i) => start + i);
  }

  Widget _buildNavButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    required TokenResolver tokens,
  }) {
    final colors = tokens.colors;
    final spacing = tokens.spacing;
    final radius = tokens.radius;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: spacing.xxl,
        height: spacing.xxl,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius.sm),
          border: Border.all(
            color: enabled
                ? colors.textSecondary.withValues(alpha: _disabledIconOpacity)
                : colors.textSecondary.withValues(alpha: _borderOpacity),
          ),
        ),
        child: Icon(
          icon,
          size: spacing.lg,
          color: enabled
              ? colors.textPrimary
              : colors.textSecondary.withValues(alpha: _disabledIconOpacity),
        ),
      ),
    );
  }
}
