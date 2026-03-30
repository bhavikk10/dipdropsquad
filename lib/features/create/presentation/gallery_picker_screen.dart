import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/cupertino/app_header_bar.dart';

/// Full-screen gallery picker (light theme).
class GalleryPickerScreen extends StatelessWidget {
  const GalleryPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Column(
        children: [
          AppHeaderBar(
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: () => context.pop(),
              child: const Icon(CupertinoIcons.xmark, color: AppColors.textPrimary, size: 28),
            ),
            middle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Recents',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Icon(CupertinoIcons.chevron_down, size: 14, color: AppColors.textPrimary),
              ],
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: () => context.push('/create/details'),
              child: const Text(
                'Next',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              color: AppColors.surface,
              alignment: Alignment.center,
              child: const Icon(
                CupertinoIcons.photo,
                size: 72,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recents',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.square_on_square,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () => context.go('/create'),
                      child: const Icon(
                        CupertinoIcons.camera,
                        color: AppColors.textPrimary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: 24,
              itemBuilder: (context, index) {
                return Container(color: AppColors.surface);
              },
            ),
          ),
        ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
