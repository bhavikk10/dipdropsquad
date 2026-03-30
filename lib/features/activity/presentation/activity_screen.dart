import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_typography.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../widgets/cupertino/app_header_bar.dart';
import 'activity_view.dart';

/// Full-screen activity feed (root navigator).
class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  int _tab = 0;

  static const _labels = ['All', 'Purchases', 'Follow requests'];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHeaderBar(
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.pop(),
              child: Icon(AppIcons.backChevron, color: AppColors.textPrimary, size: 28),
            ),
            middle: Text(
              'ACTIVITY',
              style: AppTypography.h2.copyWith(
                fontSize: 15,
                letterSpacing: 0.6,
              ),
            ),
          ),
          _ActivityTabStrip(
            selected: _tab,
            labels: _labels,
            onSelect: (i) => setState(() => _tab = i),
          ),
          Expanded(child: ActivityView(tabIndex: _tab)),
        ],
      ),
    );
  }
}

class _ActivityTabStrip extends StatelessWidget {
  const _ActivityTabStrip({
    required this.selected,
    required this.labels,
    required this.onSelect,
  });

  final int selected;
  final List<String> labels;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
        child: Row(
          children: List.generate(labels.length, (i) {
            final sel = selected == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(i),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      child: Text(
                        labels[i],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: AppTypography.bodyPrimary.copyWith(
                          fontSize: 13,
                          height: 1.15,
                          fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                          color: sel ? AppColors.textPrimary : AppColors.textMuted,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: sel ? const Color(0xFF2E4A8A) : const Color(0x00000000),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
