import 'package:flutter/cupertino.dart';

import 'app_header_decoration.dart';

/// Top bar matching [MainAppHeader] chrome: 54pt height, border + shadow.
/// Use for Activity, Inbox, Chat, and other pushed screens (not main tabs).
///
/// [leadingWidth] / [trailingWidth] default to 88 so text actions (e.g. "Share")
/// do not overflow the 56px slots used earlier.
class AppHeaderBar extends StatelessWidget {
  const AppHeaderBar({
    super.key,
    this.leading,
    this.middle,
    this.trailing,
    this.leadingWidth = 88,
    this.trailingWidth = 88,
    this.middleAlignment = Alignment.center,
  });

  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;
  final double leadingWidth;
  final double trailingWidth;

  /// How [middle] is positioned in the flexible center slot (e.g. [Alignment.centerLeft] for chat).
  final AlignmentGeometry middleAlignment;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Container(
        height: 54,
        decoration: AppHeaderDecoration.box,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            SizedBox(
              width: leadingWidth,
              child: Align(
                alignment: Alignment.centerLeft,
                child: leading,
              ),
            ),
            Expanded(
              child: Align(
                alignment: middleAlignment,
                child: middle ?? const SizedBox.shrink(),
              ),
            ),
            SizedBox(
              width: trailingWidth,
              child: Align(
                alignment: Alignment.centerRight,
                child: trailing,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
