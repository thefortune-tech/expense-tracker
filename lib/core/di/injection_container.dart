import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/auth_profile/data/datasources/profile_local_datasource.dart';
import '../../features/auth_profile/data/models/user_profile_model.dart';
import '../../features/auth_profile/data/repositories/profile_repository_impl.dart';
import '../../features/auth_profile/domain/repositories/profile_repository.dart';
import '../../features/auth_profile/domain/usecases/create_profile.dart';
import '../../features/auth_profile/domain/usecases/get_current_profile.dart';
import '../../features/auth_profile/domain/usecases/update_profile.dart';
import '../../features/auth_profile/domain/usecases/verify_pin.dart';
import '../../features/budget/data/datasources/budget_local_datasource.dart';
import '../../features/budget/data/models/budget_model.dart';
import '../../features/budget/data/repositories/budget_repository_impl.dart';
import '../../features/budget/domain/repositories/budget_repository.dart';
import '../../features/budget/domain/usecases/delete_budget.dart';
import '../../features/budget/domain/usecases/get_budget_for_category.dart';
import '../../features/budget/domain/usecases/get_budgets_for_month.dart';
import '../../features/budget/domain/usecases/set_budget.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_summary.dart';
import '../../features/transactions/data/datasources/transaction_local_datasource.dart';
import '../../features/transactions/data/models/transaction_model.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/domain/usecases/add_transaction.dart';
import '../../features/transactions/domain/usecases/delete_transaction.dart';
import '../../features/transactions/domain/usecases/get_all_transactions.dart';
import '../../features/transactions/domain/usecases/get_transaction_by_id.dart';
import '../../features/transactions/domain/usecases/update_transaction.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await Hive.initFlutter();

  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(UserProfileModelAdapter());
  Hive.registerAdapter(BudgetModelAdapter());

  final transactionBox = await Hive.openBox<TransactionModel>('transactions_box');
  final profileBox = await Hive.openBox<UserProfileModel>('profile_box');
  final budgetBox = await Hive.openBox<BudgetModel>('budget_box');

  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(transactionBox),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));
  sl.registerLazySingleton(() => GetAllTransactions(sl()));
  sl.registerLazySingleton(() => GetTransactionById(sl()));

  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(profileBox),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => CreateProfile(sl()));
  sl.registerLazySingleton(() => GetCurrentProfile(sl()));
  sl.registerLazySingleton(() => VerifyPin(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));

  sl.registerLazySingleton<BudgetLocalDataSource>(
    () => BudgetLocalDataSourceImpl(budgetBox),
  );
  sl.registerLazySingleton<BudgetRepository>(
    () => BudgetRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => SetBudget(sl()));
  sl.registerLazySingleton(() => GetBudgetsForMonth(sl()));
  sl.registerLazySingleton(() => GetBudgetForCategory(sl()));
  sl.registerLazySingleton(() => DeleteBudget(sl()));

  sl.registerLazySingleton(() => GetDashboardSummary(sl(), sl()));
}