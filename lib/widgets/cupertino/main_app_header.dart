import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_typography.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';
import 'app_header_decoration.dart';

/// Shared top bar: title on the left, actions on the right (filled premium icons).
class MainAppHeader extends StatelessWidget {
  const MainAppHeader({
    super.key,
    this.showEditProfile = false,
    this.showLeadingBack = false,
    this.onTitleLongPress,
  });

  final bool showEditProfile;
  final bool showLeadingBack;
  final VoidCallback? onTitleLongPress;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Container(
        height: 54,
        decoration: AppHeaderDecoration.box,
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 8),
          child: Row(
            children: [
              if (showLeadingBack)
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  onPressed: () => context.pop(),
                  child: const Icon(
                    AppIcons.backChevron,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                ),
              Expanded(
                child: GestureDetector(
                  onLongPress: onTitleLongPress,
                  behavior: HitTestBehavior.opaque,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: showLeadingBack ? 0 : 8),
                      child: Text(
                        'MYDIPSQUAD',
                        style: AppTypography.headerDisplay,
                      ),
                    ),
                  ),
                ),
              ),
              if (showEditProfile)
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  onPressed: () => context.push('/profile/edit'),
                  child: const Icon(
                    AppIcons.headerEdit,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                ),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                onPressed: () => context.push('/activity'),
                child: const Icon(
                  AppIcons.headerBell,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                onPressed: () => context.push('/inbox'),
                child: const Icon(
                  AppIcons.headerInbox,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
