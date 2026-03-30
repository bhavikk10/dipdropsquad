import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_typography.dart';
import '../../../providers/mock_providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_shadows.dart';
import '../../../widgets/cupertino/main_app_header.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  static const _masonryHeights = [200.0, 250.0, 180.0, 220.0, 195.0, 240.0];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creators = ref.watch(discoverCreatorsProvider);
    final moodItems = ref.watch(trendingMoodboardProvider);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom + 88;

    final leftCol = <Map<String, dynamic>>[];
    final rightCol = <Map<String, dynamic>>[];
    for (var i = 0; i < moodItems.length; i++) {
      if (i.isEven) {
        leftCol.add(moodItems[i]);
      } else {
        rightCol.add(moodItems[i]);
      }
    }

    return ColoredBox(
      color: AppColors.background,
      child: Column(
        children: [
          const MainAppHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset),
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: CupertinoTextField(
                      placeholder: 'Search styles, creators, or squads',
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: AppShadows.searchField,
                      ),
                      style: AppTypography.bodyPrimary.copyWith(fontSize: 16),
                      placeholderStyle: AppTypography.bodySecondary.copyWith(fontSize: 16),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(AppIcons.search, color: AppColors.textMuted, size: 20),
                      ),
                      suffix: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(AppIcons.filter, color: AppColors.textMuted, size: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'DISCOVER CREATORS',
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 196,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16, right: 4),
                      physics: const BouncingScrollPhysics(),
                      itemCount: creators.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _DiscoverCreatorCard(creator: creators[index]),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Text(
                      'TRENDING MOODBOARD',
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: List.generate(leftCol.length, (i) {
                              final item = leftCol[i];
                              final h = _masonryHeights[(i * 2) % _masonryHeights.length];
                              return _MoodboardTile(item: item, height: h);
                            }),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: List.generate(rightCol.length, (i) {
                              final item = rightCol[i];
                              final h = _masonryHeights[(i * 2 + 1) % _masonryHeights.length];
                              return _MoodboardTile(item: item, height: h);
                            }),
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

class _DiscoverCreatorCard extends StatefulWidget {
  final Map<String, dynamic> creator;

  const _DiscoverCreatorCard({required this.creator});

  @override
  State<_DiscoverCreatorCard> createState() => _DiscoverCreatorCardState();
}

class _DiscoverCreatorCardState extends State<_DiscoverCreatorCard> {
  late bool _following;

  @override
  void initState() {
    super.initState();
    _following = widget.creator['isFollowing'] as bool;
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.creator['name'] as String;
    final realName = widget.creator['realName'] as String;
    final url = widget.creator['avatarUrl'] as String;
    final handle = widget.creator['handle'] as String? ?? '';

    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: handle.isEmpty ? null : () => context.push('/profile/u/$handle'),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyPrimary,
                ),
                const SizedBox(height: 4),
                Text(
                  realName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: CupertinoButton.filled(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(8),
              color: AppColors.accent,
              onPressed: () => setState(() => _following = !_following),
              child: Text(
                _following ? 'FOLLOWING' : 'FOLLOW',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodboardTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final double height;

  const _MoodboardTile({required this.item, required this.height});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item['imageUrl'] as String;
    final likes = item['likes'] as String;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: AppColors.surface,
                  child: Center(child: Icon(AppIcons.photo, color: AppColors.textMuted)),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0x66000000),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(CupertinoIcons.heart_fill, color: Color(0xFFFFFFFF), size: 14),
                      const SizedBox(width: 6),
                      Text(
                        likes,
                        style: AppTypography.caption.copyWith(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
