import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/auth_repository.dart';
import 'features/auth/presentation/session/session_cubit.dart';

class MoodFlowApp extends StatefulWidget {
  const MoodFlowApp({
    super.key,
    required this.repository,
    required this.session,
  });

  final AuthRepository repository;
  final SessionCubit session;

  @override
  State<MoodFlowApp> createState() => _MoodFlowAppState();
}

class _MoodFlowAppState extends State<MoodFlowApp> {
  late final GoRouter _router = buildRouter(widget.session);

  @override
  void dispose() {
    _router.dispose();
    widget.session.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>.value(
      value: widget.repository,
      child: BlocProvider<SessionCubit>.value(
        value: widget.session,
        child: MaterialApp.router(
          title: 'MoodFlow',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,
          locale: const Locale('uk'),
          supportedLocales: const [Locale('uk')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          routerConfig: _router,
        ),
      ),
    );
  }
}
