import 'package:flutter/material.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';

class _Person {
  const _Person(this.id, this.name, this.role, this.status);
  final String id;
  final String name;
  final String role;
  final String status;
}

class TableDemoScreen extends StatefulWidget {
  const TableDemoScreen({super.key});

  @override
  State<TableDemoScreen> createState() => _TableDemoScreenState();
}

class _TableDemoScreenState extends State<TableDemoScreen> {
  final List<_Person> _people = [
    const _Person('1', 'Alice Smith', 'Admin', 'Active'),
    const _Person('2', 'Bob Jones', 'User', 'Inactive'),
    const _Person('3', 'Charlie Brown', 'Editor', 'Active'),
    const _Person('4', 'Diana Prince', 'User', 'Active'),
    const _Person('5', 'Evan Wright', 'Admin', 'Inactive'),
    const _Person('6', 'Fiona Gallagher', 'User', 'Active'),
    const _Person('7', 'George Costanza', 'Editor', 'Active'),
    const _Person('8', 'Hannah Abbott', 'User', 'Inactive'),
    const _Person('9', 'Ian Malcolm', 'Admin', 'Active'),
    const _Person('10', 'Jane Doe', 'User', 'Active'),
    const _Person('11', 'Kevin Bacon', 'Editor', 'Inactive'),
    const _Person('12', 'Laura Palmer', 'User', 'Active'),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final spacing = tokens.spacing;
    final typography = tokens.typography;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        title: const Text('Data Table'),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: AdaptiveTable<_Person>(
          columns: [
            AdaptiveTableColumn(
              key: 'id',
              label: 'ID',
              cellBuilder: (ctx, p) => Text(p.id, style: typography.bodyMedium.copyWith(color: colors.textPrimary)),
              sortable: true,
              sortValue: (p) => int.parse(p.id),
              width: 80,
            ),
            AdaptiveTableColumn(
              key: 'name',
              label: 'Name',
              cellBuilder: (ctx, p) => Text(p.name, style: typography.bodyMedium.copyWith(color: colors.textPrimary)),
              sortable: true,
              sortValue: (p) => p.name,
            ),
            AdaptiveTableColumn(
              key: 'role',
              label: 'Role',
              cellBuilder: (ctx, p) => Text(p.role, style: typography.bodyMedium.copyWith(color: colors.textSecondary)),
              sortable: true,
              sortValue: (p) => p.role,
            ),
            AdaptiveTableColumn(
              key: 'status',
              label: 'Status',
              cellBuilder: (ctx, p) {
                final isActive = p.status == 'Active';
                return AdaptiveInfoChip(
                  label: p.status,
                  icon: isActive ? Icons.check_circle : Icons.cancel,
                  color: isActive ? Colors.green : Colors.red,
                );
              },
              sortable: true,
              sortValue: (p) => p.status,
            ),
          ],
          rows: _people,
          filterRow: (person, query) {
            final q = query.toLowerCase();
            return person.name.toLowerCase().contains(q) ||
                   person.role.toLowerCase().contains(q) ||
                   person.status.toLowerCase().contains(q);
          },
          rowsPerPage: 5,
        ),
      ),
    );
  }
}
