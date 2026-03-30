import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';

class DropCard extends StatelessWidget {
  final Drop drop;

  const DropCard({super.key, required this.drop});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final imageRadius = isLight
        ? const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
        : BorderRadius.circular(24);

    final imageStack = Stack(
      children: [
        AspectRatio(
          aspectRatio: 4 / 5,
          child: ClipRRect(
            borderRadius: imageRadius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(drop.imageUrl, fit: BoxFit.cover),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xB3000000),
                        Color(0x00000000),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                  shape: BoxShape.circle,
                ),
                child: const Icon(CupertinoIcons.heart_fill, color: Colors.white, size: 16),
              ),
            ),
          ),
        ),
      ],
    );

    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          drop.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          drop.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w400,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${drop.price.toStringAsFixed(2)}',
          style: TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ],
    );

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        imageStack,
        if (isLight)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: textColumn,
          )
        else ...[
          const SizedBox(height: 12),
          textColumn,
        ],
      ],
    );

    return GestureDetector(
      onTap: () => context.push('/drops/detail/${drop.id}'),
      child: isLight
          ? Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant, width: 1),
              ),
              clipBehavior: Clip.antiAlias,
              child: column,
            )
          : column,
    );
  }
}
