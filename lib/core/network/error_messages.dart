import 'api_exception.dart';

/// User-facing Ukrainian texts for API errors.
String errorMessage(Object error) {
  if (error is! ApiException) return 'Щось пішло не так. Спробуйте пізніше.';
  switch (error.code) {
    case ApiException.network:
      return "Немає з'єднання, спробуйте ще раз";
    case 'invalid_credentials':
      return 'Невірний email або пароль';
    case 'account_inactive':
      return 'Акаунт деактивовано';
    case 'email_already_registered':
      return 'Цей email вже зареєстрований';
    case 'validation_error':
      return 'Перевірте введені дані';
    case 'unauthorized':
      return 'Сесія завершилась, увійдіть знову';
    default:
      return 'Щось пішло не так. Спробуйте пізніше.';
  }
}
