import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/mood_palette.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/back_pill.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/auth_repository.dart';
import '../session/session_cubit.dart';
import '../widgets/auth_scaffold.dart';
import 'register_cubit.dart';

/// US-01. Figma: Page 2, frame "iPhone 13 & 14 - 98" (node 881:301).
///
/// BR8: when the birth date gives an age under 14, the parent/guardian email
/// and consent fields appear right under the date (no separate mockup yet).
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(
        repository: context.read<AuthRepository>(),
        session: context.read<SessionCubit>(),
      ),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _birthDateText = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _parentEmail = TextEditingController();
  final _dateFormat = DateFormat('dd.MM.yyyy');

  DateTime? _birthDate;
  bool _consent = false;
  bool _consentError = false;
  bool _obscure = true;

  bool get _under14 => isUnder14(_birthDate);

  @override
  void dispose() {
    _name.dispose();
    _birthDateText.dispose();
    _email.dispose();
    _password.dispose();
    _parentEmail.dispose();
    super.dispose();
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.login);
    }
  }

  Future<void> _pickBirthDate() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Дата народження',
    );
    if (picked == null || !mounted) return;
    setState(() {
      _birthDate = picked;
      _birthDateText.text = _dateFormat.format(picked);
      if (!_under14) {
        _consent = false;
        _consentError = false;
        _parentEmail.clear();
      }
    });
    context.read<RegisterCubit>().clearFieldError('birth_date');
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final formValid = _formKey.currentState?.validate() ?? false;
    setState(() => _consentError = _under14 && !_consent);
    if (!formValid || _consentError) return;

    context.read<RegisterCubit>().submit(RegistrationData(
          firstName: _name.text,
          email: _email.text,
          password: _password.text,
          birthDate: _birthDate!,
          parentEmail: _under14 ? _parentEmail.text : null,
          parentConsentConfirmed: _under14 && _consent,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final p = MoodPalette.of(context);
    final state = context.watch<RegisterCubit>().state;
    final cubit = context.read<RegisterCubit>();

    return AuthScaffold(
      children: [
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerLeft,
          child: BackPill(label: 'Повернутись до входу', onTap: _back),
        ),
        const SizedBox(height: 50),
        Text('Створити акаунт', style: AppText.headline(p)),
        const SizedBox(height: 4),
        Text('Збережи свою історію настрою', style: AppText.body(p)),
        const SizedBox(height: 40),
        AutofillGroup(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: "Ім'я",
                  icon: Icons.person_outline,
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.givenName],
                  validator: Validators.name,
                  errorText: state.fieldErrors['first_name'],
                  onChanged: (_) => cubit.clearFieldError('first_name'),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Дата народження',
                  icon: Icons.calendar_month_outlined,
                  hint: '01.01.2007',
                  controller: _birthDateText,
                  readOnly: true,
                  onTap: _pickBirthDate,
                  validator: (_) => Validators.birthDate(_birthDate),
                  errorText: state.fieldErrors['birth_date'],
                ),
                if (_under14) ...[
                  const SizedBox(height: 16),
                  _ParentConsentNotice(palette: p),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Email батька або опікуна',
                    icon: Icons.family_restroom_outlined,
                    hint: 'parent@example.com',
                    controller: _parentEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: Validators.email,
                    errorText: state.fieldErrors['parent_email'],
                    onChanged: (_) => cubit.clearFieldError('parent_email'),
                  ),
                  const SizedBox(height: 8),
                  _ConsentCheckbox(
                    value: _consent,
                    showError: _consentError,
                    palette: p,
                    onChanged: (v) => setState(() {
                      _consent = v;
                      if (v) _consentError = false;
                    }),
                  ),
                ],
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Email',
                  icon: Icons.mail_outline,
                  hint: 'name@example.com',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: Validators.email,
                  errorText: state.fieldErrors['email'],
                  onChanged: (_) => cubit.clearFieldError('email'),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Пароль',
                  icon: Icons.lock_outline,
                  controller: _password,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: Validators.newPassword,
                  errorText: state.fieldErrors['password'],
                  onChanged: (_) => cubit.clearFieldError('password'),
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
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    'Мінімум 8 символів, хоча б одна літера й одна цифра',
                    style: AppText.small(p).copyWith(fontSize: 12, color: p.hint),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 48),
        FormErrorText(state.error),
        PrimaryButton(
          label: 'Зареєструватися',
          loading: state.submitting,
          onPressed: _submit,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _ParentConsentNotice extends StatelessWidget {
  const _ParentConsentNotice({required this.palette});

  final MoodPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.buttonFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: palette.text),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Тобі ще немає 14 років. Для реєстрації потрібна згода '
              'батька, матері або опікуна.',
              style: AppText.small(palette),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsentCheckbox extends StatelessWidget {
  const _ConsentCheckbox({
    required this.value,
    required this.showError,
    required this.palette,
    required this.onChanged,
  });

  final bool value;
  final bool showError;
  final MoodPalette palette;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onChanged(!value),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'Батько, мати або опікун дає згоду на реєстрацію '
                    'та обробку моїх даних',
                    style: AppText.small(palette),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 2),
            child: Text('Потрібна згода батька або опікуна', style: AppText.error()),
          ),
      ],
    );
  }
}
