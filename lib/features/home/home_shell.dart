import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/mood_palette.dart';
import '../../core/widgets/gradient_background.dart';
import '../auth/presentation/session/session_cubit.dart';
import '../profile/profile_screen.dart';
import 'home_tab.dart';
import 'placeholder_tab.dart';
import 'widgets/mood_nav_bar.dart';

/// Main screen with the bottom navigation from the mockups:
/// Головна · Аналітика · Компаньйон · Профіль.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // US-02, AC 4: when the app comes back after the 60-minute token expired,
    // /auth/me returns 401 and the session sends the user to the login screen.
    _lifecycle = AppLifecycleListener(
      onResume: () => context.read<SessionCubit>().refresh(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  static const _items = [
    MoodNavItem(asset: 'assets/icons/nav_home.svg', label: 'Головна'),
    MoodNavItem(asset: 'assets/icons/nav_analytics.svg', label: 'Аналітика'),
    MoodNavItem(asset: 'assets/icons/nav_companion.svg', label: 'Компаньйон'),
    MoodNavItem(asset: 'assets/icons/nav_profile.svg', label: 'Профіль'),
  ];

  @override
  Widget build(BuildContext context) {
    final p = MoodPalette.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: _index,
            children: const [
              HomeTab(),
              PlaceholderTab(
                title: 'Аналітика',
                text: 'Графіки й статистика настрою з’являться в наступних спринтах.',
              ),
              PlaceholderTab(
                title: 'Компаньйон',
                text: 'AI-компаньйон з’явиться в наступних спринтах.',
              ),
              ProfileScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MoodNavBar(
        items: _items,
        currentIndex: _index,
        palette: p,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
