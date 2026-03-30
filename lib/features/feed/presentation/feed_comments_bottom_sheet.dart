import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_typography.dart';
import '../../../models/feed_comment.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';

/// Full-screen overlay: blur + dim fade in first, then sheet slides up from bottom.
Future<void> showFeedCommentsSheet(
  BuildContext context, {
  required int commentCount,
  required List<FeedComment> comments,
  required String meAvatarUrl,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: Duration.zero,
    useRootNavigator: true,
    pageBuilder: (dialogContext, _, __) {
      return _CommentsOverlay(
        commentCount: commentCount,
        comments: comments,
        meAvatarUrl: meAvatarUrl,
      );
    },
  );
}

class _CommentsOverlay extends StatefulWidget {
  const _CommentsOverlay({
    required this.commentCount,
    required this.comments,
    required this.meAvatarUrl,
  });

  final int commentCount;
  final List<FeedComment> comments;
  final String meAvatarUrl;

  @override
  State<_CommentsOverlay> createState() => _CommentsOverlayState();
}

class _CommentsOverlayState extends State<_CommentsOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _backdrop;
  late final Animation<Offset> _sheetSlide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
    _backdrop = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.0, 0.42, curve: Curves.easeOutCubic),
    );
    _sheetSlide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.22, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    await _c.reverse();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _dismiss();
      },
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _backdrop,
              builder: (context, child) {
                final t = _backdrop.value;
                final sigma = 18.0 * t;
                return Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _dismiss,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.36 * t),
                      ),
                    ),
                  ),
                );
              },
            ),
            SlideTransition(
              position: _sheetSlide,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: height * 0.94,
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.72,
                    minChildSize: 0.38,
                    maxChildSize: 0.94,
                    builder: (context, scrollController) {
                      return _CommentsSheetBody(
                        commentCount: widget.commentCount,
                        comments: widget.comments,
                        meAvatarUrl: widget.meAvatarUrl,
                        scrollController: scrollController,
                      );
                    },
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

class _CommentsSheetBody extends StatefulWidget {
  const _CommentsSheetBody({
    required this.commentCount,
    required this.comments,
    required this.meAvatarUrl,
    required this.scrollController,
  });

  final int commentCount;
  final List<FeedComment> comments;
  final String meAvatarUrl;
  final ScrollController scrollController;

  @override
  State<_CommentsSheetBody> createState() => _CommentsSheetBodyState();
}

class _CommentsSheetBodyState extends State<_CommentsSheetBody> {
  final _composer = TextEditingController();

  @override
  void dispose() {
    _composer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text(
              'Comments (${widget.commentCount})',
              style: AppTypography.h2.copyWith(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              itemCount: widget.comments.length,
              itemBuilder: (context, index) {
                final c = widget.comments[index];
                return _CommentRow(comment: c);
              },
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipOval(
                    child: Image.network(
                      widget.meAvatarUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 40,
                        height: 40,
                        color: AppColors.surface,
                        child: const Icon(AppIcons.person, size: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _composer,
                      minLines: 1,
                      maxLines: 4,
                      style: AppTypography.buttonText.copyWith(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: AppTypography.bodySecondary.copyWith(fontSize: 15),
                        filled: true,
                        fillColor: const Color(0xFFF2F2F7),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: AppColors.authFlowPrimary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {},
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(AppIcons.send, color: Colors.white, size: 22),
                      ),
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

class _CommentRow extends StatelessWidget {
  const _CommentRow({required this.comment});

  final FeedComment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.network(
              comment.avatarUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 40,
                height: 40,
                color: AppColors.surface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.username,
                  style: AppTypography.bodyPrimary.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  comment.body,
                  style: AppTypography.bodyPrimary.copyWith(
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      comment.timeLabel,
                      style: AppTypography.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'REPLY',
                      style: AppTypography.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Icon(AppIcons.heartOutline, size: 20, color: Colors.grey.shade500),
              const SizedBox(height: 2),
              Text(
                '${comment.likes}',
                style: AppTypography.caption.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
