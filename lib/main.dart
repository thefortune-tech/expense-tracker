import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart' as di;
import 'core/presentation/app_shell.dart';
import 'core/theme/app_theme.dart';
import 'features/auth_profile/presentation/pages/pin_entry_page.dart';
import 'features/auth_profile/presentation/pages/profile_setup_page.dart';
import 'features/auth_profile/presentation/providers/profile_notifier.dart';
import 'features/auth_profile/presentation/providers/profile_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const ProviderScope(child: ExpenseTrackerApp()));
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const _AppRouter(),
    );
  }
}

class _AppRouter extends ConsumerWidget {
  const _AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileNotifierProvider);

    switch (state.status) {
      case ProfileStatus.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case ProfileStatus.needsSetup:
        return const ProfileSetupPage();
      case ProfileStatus.needsPinEntry:
        return const PinEntryPage();
      case ProfileStatus.unlocked:
        return const AppShell();
      case ProfileStatus.error:
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                state.errorMessage ?? 'Something went wrong',
                style: const TextStyle(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
    }
  }
}
