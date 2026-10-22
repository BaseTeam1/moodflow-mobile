import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/mood_palette.dart';
import '../../core/widgets/mood_logo.dart';
import '../auth/presentation/session/session_cubit.dart';

/// "Головна". Figma: Page 2, frame "iPhone 13 & 14 - 81" (node 676:677).
///
/// Sprint 1 shows the greeting from GET /auth/me and the empty day panel;
/// mood entries arrive with US-19 in sprint II.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _period = 0;
  static const _periods = ['СЬОГОДНІ', 'ВЧОРА', 'ІСТОРІЯ'];

  void _soon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Записи настрою з’являться в наступному спринті')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = MoodPalette.of(context);
    final user = context.select((SessionCubit c) => c.state.user);
    final today = DateFormat('d MMMM', 'uk').format(DateTime.now());
    // Smaller mascot on short screens so the day panel keeps its room.
    final logoSize = MediaQuery.sizeOf(context).height < 720 ? 140.0 : 210.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 16, 25, 0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Сьогодні, $today',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: p.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Привіт, ${user?.displayName ?? ''}!',
                      style: AppText.small(p),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset('assets/icons/person.svg', width: 36, height: 36),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(child: MoodLogo(size: logoSize)),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
            decoration: BoxDecoration(
              gradient: p.panel,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    for (var i = 0; i < _periods.length; i++) ...[
                      _PeriodPill(
                        label: _periods[i],
                        selected: i == _period,
                        palette: p,
                        onTap: () => setState(() => _period = i),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const Spacer(),
                    IconButton(
                      tooltip: 'Календар',
                      onPressed: _soon,
                      icon: Icon(Icons.calendar_month_outlined, color: p.text),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Як пройшов день.', style: AppText.body(p)),
                const SizedBox(height: 8),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 100),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Поки що немає записів.\nНатисни «+», щоб додати перший.',
                            textAlign: TextAlign.center,
                            style: AppText.small(p),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 116,
                        child: FloatingActionButton(
                          heroTag: 'add-entry',
                          tooltip: 'Новий запис',
                          onPressed: _soon,
                          backgroundColor: AppColors.lavender,
                          foregroundColor: AppColors.mist,
                          shape: const CircleBorder(),
                          child: const Icon(Icons.add, size: 32),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PeriodPill extends StatelessWidget {
  const _PeriodPill({
    required this.label,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final MoodPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? palette.pillSelected : palette.pill,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: selected ? AppColors.mist : palette.text,
            ),
          ),
        ),
      ),
    );
  }
}
