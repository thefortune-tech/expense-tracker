import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transactions/presentation/widgets/transaction_list_tile.dart';

void main() {
  final tExpense = Transaction(
    id: 't1',
    amount: 1500,
    currencyCode: 'NGN',
    category: 'Food',
    date: DateTime(2026, 7, 20),
    note: 'Lunch at work',
    type: TransactionType.expense,
  );

  final tIncome = Transaction(
    id: 't2',
    amount: 100000,
    currencyCode: 'NGN',
    category: 'Salary',
    date: DateTime(2026, 7, 1),
    note: '',
    type: TransactionType.income,
  );

  Widget wrap(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('TransactionListTile', () {
    testWidgets(
      'displays category and formatted amount with minus sign for expenses',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            TransactionListTile(
              transaction: tExpense,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        );

        expect(find.text('Food'), findsOneWidget);
        expect(find.text('-₦1,500.00'), findsOneWidget);
      },
    );

    testWidgets('displays formatted amount with plus sign for income', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TransactionListTile(
            transaction: tIncome,
            onTap: () {},
            onDelete: () {},
          ),
        ),
      );

      expect(find.text('+₦100,000.00'), findsOneWidget);
    });

    testWidgets('displays the note when present', (tester) async {
      await tester.pumpWidget(
        wrap(
          TransactionListTile(
            transaction: tExpense,
            onTap: () {},
            onDelete: () {},
          ),
        ),
      );

      expect(find.text('Lunch at work'), findsOneWidget);
    });

    testWidgets('does not display a subtitle when note is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TransactionListTile(
            transaction: tIncome,
            onTap: () {},
            onDelete: () {},
          ),
        ),
      );

      expect(find.byType(ListTile), findsOneWidget);
      final listTile = tester.widget<ListTile>(find.byType(ListTile));
      expect(listTile.subtitle, isNull);
    });

    testWidgets('calls onTap when the tile is tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        wrap(
          TransactionListTile(
            transaction: tExpense,
            onTap: () => tapped = true,
            onDelete: () {},
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('calls onDelete when swiped away', (tester) async {
      var deleted = false;

      await tester.pumpWidget(
        wrap(
          TransactionListTile(
            transaction: tExpense,
            onTap: () {},
            onDelete: () => deleted = true,
          ),
        ),
      );

      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(deleted, true);
    });
  });
}
