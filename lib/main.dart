import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/network/api_client.dart';
import 'core/storage/app_storage.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/presentation/session/session_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('uk');

  final storage = AppStorage();
  final api = ApiClient(
    storage: storage,
    isAndroid: defaultTargetPlatform == TargetPlatform.android,
  );
  final repository = AuthRepositoryImpl(api: api, storage: storage);
  final session = SessionCubit(repository);
  api.onUnauthorized = session.sessionExpired;

  runApp(MoodFlowApp(repository: repository, session: session));
  await session.restore();
}
