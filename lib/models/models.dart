import 'feed_comment.dart';

export 'feed_comment.dart';

class Dip {
  final String id;
  final String username;
  /// Shown in card header (e.g. "Studio Archive"); falls back to username if empty.
  final String displayName;
  /// e.g. "BERLIN, GERMANY"; optional line under display name.
  final String? location;
  final String userAvatarUrl;
  final String mediaUrl;
  final String caption;
  final String timeAgo;
  final int likes;
  final int comments;
  final List<FeedComment> feedComments;
  final Drop? linkedDrop;

  Dip({
    required this.id,
    required this.username,
    required this.userAvatarUrl,
    required this.mediaUrl,
    required this.caption,
    required this.timeAgo,
    required this.likes,
    required this.comments,
    this.displayName = '',
    this.location,
    this.feedComments = const [],
    this.linkedDrop,
  });

  String get headerTitle => displayName.isNotEmpty ? displayName : username.replaceAll('_', ' ');
}

class Drop {
  final String id;
  final String title;
  final String subtitle;
  final double price;
  final String imageUrl;
  final String badge;
  final String description;
  /// Extra gallery images for product detail (first hero is often [imageUrl]).
  final List<String> galleryUrls;
  /// Mock: which user “listed” this in the marketplace (`alex_drops`, `elenav_studio`, …).
  final String sellerHandle;
  /// Mock engagement for marketplace product pages.
  final int likes;
  final int comments;
  final List<FeedComment> feedComments;

  Drop({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.badge,
    this.description = '',
    this.galleryUrls = const [],
    this.sellerHandle = 'alex_drops',
    this.likes = 0,
    this.comments = 0,
    this.feedComments = const [],
  });
}

class UserProfile {
  final String id;
  final String username;
  final String displayName;
  final String avatarUrl;
  final String bio;
  final int followers;
  final int following;
  final int dropsCount;
  final bool isFollowing;

  UserProfile({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    required this.bio,
    required this.followers,
    required this.following,
    required this.dropsCount,
    this.isFollowing = false,
  });
}
