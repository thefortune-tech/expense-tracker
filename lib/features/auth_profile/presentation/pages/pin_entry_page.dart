import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/profile_notifier.dart';
import '../providers/profile_state.dart';

class PinEntryPage extends ConsumerStatefulWidget {
  const PinEntryPage({super.key});

  @override
  ConsumerState<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends ConsumerState<PinEntryPage> {
  final _pinController = TextEditingController();
  bool _wasWrong = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _submit() {
    final pin = _pinController.text.trim();
    if (pin.length != 4) return;

    ref.read(profileNotifierProvider.notifier).verifyPin(pin);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileNotifierProvider);
    final profileName = state.profile?.name ?? '';

    ref.listen(profileNotifierProvider, (previous, next) {
      if (next.status == ProfileStatus.needsPinEntry &&
          previous?.status == ProfileStatus.needsPinEntry) {
        setState(() => _wasWrong = true);
        _pinController.clear();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome back, $profileName',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your PIN to continue',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, letterSpacing: 8),
                decoration: InputDecoration(
                  counterText: '',
                  border: const OutlineInputBorder(),
                  errorText: _wasWrong ? 'Incorrect PIN, try again' : null,
                ),
                onChanged: (value) {
                  if (_wasWrong) setState(() => _wasWrong = false);
                  if (value.length == 4) _submit();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}