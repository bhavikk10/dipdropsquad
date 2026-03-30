import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/mock_data_provider.dart';
import '../../../providers/mock_providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../widgets/cupertino/app_header_bar.dart';
import '../../feed/presentation/feed_comments_bottom_sheet.dart';
import '../../feed/presentation/feed_engagement_formatters.dart';

/// Cupertino product detail (no Material scaffold/app bar).
class DropDetailScreen extends ConsumerStatefulWidget {
  final String dropId;

  const DropDetailScreen({super.key, required this.dropId});

  @override
  ConsumerState<DropDetailScreen> createState() => _DropDetailScreenState();
}

class _DropDetailScreenState extends ConsumerState<DropDetailScreen> {
  int _pageIndex = 0;
  int _finishIndex = 0;
  int _sizeIndex = 1;

  static const _sizes = ['40mm', '42mm', '44mm', '46mm'];

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(dropDetailProvider);
    final dropEntity = ref.watch(dropByIdProvider(widget.dropId));
    final me = ref.watch(userProfileProvider);
    final mutualFollow = ref.watch(mutualFollowProvider);
    final images = (detail['images'] as List).cast<String>();
    final title = detail['title'] as String;
    final subtitle = detail['subtitle'] as String;
    final price = (detail['price'] as num).toDouble();
    final inStock = detail['inStock'] as bool;
    final description = detail['description'] as String;

    return ColoredBox(
      color: AppColors.background,
      child: Column(
        children: [
          AppHeaderBar(
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.pop(),
              child: const Icon(AppIcons.backChevron, color: AppColors.textPrimary, size: 28),
            ),
            middle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                const Text(
                  'DIP/DROP',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 1.2,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: const Icon(AppIcons.share, color: AppColors.textPrimary, size: 24),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 350,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (i) => setState(() => _pageIndex = i),
                          itemBuilder: (context, i) {
                            return Image.network(
                              images[i],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) => const ColoredBox(
                                color: AppColors.chatReceiverBg,
                                child: Center(
                                  child: Icon(AppIcons.photo, color: AppColors.textMuted, size: 40),
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 14,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(images.length, (i) {
                              final active = i == _pageIndex;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOut,
                                width: active ? 28 : 8,
                                height: 3,
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: active ? AppColors.textMuted : AppColors.border,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'NEW ARRIVAL',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            Text(
                              '\$${price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                subtitle,
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 15),
                              ),
                            ),
                            Text(
                              inStock ? 'IN STOCK' : 'OUT OF STOCK',
                              style: TextStyle(
                                color: inStock ? AppColors.success : CupertinoColors.destructiveRed,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                            height: 1.5,
                          ),
                        ),
                        if (dropEntity != null) ...[
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(AppIcons.heartFill, size: 22, color: AppColors.textPrimary),
                                    const SizedBox(width: 6),
                                    Text(
                                      formatEngagementCount(dropEntity.likes),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  showFeedCommentsSheet(
                                    context,
                                    commentCount: dropEntity.comments,
                                    comments: dropEntity.feedComments,
                                    meAvatarUrl: me.avatarUrl,
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(AppIcons.comment, size: 22, color: AppColors.textPrimary),
                                    const SizedBox(width: 6),
                                    Text(
                                      formatEngagementCount(dropEntity.comments),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),
                        const Text(
                          'SELECT FINISH',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _finishDot(0, const Color(0xFFE8E8E8), selectedBorder: AppColors.textPrimary),
                            const SizedBox(width: 14),
                            _finishDot(1, AppColors.textPrimary, selectedBorder: AppColors.textPrimary),
                            const SizedBox(width: 14),
                            _finishDot(2, AppColors.accent, selectedBorder: AppColors.accent),
                          ],
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'SIZE GUIDE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(_sizes.length, (i) {
                            final disabled = i == 3;
                            final selected = _sizeIndex == i && !disabled;
                            return GestureDetector(
                              onTap: disabled ? null : () => setState(() => _sizeIndex = i),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                decoration: BoxDecoration(
                                  color: selected ? AppColors.textPrimary : AppColors.background,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: selected ? AppColors.textPrimary : AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _sizes[i],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: disabled
                                        ? AppColors.border
                                        : (selected ? AppColors.background : AppColors.textPrimary),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(AppIcons.heartFill, color: AppColors.textPrimary, size: 22),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: CupertinoButton.filled(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.accent,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (mutualFollow) {
                            context.push('/chat/room/${widget.dropId}');
                          }
                        },
                        child: const Text(
                          "I'm Interested >",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                        ),
                      ),
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

  Widget _finishDot(int index, Color fill, {required Color selectedBorder}) {
    final selected = _finishIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _finishIndex = index),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: fill,
          border: Border.all(
            color: selected ? selectedBorder : AppColors.border,
            width: selected ? 2.5 : 1,
          ),
        ),
      ),
    );
  }
}
