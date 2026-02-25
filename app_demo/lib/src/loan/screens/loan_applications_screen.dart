import 'package:flutter/material.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';
import 'package:intl/intl.dart';

import '../theme/loan_theme.dart';
import '../widgets/common_widgets.dart';

// ---------------------------------------------------------------------------
// Demo Data Model
// ---------------------------------------------------------------------------

enum _LoanStatus { pending, underReview, approved, rejected }

class _LoanRecord {
  const _LoanRecord({
    required this.reference,
    required this.applicantName,
    required this.amount,
    required this.purpose,
    required this.tenure,
    required this.status,
    required this.dateApplied,
  });

  final String reference;
  final String applicantName;
  final double amount;
  final String purpose;
  final String tenure;
  final _LoanStatus status;
  final DateTime dateApplied;
}

final _sampleRecords = <_LoanRecord>[
  _LoanRecord(
    reference: 'LOS-2024001',
    applicantName: 'Alice Johnson',
    amount: 25000,
    purpose: 'Home Purchase',
    tenure: '360 months',
    status: _LoanStatus.approved,
    dateApplied: DateTime(2024, 1, 5),
  ),
  _LoanRecord(
    reference: 'LOS-2024002',
    applicantName: 'Bob Martinez',
    amount: 8500,
    purpose: 'Auto Loan',
    tenure: '60 months',
    status: _LoanStatus.underReview,
    dateApplied: DateTime(2024, 1, 10),
  ),
  _LoanRecord(
    reference: 'LOS-2024003',
    applicantName: 'Carol Smith',
    amount: 15000,
    purpose: 'Education',
    tenure: '84 months',
    status: _LoanStatus.pending,
    dateApplied: DateTime(2024, 1, 14),
  ),
  _LoanRecord(
    reference: 'LOS-2024004',
    applicantName: 'David Lee',
    amount: 50000,
    purpose: 'Business Capital',
    tenure: '120 months',
    status: _LoanStatus.rejected,
    dateApplied: DateTime(2024, 1, 18),
  ),
  _LoanRecord(
    reference: 'LOS-2024005',
    applicantName: 'Eva Brown',
    amount: 5000,
    purpose: 'Personal/Travel',
    tenure: '24 months',
    status: _LoanStatus.approved,
    dateApplied: DateTime(2024, 1, 22),
  ),
  _LoanRecord(
    reference: 'LOS-2024006',
    applicantName: 'Frank Wilson',
    amount: 32000,
    purpose: 'Home Renovation',
    tenure: '180 months',
    status: _LoanStatus.underReview,
    dateApplied: DateTime(2024, 2, 1),
  ),
  _LoanRecord(
    reference: 'LOS-2024007',
    applicantName: 'Grace Taylor',
    amount: 12000,
    purpose: 'Debt Consolidation',
    tenure: '48 months',
    status: _LoanStatus.pending,
    dateApplied: DateTime(2024, 2, 5),
  ),
  _LoanRecord(
    reference: 'LOS-2024008',
    applicantName: 'Henry Davis',
    amount: 7500,
    purpose: 'Medical Expenses',
    tenure: '36 months',
    status: _LoanStatus.approved,
    dateApplied: DateTime(2024, 2, 8),
  ),
  _LoanRecord(
    reference: 'LOS-2024009',
    applicantName: 'Irene Clark',
    amount: 45000,
    purpose: 'Business Capital',
    tenure: '240 months',
    status: _LoanStatus.underReview,
    dateApplied: DateTime(2024, 2, 12),
  ),
  _LoanRecord(
    reference: 'LOS-2024010',
    applicantName: 'James White',
    amount: 3000,
    purpose: 'Personal/Travel',
    tenure: '12 months',
    status: _LoanStatus.rejected,
    dateApplied: DateTime(2024, 2, 15),
  ),
  _LoanRecord(
    reference: 'LOS-2024011',
    applicantName: 'Karen Hall',
    amount: 20000,
    purpose: 'Auto Loan',
    tenure: '60 months',
    status: _LoanStatus.approved,
    dateApplied: DateTime(2024, 2, 19),
  ),
  _LoanRecord(
    reference: 'LOS-2024012',
    applicantName: 'Liam Allen',
    amount: 60000,
    purpose: 'Home Purchase',
    tenure: '360 months',
    status: _LoanStatus.pending,
    dateApplied: DateTime(2024, 2, 22),
  ),
  _LoanRecord(
    reference: 'LOS-2024013',
    applicantName: 'Mia Young',
    amount: 9000,
    purpose: 'Education',
    tenure: '48 months',
    status: _LoanStatus.underReview,
    dateApplied: DateTime(2024, 3, 2),
  ),
  _LoanRecord(
    reference: 'LOS-2024014',
    applicantName: 'Noah King',
    amount: 11500,
    purpose: 'Debt Consolidation',
    tenure: '36 months',
    status: _LoanStatus.approved,
    dateApplied: DateTime(2024, 3, 6),
  ),
  _LoanRecord(
    reference: 'LOS-2024015',
    applicantName: 'Olivia Scott',
    amount: 27000,
    purpose: 'Home Renovation',
    tenure: '120 months',
    status: _LoanStatus.rejected,
    dateApplied: DateTime(2024, 3, 10),
  ),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

/// Demonstrates [AdaptiveTable] in the Loan Origination demo section.
///
/// Shows a paginated, searchable, sortable list of loan applications.
/// A status filter chip row lets users narrow down results by loan status.
class LoanApplicationsScreen extends StatefulWidget {
  const LoanApplicationsScreen({super.key});

  @override
  State<LoanApplicationsScreen> createState() =>
      _LoanApplicationsScreenState();
}

class _LoanApplicationsScreenState extends State<LoanApplicationsScreen> {
  _LoanStatus? _statusFilter;

  List<AdaptiveTableColumn<_LoanRecord>> _columns(
    ColorTokens colors,
  ) =>
      [
        AdaptiveTableColumn<_LoanRecord>(
          key: 'reference',
          label: 'Reference',
          width: 140,
          sortable: true,
          sortValue: (r) => r.reference,
          cellBuilder: (_, r) => Text(
            r.reference,
            style: const TextStyle(fontWeight: FontWeight.w600)
                .copyWith(color: colors.primary),
          ),
        ),
        AdaptiveTableColumn<_LoanRecord>(
          key: 'applicant',
          label: 'Applicant',
          width: 160,
          sortable: true,
          sortValue: (r) => r.applicantName,
          cellBuilder: (_, r) => Text(r.applicantName),
        ),
        AdaptiveTableColumn<_LoanRecord>(
          key: 'amount',
          label: 'Amount',
          width: 120,
          sortable: true,
          sortValue: (r) => r.amount,
          cellBuilder: (_, r) => Text(
            _formatAmount(r.amount),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        AdaptiveTableColumn<_LoanRecord>(
          key: 'purpose',
          label: 'Purpose',
          width: 160,
          sortable: true,
          sortValue: (r) => r.purpose,
          cellBuilder: (_, r) => Text(r.purpose),
        ),
        AdaptiveTableColumn<_LoanRecord>(
          key: 'tenure',
          label: 'Tenure',
          width: 110,
          cellBuilder: (_, r) => Text(r.tenure),
        ),
        AdaptiveTableColumn<_LoanRecord>(
          key: 'status',
          label: 'Status',
          width: 130,
          sortable: true,
          sortValue: (r) => r.status.index,
          cellBuilder: (_, r) => _StatusBadge(status: r.status),
        ),
        AdaptiveTableColumn<_LoanRecord>(
          key: 'date',
          label: 'Date Applied',
          width: 130,
          sortable: true,
          sortValue: (r) => r.dateApplied.millisecondsSinceEpoch,
          cellBuilder: (_, r) => Text(_formatDate(r.dateApplied)),
        ),
      ];

  static String _formatAmount(double amount) =>
      NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(amount);

  static String _formatDate(DateTime d) =>
      DateFormat('yyyy-MM-dd').format(d);

  List<_LoanRecord> get _filteredRows {
    if (_statusFilter == null) return _sampleRecords;
    return _sampleRecords
        .where((r) => r.status == _statusFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Container(
            decoration: BoxDecoration(
              color: colors.accent,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              Icons.account_balance,
              color: colors.onAccent,
              size: 20,
            ),
          ),
        ),
        title: const Text('Loan Applications'),
      ),
      backgroundColor: colors.background,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Applications Dashboard',
              subtitle: 'Search, filter and sort loan applications',
              icon: Icons.table_chart_outlined,
            ),
            _buildStatusFilterRow(colors),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: AdaptiveTable<_LoanRecord>(
                columns: _columns(colors),
                rows: _filteredRows,
                rowsPerPage: 5,
                searchHint: 'Search by reference or applicant…',
                filterRow: (record, query) {
                  final q = query.toLowerCase();
                  return record.reference.toLowerCase().contains(q) ||
                      record.applicantName.toLowerCase().contains(q) ||
                      record.purpose.toLowerCase().contains(q);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilterRow(ColorTokens colors) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            selected: _statusFilter == null,
            onTap: () => setState(() => _statusFilter = null),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: 'Pending',
            selected: _statusFilter == _LoanStatus.pending,
            onTap: () => setState(
              () => _statusFilter = _statusFilter == _LoanStatus.pending
                  ? null
                  : _LoanStatus.pending,
            ),
            color: _statusColor(_LoanStatus.pending),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: 'Under Review',
            selected: _statusFilter == _LoanStatus.underReview,
            onTap: () => setState(
              () =>
                  _statusFilter = _statusFilter == _LoanStatus.underReview
                      ? null
                      : _LoanStatus.underReview,
            ),
            color: _statusColor(_LoanStatus.underReview),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: 'Approved',
            selected: _statusFilter == _LoanStatus.approved,
            onTap: () => setState(
              () => _statusFilter = _statusFilter == _LoanStatus.approved
                  ? null
                  : _LoanStatus.approved,
            ),
            color: _statusColor(_LoanStatus.approved),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: 'Rejected',
            selected: _statusFilter == _LoanStatus.rejected,
            onTap: () => setState(
              () => _statusFilter = _statusFilter == _LoanStatus.rejected
                  ? null
                  : _LoanStatus.rejected,
            ),
            color: _statusColor(_LoanStatus.rejected),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status helpers
// ---------------------------------------------------------------------------

Color _statusColor(_LoanStatus status) {
  switch (status) {
    case _LoanStatus.pending:
      return LoanColors.warning;
    case _LoanStatus.underReview:
      return LoanColors.info;
    case _LoanStatus.approved:
      return LoanColors.success;
    case _LoanStatus.rejected:
      return LoanColors.warning; // will use error via TokenResolver below
  }
}

String _statusLabel(_LoanStatus status) {
  switch (status) {
    case _LoanStatus.pending:
      return 'Pending';
    case _LoanStatus.underReview:
      return 'Under Review';
    case _LoanStatus.approved:
      return 'Approved';
    case _LoanStatus.rejected:
      return 'Rejected';
  }
}

// ---------------------------------------------------------------------------
// Status Badge widget
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final _LoanStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = TokenResolver.of(context).colors;
    final typography = TokenResolver.of(context).typography;
    // Use the platform error token for rejected status
    final color = status == _LoanStatus.rejected
        ? colors.error
        : _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        _statusLabel(status),
        style: typography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter Chip widget
// ---------------------------------------------------------------------------

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final typography = tokens.typography;
    final chipColor = color ?? colors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected
              ? chipColor.withValues(alpha: 0.12)
              : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: selected ? chipColor : LoanColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: typography.labelSmall.copyWith(
            color: selected ? chipColor : colors.textSecondary,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
