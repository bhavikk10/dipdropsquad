/// A single row in the feed / drop comments thread (mock data).
class FeedComment {
  const FeedComment({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.body,
    required this.timeLabel,
    required this.likes,
  });

  final String id;
  final String username;
  final String avatarUrl;
  final String body;
  /// Short label, e.g. "2h"
  final String timeLabel;
  final int likes;
}
