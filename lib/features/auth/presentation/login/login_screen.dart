import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/mood_palette.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/auth_repository.dart';
import '../session/session_cubit.dart';
import '../widgets/auth_scaffold.dart';
import 'login_cubit.dart';

/// US-02. Figma: Page 2, frame "iPhone 13 & 14 - 92" (node 881:50).
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        repository: context.read<AuthRepository>(),
        session: context.read<SessionCubit>(),
      ),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  late final TapGestureRecognizer _registerTap = TapGestureRecognizer()
    ..onTap = () => context.push(Routes.register);

  @override
  void initState() {
    super.initState();
    // "Сесія завершилась..." and similar notices from the session.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final session = context.read<SessionCubit>();
      final message = session.state.message;
      if (message != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        session.clearMessage();
      }
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _registerTap.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context
        .read<LoginCubit>()
        .submit(email: _email.text, password: _password.text);
  }

  void _forgotPassword() {
    // US-03 is planned for sprint II.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Відновлення пароля буде доступне незабаром')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = MoodPalette.of(context);
    final state = context.watch<LoginCubit>().state;

    return AuthScaffold(
      footer: Center(
        child: Text.rich(
          TextSpan(
            style: AppText.small(p),
            children: [
              const TextSpan(text: 'Не зареєстровані? '),
              TextSpan(
                text: 'Зареєструватись',
                style: AppText.small(p, weight: FontWeight.w800),
                recognizer: _registerTap,
              ),
            ],
          ),
        ),
      ),
      children: [
        const SizedBox(height: 72),
        Text('Вхід до акаунту', style: AppText.headline(p)),
        const SizedBox(height: 8),
        Text('Відслідковуй свій настрій', style: AppText.body(p)),
        const SizedBox(height: 80),
        AutofillGroup(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: 'Email',
                  icon: Icons.mail_outline,
                  hint: 'name@example.com',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: Validators.email,
                  onChanged: (_) => context.read<LoginCubit>().clearError(),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Пароль',
                  icon: Icons.lock_outline,
                  controller: _password,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: Validators.requiredPassword,
                  onChanged: (_) => context.read<LoginCubit>().clearError(),
                  suffix: IconButton(
                    tooltip: _obscure ? 'Показати пароль' : 'Сховати пароль',
                    icon: Icon(
                      _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: p.text,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _forgotPassword,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: p.text,
            ),
            child: Text(
              'Забули пароль?',
              style: AppText.small(p, weight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 40),
        FormErrorText(state.error),
        PrimaryButton(
          label: 'Увійти',
          loading: state.submitting,
          onPressed: _submit,
        ),
      ],
    );
  }
}
