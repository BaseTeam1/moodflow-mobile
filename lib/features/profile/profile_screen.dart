import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/mood_palette.dart';
import '../auth/presentation/session/session_cubit.dart';

/// "Профіль" tab. Figma: Page 2, frame "iPhone 13 & 14 - 83" (node 676:857).
///
/// Sprint 1 scope (US-06): name, email and "Вийти з акаунту". Editing the
/// profile, reminders, settings and PIN come in later sprints.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Вийти з акаунту?'),
        content: const Text('Щоб повернутися до записів, потрібно буде увійти знову.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Вийти'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<SessionCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = MoodPalette.of(context);
    final user = context.select((SessionCubit c) => c.state.user);

    return ListView(
      padding: const EdgeInsets.fromLTRB(25, 32, 25, 120),
      children: [
        Center(
          child: SvgPicture.asset('assets/icons/person.svg', width: 88, height: 88),
        ),
        const SizedBox(height: 16),
        Text(
          user?.displayName ?? '',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: p.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user?.email ?? '',
          textAlign: TextAlign.center,
          style: AppText.small(p),
        ),
        const SizedBox(height: 40),
        Material(
          color: p.buttonFill,
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _confirmLogout(context),
            child: SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: p.text, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Вийти з акаунту',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: p.text,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
