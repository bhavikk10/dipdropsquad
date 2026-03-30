import '../models/feed_comment.dart';

const _avatars = <String>[
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=120&q=80',
  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=120&q=80',
  'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=120&q=80',
  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=120&q=80',
  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=120&q=80',
];

const _users = <String>[
  'marcus_vibe',
  'sarah_k',
  'noir_collective',
  'eli_tracks',
  'jordan_m',
  'taylor_fits',
  'mono_thread',
  'kai_layers',
  'studio_archive',
  'neon_pulse',
];

const _bodies = <String>[
  'This is fire 🔥',
  'Copped instantly. Quality is unreal.',
  'Need this in EU sizing — any restock?',
  'The finish on this drop is insane.',
  'Squad uniform for the weekend.',
  'Price feels fair for the build.',
  'How fast did this sell out last time?',
  'Manifesting a W on this one.',
  'Tagged my whole group chat.',
  'Photos do not do it justice.',
  'Shipping to Canada?',
  'That colorway hits different.',
  'Limited run is the right move.',
  'Respect the craft on this.',
];

const _times = <String>['2h', '4h', '1d', '3h', '12h', '6h', '1h', '30m', '5h', '2d'];

/// Deterministic mock comments for dips / drops.
List<FeedComment> sampleFeedComments(String seed, {int count = 7}) {
  var h = 0;
  for (final u in seed.codeUnits) {
    h = (h * 31 + u) & 0x7fffffff;
  }
  final n = count.clamp(3, 12);
  return List.generate(n, (i) {
    final x = (h + i * 17) & 0x7fffffff;
    return FeedComment(
      id: '${seed}_$i',
      username: _users[x % _users.length],
      avatarUrl: _avatars[x % _avatars.length],
      body: _bodies[(x ~/ 3) % _bodies.length],
      timeLabel: _times[(x ~/ 5) % _times.length],
      likes: 4 + (x % 120),
    );
  });
}

int mockEngagementCount(String seed, int min, int max) {
  var h = 0;
  for (final u in seed.codeUnits) {
    h = (h * 31 + u) & 0x7fffffff;
  }
  return min + h % (max - min + 1);
}
