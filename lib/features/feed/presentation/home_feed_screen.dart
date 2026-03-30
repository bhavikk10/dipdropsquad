import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/models.dart';
import '../../../providers/mock_data_provider.dart';
import '../../../providers/mock_providers.dart';
import '../../../core/theme/app_typography.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_shadows.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/theme_provider.dart';
import '../../../widgets/cupertino/main_app_header.dart';
import 'feed_comments_bottom_sheet.dart';
import 'feed_engagement_formatters.dart';

/// Cupertino-only home feed (no Material `Scaffold` / `AppBar`).
class HomeFeedScreen extends ConsumerStatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  ConsumerState<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends ConsumerState<HomeFeedScreen> {
  @override
  Widget build(BuildContext context) {
    final dips = ref.watch(dipsProvider);
    final ring = ref.watch(dropperRingProvider);

    return ColoredBox(
      color: AppColors.background,
      child: Column(
        children: [
          MainAppHeader(
            onTitleLongPress: () {
              final current = ref.read(themeModeProvider);
              ref.read(themeModeProvider.notifier).state =
                  current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 118,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      physics: const BouncingScrollPhysics(),
                      itemCount: ring.length,
                      itemBuilder: (context, index) {
                        final item = ring[index];
                        final name = item['name'] as String;
                        final url = item['imageUrl'] as String;
                        final isNew = item['isNewDrop'] as bool;

                        Widget avatar = ClipOval(
                          child: SizedBox(
                            width: 64,
                            height: 64,
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => ColoredBox(
                                color: AppColors.surface,
                                child: const Center(
                                  child: Icon(
                                    AppIcons.person,
                                    color: AppColors.textMuted,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );

                        if (isNew) {
                          avatar = Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.accent, width: 2),
                            ),
                            child: avatar,
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              avatar,
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 72,
                                child: Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isNew ? FontWeight.w700 : FontWeight.w400,
                                    color: isNew ? AppColors.textPrimary : AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      boxShadow: AppShadows.hairlineDown,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _CupertinoDipCard(
                            dip: dips[index],
                            meAvatarUrl: ref.watch(userProfileProvider).avatarUrl,
                          ),
                        );
                      },
                      childCount: dips.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CupertinoDipCard extends ConsumerStatefulWidget {
  final Dip dip;
  final String meAvatarUrl;

  const _CupertinoDipCard({required this.dip, required this.meAvatarUrl});

  @override
  ConsumerState<_CupertinoDipCard> createState() => _CupertinoDipCardState();
}

class _CupertinoDipCardState extends ConsumerState<_CupertinoDipCard> {
  bool _liked = false;
  bool _saved = false;

  Dip get dip => widget.dip;

  int get _likeDisplay => dip.likes + (_liked ? 1 : 0);

  void _openComments() {
    showFeedCommentsSheet(
      context,
      commentCount: dip.comments,
      comments: dip.feedComments,
      meAvatarUrl: widget.meAvatarUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    final handle = captionUserHandle(dip.caption);
    final body = captionBodyAfterUser(dip.caption);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.push('/profile/u/${dip.username}'),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            dip.userAvatarUrl,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 36,
                              height: 36,
                              color: AppColors.chatReceiverBg,
                              alignment: Alignment.center,
                              child: const Icon(CupertinoIcons.person_fill, size: 18, color: AppColors.textMuted),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dip.headerTitle,
                                style: AppTypography.buttonText.copyWith(
                                  fontSize: 15,
                                  letterSpacing: 0,
                                ),
                              ),
                              Text(
                                dip.location != null ? dip.location!.toUpperCase() : dip.timeAgo,
                                style: AppTypography.caption.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(
                  AppIcons.more,
                  color: AppColors.textMuted,
                  size: 22,
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  dip.mediaUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                    errorBuilder: (_, __, ___) => const ColoredBox(
                    color: AppColors.chatReceiverBg,
                    child: Center(
                      child: Icon(AppIcons.photo, color: AppColors.textMuted, size: 40),
                    ),
                  ),
                ),
                if (dip.linkedDrop != null)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: CupertinoButton(
                      color: AppColors.authFlowPrimary,
                      borderRadius: BorderRadius.circular(999),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      onPressed: () => context.push('/drops/detail/${dip.linkedDrop!.id}'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View Drop',
                            style: AppTypography.bodyPrimary.copyWith(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(AppIcons.linkOut, color: const Color(0xFFFFFFFF), size: 16),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
            child: Row(
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  onPressed: () => setState(() => _liked = !_liked),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _liked ? AppIcons.heartFill : AppIcons.heartOutline,
                        color: _liked ? const Color(0xFFE85D5D) : AppColors.textPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        formatEngagementCount(_likeDisplay),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  onPressed: _openComments,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        AppIcons.comment,
                        color: AppColors.textPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        formatEngagementCount(dip.comments),
                        style: AppTypography.bodyPrimary.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  onPressed: () {},
                  child: const Icon(
                    AppIcons.share,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                ),
                const Spacer(),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  onPressed: () => setState(() => _saved = !_saved),
                  child: Icon(
                    _saved ? AppIcons.bookmarkFill : AppIcons.bookmarkOutline,
                    color: _saved ? AppColors.accent : AppColors.textPrimary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            child: RichText(
              text: TextSpan(
                style: AppTypography.bodySecondary.copyWith(height: 1.4),
                children: [
                  TextSpan(
                    text: handle,
                    style: AppTypography.bodyPrimary.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(text: body),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              timeAgoUpper(dip.timeAgo),
              style: AppTypography.caption.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: AppColors.textMuted.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
