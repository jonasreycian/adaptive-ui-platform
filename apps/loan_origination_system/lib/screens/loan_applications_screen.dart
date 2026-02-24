import 'package:flutter/material.dart';
import 'package:adaptive_components/adaptive_components.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
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

const _sampleRecords = <_LoanRecord>[
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

/// Demonstrates [AdaptiveTable] in the Loan Origination System demo app.
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

  // ── Columns ───────────────────────────────────────────────────────────────

  List<AdaptiveTableColumn<_LoanRecord>> get _columns => [
        AdaptiveTableColumn<_LoanRecord>(
          key: 'reference',
          label: 'Reference',
          width: 140,
          sortable: true,
          sortValue: (r) => r.reference,
          cellBuilder: (_, r) => Text(
            r.reference,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
        AdaptiveTableColumn<_LoanRecord>(
          key: 'applicant',
          label: 'Applicant',
          width: 160,
          sortable: true,
          sortValue: (r) => r.applicantName,
          cellBuilder: (_, r) => Text(
            r.applicantName,
            style: AppTypography.bodyLarge,
          ),
        ),
        AdaptiveTableColumn<_LoanRecord>(
          key: 'amount',
          label: 'Amount',
          width: 120,
          sortable: true,
          sortValue: (r) => r.amount,
          cellBuilder: (_, r) => Text(
            _formatAmount(r.amount),
            style: AppTypography.labelLarge,
          ),
        ),
        AdaptiveTableColumn<_LoanRecord>(
          key: 'purpose',
          label: 'Purpose',
          width: 160,
          sortable: true,
          sortValue: (r) => r.purpose,
          cellBuilder: (_, r) => Text(
            r.purpose,
            style: AppTypography.bodyMedium,
          ),
        ),
        AdaptiveTableColumn<_LoanRecord>(
          key: 'tenure',
          label: 'Tenure',
          width: 110,
          cellBuilder: (_, r) => Text(
            r.tenure,
            style: AppTypography.bodyMedium,
          ),
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
          cellBuilder: (_, r) => Text(
            _formatDate(r.dateApplied),
            style: AppTypography.bodyMedium,
          ),
        ),
      ];

  // ── Helpers ───────────────────────────────────────────────────────────────

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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(
              Icons.account_balance,
              color: AppColors.textOnAccent,
              size: 20,
            ),
          ),
        ),
        title: const Text('Loan Applications'),
      ),
      backgroundColor: AppColors.background,
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
            _buildStatusFilterRow(),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: AdaptiveTable<_LoanRecord>(
                columns: _columns,
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

  Widget _buildStatusFilterRow() {
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
              () => _statusFilter =
                  _statusFilter == _LoanStatus.underReview
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
      return AppColors.warning;
    case _LoanStatus.underReview:
      return AppColors.info;
    case _LoanStatus.approved:
      return AppColors.success;
    case _LoanStatus.rejected:
      return AppColors.error;
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
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        _statusLabel(status),
        style: AppTypography.labelSmall.copyWith(
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
    final chipColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? chipColor.withOpacity(0.12) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: selected ? chipColor : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: selected ? chipColor : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
