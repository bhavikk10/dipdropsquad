import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/models.dart';
import '../theme/app_icons.dart';

class DipCard extends StatelessWidget {
  final Dip dip;

  const DipCard({super.key, required this.dip});

  static const _avatarSize = 36.0; // radius 18

  Widget _avatar(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Image.network(
        url,
        width: _avatarSize,
        height: _avatarSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          final cs = Theme.of(context).colorScheme;
          return Container(
            width: _avatarSize,
            height: _avatarSize,
            color: cs.surfaceVariant,
            alignment: Alignment.center,
            child: Icon(AppIcons.person, color: cs.onSurface, size: 18),
          );
        },
      ),
    );
  }

  Widget _fadeInNetworkImage(String url, {BoxFit fit = BoxFit.cover}) {
    return Image.network(
      url,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(isLight ? 16 : 20),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: isLight ? 1.0 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _avatar(dip.userAvatarUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dip.username,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        dip.timeAgo,
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(AppIcons.more, color: cs.onSurfaceVariant, size: 22),
              ],
            ),
          ),

          // Media with View Drop Button
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 4 / 5,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                  child: Hero(
                    tag: 'dip_media_${dip.id}',
                    child: _fadeInNetworkImage(dip.mediaUrl),
                  ),
                ),
              ),
              if (dip.linkedDrop != null)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => context.push('/drops/detail/${dip.linkedDrop!.id}'),
                    child: isLight
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(CupertinoIcons.bag_fill, color: Colors.white, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'View Drop',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: cs.primary.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(CupertinoIcons.bag_fill, color: Colors.white, size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      'View Drop',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
            ],
          ),

          // Action Row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 18,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _PopIcon(
                        icon: AppIcons.heartFill,
                        onTap: () {},
                        trailingText: '${dip.likes >= 1000 ? '${(dip.likes / 1000).toStringAsFixed(1)}k' : dip.likes}',
                      ),
                      _IconWithText(
                        icon: AppIcons.comment,
                        text: '${dip.comments}',
                      ),
                      Icon(AppIcons.share, size: 24, color: cs.onSurface),
                    ],
                  ),
                ),
                _PopIcon(icon: AppIcons.bookmarkOutline, onTap: () {}, trailingText: null),
              ],
            ),
          ),

          // Caption Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14, height: 1.4),
                children: [
                  TextSpan(
                    text: '${dip.username} ',
                    style: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface),
                  ),
                  TextSpan(
                    text: dip.caption.replaceFirst('${dip.username} ', ''),
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

class _IconWithText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconWithText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: cs.onSurface),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

class _PopIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? trailingText;

  const _PopIcon({required this.icon, required this.onTap, required this.trailingText});

  @override
  State<_PopIcon> createState() => _PopIconState();
}

class _PopIconState extends State<_PopIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 140),
    lowerBound: 0.0,
    upperBound: 0.12,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pop() async {
    widget.onTap();
    await _controller.forward();
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: _pop,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1.0 + _controller.value;
          return Transform.scale(scale: scale, child: child);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 24, color: cs.onSurface),
            if (widget.trailingText != null) ...[
              const SizedBox(width: 6),
              Text(
                widget.trailingText!,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: cs.onSurface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
