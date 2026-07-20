import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../widgets/transaction_list_tile.dart';
import 'add_edit_transaction_page.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TransactionBloc>()..add(const LoadTransactions()),
      child: const _TransactionListView(),
    );
  }
}

class _TransactionListView extends StatelessWidget {
  const _TransactionListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state.status == TransactionStatus.loading || state.status == TransactionStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TransactionStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Something went wrong',
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }

          final grouped = state.groupedByDay;

          if (grouped.isEmpty) {
            return const Center(
              child: Text(
                'No transactions yet',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: sortedKeys.length,
            itemBuilder: (context, index) {
              final dayKey = sortedKeys[index];
              final dayTransactions = grouped[dayKey]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Text(
                      dayKey,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  ...dayTransactions.map((t) => TransactionListTile(
                        transaction: t,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<TransactionBloc>(),
                              child: AddEditTransactionPage(existingTransaction: t),
                            ),
                          ),
                        ),
                        onDelete: () => context
                            .read<TransactionBloc>()
                            .add(DeleteTransactionEvent(t.id)),
                      )),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<TransactionBloc>(),
              child: const AddEditTransactionPage(),
            ),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

void _showFilterSheet(BuildContext context) {
  final bloc = context.read<TransactionBloc>();

  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    builder: (sheetContext) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by type',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('All'),
                  onPressed: () {
                    bloc.add(const FilterTransactions());
                    Navigator.pop(sheetContext);
                  },
                ),
                ActionChip(
                  label: const Text('Expenses'),
                  onPressed: () {
                    bloc.add(const FilterTransactions(type: TransactionType.expense));
                    Navigator.pop(sheetContext);
                  },
                ),
                ActionChip(
                  label: const Text('Income'),
                  onPressed: () {
                    bloc.add(const FilterTransactions(type: TransactionType.income));
                    Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}