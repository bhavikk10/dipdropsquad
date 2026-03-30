import 'package:flutter/cupertino.dart';

/// Filled / SF-style Cupertino icons for a consistent premium look app-wide.
abstract final class AppIcons {
  AppIcons._();

  // —— Main bottom navigation ——
  static const IconData navHome = CupertinoIcons.house_fill;
  static const IconData navExplore = CupertinoIcons.compass_fill;
  static const IconData navDrops = CupertinoIcons.bag_fill;
  static const IconData navProfile = CupertinoIcons.person_crop_circle_fill;
  static const IconData navCreate = CupertinoIcons.add_circled_solid;

  // —— Global header ——
  static const IconData headerBell = CupertinoIcons.bell_fill;
  /// Inbox / messages (filled tray stack).
  static const IconData headerInbox = CupertinoIcons.tray_full_fill;
  static const IconData headerEdit = CupertinoIcons.pencil_circle_fill;

  // —— Common UI ——
  static const IconData search = CupertinoIcons.search_circle_fill;
  static const IconData filter = CupertinoIcons.slider_horizontal_3;
  static const IconData more = CupertinoIcons.ellipsis_circle_fill;
  static const IconData comment = CupertinoIcons.chat_bubble_2_fill;
  static const IconData share = CupertinoIcons.share_up;
  static const IconData close = CupertinoIcons.xmark_circle_fill;
  static const IconData backChevron = CupertinoIcons.chevron_back;
  static const IconData heartOutline = CupertinoIcons.heart;
  static const IconData heartFill = CupertinoIcons.heart_fill;
  static const IconData bookmarkOutline = CupertinoIcons.bookmark;
  static const IconData bookmarkFill = CupertinoIcons.bookmark_fill;

  static const IconData person = CupertinoIcons.person_fill;
  static const IconData photo = CupertinoIcons.photo_fill;
  static const IconData send = CupertinoIcons.arrow_up_circle_fill;
  static const IconData chevronRight = CupertinoIcons.chevron_right;
  static const IconData linkOut = CupertinoIcons.arrow_up_right_circle_fill;
}
