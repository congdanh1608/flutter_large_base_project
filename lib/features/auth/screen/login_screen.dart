import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dt_digital_studio/core/router/route_names.dart';
import 'package:dt_digital_studio/shared/widgets/reactive_forms/custom_reactive_text_field.dart';
import 'package:dt_digital_studio/shared/widgets/app_button.dart';

import '../provider/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final FormGroup _form;

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      'email': FormControl<String>(
        value: '',
        validators: [Validators.required, Validators.email],
      ),
      'password': FormControl<String>(
        value: '',
        validators: [
          Validators.required,
          Validators.minLength(6),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_form.invalid) {
      _form.markAllAsTouched();
      return;
    }
    final email = _form.control('email').value as String;
    final password = _form.control('password').value as String;
    final success = await ref.read(authNotifierProvider.notifier).login(
          email: email.trim(),
          password: password,
        );
    if (success && mounted) {
      context.goNamed(RouteNames.homeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ReactiveForm(
            formGroup: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text('Welcome back 👋', style: theme.textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(
                  'Sign in to your account',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 40),
                CustomReactiveTextField(
                  formControlName: 'email',
                  label: 'Email',
                  hint: 'you@example.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Email is required',
                    ValidationMessage.email: (_) => 'Enter a valid email',
                  },
                ),
                const SizedBox(height: 16),
                CustomReactiveTextField(
                  formControlName: 'password',
                  label: 'Password',
                  isPassword: true,
                  prefixIcon: Icons.lock_outlined,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onSubmitted: (_) => _onLogin(),
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Password is required',
                    ValidationMessage.minLength: (_) =>
                        'Password must be at least 6 characters',
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot password?'),
                  ),
                ),
                const SizedBox(height: 24),
                if (authState.hasError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      authState.errorMessage ?? '',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                AppButton(
                  label: 'Sign In',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _onLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
