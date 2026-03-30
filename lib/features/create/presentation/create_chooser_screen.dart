import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:go_router/go_router.dart';

import '../../../theme/app_colors.dart';

/// “What are we dropping?” — lives inside [MainScaffold] so the tab bar stays visible.
class CreateChooserScreen extends StatefulWidget {
  const CreateChooserScreen({super.key});

  @override
  State<CreateChooserScreen> createState() => _CreateChooserScreenState();
}

class _CreateChooserScreenState extends State<CreateChooserScreen>
    with SingleTickerProviderStateMixin {
  static const _pageBg = Color(0xFFF8F8F8);

  late final AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 780));
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  Animation<double> _fade(double begin, double end) {
    return CurvedAnimation(
      parent: _ac,
      curve: Interval(begin, end, curve: Curves.easeOutCubic),
    );
  }

  Animation<Offset> _slide(double begin, double end) {
    return Tween<Offset>(begin: const Offset(0, 0.07), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _ac,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    /// Reserve space for [MainScaffold] tab bar (~68) + FAB overlap.
    const tabBarReserve = 88.0;

    return ColoredBox(
      color: _pageBg,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 56),
                  FadeTransition(
                    opacity: _fade(0.0, 0.35),
                    child: SlideTransition(
                      position: _slide(0.0, 0.35),
                      child: const Text(
                        'WHAT ARE WE\nDROPPING?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          letterSpacing: 0.3,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  FadeTransition(
                    opacity: _fade(0.1, 0.5),
                    child: SlideTransition(
                      position: _slide(0.1, 0.5),
                      child: _OptionCard(
                        icon: CupertinoIcons.camera_fill,
                        title: 'Post a Dip',
                        subtitle: 'Share a photo, video, or fit check.',
                        onTap: () => context.push('/create/dip'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _fade(0.22, 0.62),
                    child: SlideTransition(
                      position: _slide(0.22, 0.62),
                      child: _OptionCard(
                        icon: CupertinoIcons.bag_fill,
                        title: 'List a Drop',
                        subtitle: 'Sell an item from your collection.',
                        onTap: () => context.push('/create/drop'),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  FadeTransition(
                    opacity: _fade(0.35, 0.75),
                    child: SlideTransition(
                      position: _slide(0.35, 0.75),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: tabBarReserve + bottomPad + 8),
                        child: Column(
                          children: [
                            Text(
                              'Need help with your drop?',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textMuted.withValues(alpha: 0.95),
                              ),
                            ),
                            const SizedBox(height: 14),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8E8EC),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'GUIDELINES',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 12,
              child: FadeTransition(
                opacity: _fade(0.0, 0.4),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.go('/'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE4E4E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatefulWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<_OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<_OptionCard> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.98),
      onTapUp: (_) => setState(() => _scale = 1),
      onTapCancel: () => setState(() => _scale = 1),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(widget.icon, size: 26, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                size: 18,
                color: AppColors.textMuted.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
