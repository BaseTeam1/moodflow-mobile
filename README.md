# moodflow-mobile

Мобільний клієнт MoodFlow (Flutter, Android 8.0+ / iOS 14+). Бекенд: `moodflow-backend` (FastAPI).

Спринт 1: онбординг, реєстрація (з BR8), вхід, головний екран, профіль із виходом.

## Перший запуск

```powershell
flutter pub add flutter_localizations --sdk=flutter
flutter pub add flutter_bloc equatable dio flutter_secure_storage go_router google_fonts intl
flutter pub get
flutter analyze
flutter test
```

Бекенд має працювати локально на порту 8000 (див. README бекенду):

```powershell
cd ..\moodflow-backend
docker compose up -d postgres-db
alembic upgrade head
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

Запуск клієнта:

```powershell
# Android-емулятор: бекенд доступний як 10.0.2.2 (за замовчуванням)
flutter run

# Реальний телефон у тій самій Wi-Fi мережі: IP ноутбука

flutter run --dart-define=API_BASE_URL=http://192.168.0.183:8000/api/v1

`--host 0.0.0.0` потрібен, щоб телефон бачив бекенд на ноутбуці.

## Структура

```
lib/
  core/        config, network (dio, помилки API), storage (токен), router, theme, widgets, utils
  features/
    auth/      domain → data → presentation (SessionCubit, LoginCubit, RegisterCubit, екрани)
    onboarding/
    home/      HomeShell з нижньою навігацією, вкладки
    profile/
```

Шари: presentation (екрани + Cubit) → domain (AuthRepository, User) → data (AuthRepositoryImpl, DTO) → ApiClient.

## Макети

Figma «BA common board», сторінка «Page 2 (2026 autumn)»: вхід `881:50`, реєстрація `881:301`, онбординг `588:1556`, головна `676:677`, профіль `676:857`. Темна тема — нижній ряд фреймів.

## Що ще потрібно з Figma

- `assets/images/logo.png` — маскот (прозорий PNG, 3x). Поки його немає, малюється заглушка.
- Іконки полів і навігації як SVG — зараз замість них Material Icons.
- Шрифт заголовків e-Ukraine Head (Bold): покласти `.otf` у `assets/fonts/` і підключити в `pubspec.yaml`; зараз заголовки — Inter ExtraBold.
- Шрифт логотипа «MoodFlow» на онбордингу.
