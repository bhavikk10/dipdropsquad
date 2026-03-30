import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/app_colors.dart';

/// Full-screen camera mock with capture overlay (Cupertino only).
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isPhotoMode = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.textPrimary,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.textPrimary),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () => context.pop(),
                      child: const Icon(
                        CupertinoIcons.xmark,
                        color: AppColors.background,
                        size: 28,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () {},
                      child: const Icon(
                        CupertinoIcons.bolt,
                        color: AppColors.background,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        onPressed: () => setState(() => _isPhotoMode = true),
                        child: Text(
                          'Photo',
                          style: TextStyle(
                            color: _isPhotoMode ? AppColors.background : AppColors.textMuted,
                            fontWeight: _isPhotoMode ? FontWeight.bold : FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        onPressed: () => setState(() => _isPhotoMode = false),
                        child: Text(
                          'Video',
                          style: TextStyle(
                            color: !_isPhotoMode ? AppColors.background : AppColors.textMuted,
                            fontWeight: !_isPhotoMode ? FontWeight.bold : FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => context.push('/create/gallery'),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.background, width: 2),
                            ),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.background, width: 4),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          onPressed: () {},
                          child: const Icon(
                            CupertinoIcons.arrow_2_squarepath,
                            color: AppColors.background,
                            size: 32,
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
      ),
    );
  }
}
