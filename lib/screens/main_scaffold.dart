import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_icons.dart';
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/create')) return 2;
    if (location.startsWith('/drops')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0; // Default to Home
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/create');
        break;
      case 3:
        context.go('/drops');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    final cs = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: child),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: cs.background,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: isLight ? 1.0 : 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(context, 0, AppIcons.navHome, currentIndex == 0),
                    _buildNavItem(context, 1, AppIcons.navExplore, currentIndex == 1),
                    const SizedBox(width: 64),
                    _buildNavItem(context, 3, AppIcons.navDrops, currentIndex == 3),
                    _buildNavItem(context, 4, AppIcons.navProfile, currentIndex == 4),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: Center(
              child: _DiamondFab(
                primary: cs.primary,
                useGlow: !isLight,
                onTap: () => _onItemTapped(2, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, bool isSelected) {
    final cs = Theme.of(context).colorScheme;
    final color = isSelected ? cs.primary : cs.onSurfaceVariant;
    return GestureDetector(
      onTap: () => _onItemTapped(index, context),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: Icon(icon, color: color, size: 26),
        ),
      ),
    );
  }
}

class _DiamondFab extends StatefulWidget {
  final VoidCallback onTap;
  final Color primary;
  final bool useGlow;

  const _DiamondFab({
    required this.onTap,
    required this.primary,
    required this.useGlow,
  });

  @override
  State<_DiamondFab> createState() => _DiamondFabState();
}

class _DiamondFabState extends State<_DiamondFab> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _scale = 0.9),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTapUp: (_) => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: widget.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: widget.useGlow
                  ? [
                      BoxShadow(
                        color: widget.primary.withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Transform.rotate(
                angle: -math.pi / 4,
                child: const Icon(AppIcons.navCreate, color: Colors.white, size: 28),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
