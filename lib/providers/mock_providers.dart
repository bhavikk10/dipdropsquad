import 'package:flutter_riverpod/flutter_riverpod.dart';

const _watchImg =
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=200&q=80';
const _shoeImg =
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=200&q=80';
const _headphonesImg =
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=200&q=80';
const _lensImg =
    'https://images.unsplash.com/photo-1516035069371-29a1b244ccff?auto=format&fit=crop&w=200&q=80';

final dropperRingProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {'name': 'NEW DROP', 'imageUrl': _watchImg, 'isNewDrop': true},
    {'name': 'Alex', 'imageUrl': _shoeImg, 'isNewDrop': false},
    {'name': 'Jordan', 'imageUrl': _headphonesImg, 'isNewDrop': false},
    {'name': 'Taylor', 'imageUrl': _lensImg, 'isNewDrop': false},
  ];
});

final dropDetailProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'title': 'Luna Chrono Pro',
    'subtitle': 'Obsidian Silver Edition',
    'price': 240.00,
    'inStock': true,
    'description':
        'A masterpiece of industrial design, featuring the signature obsidian-brushed finish and a precision-engineered movement. Only 500 units available worldwide.',
    'images': [
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=900&q=80',
    ],
  };
});

/// Dense mock chat threads per inbox id.
final chatMessagesForThreadProvider =
    Provider.family<List<Map<String, dynamic>>, String>((ref, id) {
  switch (id) {
    // Alex — squad buy planning with image drops and progress mention.
    case 'd1':
      return [
        {
          'id': '1',
          'senderId': 'alex',
          'text': 'Yo! Just saw the Luna drop. Anyone else jumping in on the squad buy? 🚀',
          'timestamp': '12:45 PM',
          'isMe': false,
          'avatarUrl':
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=100&q=80',
        },
        {
          'id': '2',
          'senderId': 'me',
          'text': 'I’m definitely in. Only need 2 more spots for the 15% discount.',
          'timestamp': '12:48 PM',
          'isMe': true,
        },
        {
          'id': '3',
          'senderId': 'alex',
          'text': '',
          'imageUrl':
              'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80',
          'timestamp': '12:49 PM',
          'isMe': false,
          'avatarUrl':
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=100&q=80',
        },
        {
          'id': '4',
          'senderId': 'me',
          'text': 'This angle sells it. That brushed edge is perfect.',
          'timestamp': '12:51 PM',
          'isMe': true,
        },
        {
          'id': '5',
          'senderId': 'alex',
          'text': 'Timer is at 03:12 — sending the link to two more friends now.',
          'timestamp': '12:52 PM',
          'isMe': false,
          'avatarUrl':
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=100&q=80',
        },
      ];
    // Sarah — post‑purchase logistics.
    case 'd2':
      return [
        {
          'id': '1',
          'senderId': 'sarah',
          'text': 'Package just landed in LA ✈️',
          'timestamp': '9:02 AM',
          'isMe': false,
          'avatarUrl':
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=100&q=80',
        },
        {
          'id': '2',
          'senderId': 'sarah',
          'text': 'Sharing the tracking screenshot here.',
          'timestamp': '9:03 AM',
          'isMe': false,
          'avatarUrl':
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=100&q=80',
          'imageUrl':
              'https://images.unsplash.com/photo-1556740749-887f6717d7e4?auto=format&fit=crop&w=800&q=80',
        },
        {
          'id': '3',
          'senderId': 'me',
          'text': 'Got it. I’ll be at the pickup spot 10 minutes early.',
          'timestamp': '9:05 AM',
          'isMe': true,
        },
      ];
    // Marcus — design feedback.
    case 'd3':
      return [
        {
          'id': '1',
          'senderId': 'marcus',
          'text': 'Are we really going for the matte black finish this time?',
          'timestamp': '10:24 AM',
          'isMe': false,
          'avatarUrl':
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=100&q=80',
        },
        {
          'id': '2',
          'senderId': 'me',
          'text':
              'Absolutely. Limited 50‑unit drop — we need to be ready when the timer hits zero.',
          'timestamp': '10:25 AM',
          'isMe': true,
        },
        {
          'id': '3',
          'senderId': 'marcus',
          'text':
              'Matched it with these laces. Squad aesthetic is going to be unmatched.',
          'timestamp': '10:26 AM',
          'isMe': false,
          'avatarUrl':
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=100&q=80',
          'imageUrl':
              'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=800&q=80',
        },
        {
          'id': '4',
          'senderId': 'me',
          'text': 'Clean.',
          'timestamp': '10:27 AM',
          'isMe': true,
        },
      ];
    // Lila — styling ideas.
    case 'd4':
      return [
        {
          'id': '1',
          'senderId': 'lila',
          'text': 'Moodboard for the drop page 👇',
          'timestamp': '6:10 PM',
          'isMe': false,
          'avatarUrl':
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=100&q=80',
        },
        {
          'id': '2',
          'senderId': 'lila',
          'text': '',
          'timestamp': '6:10 PM',
          'isMe': false,
          'avatarUrl':
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=100&q=80',
          'imageUrl':
              'https://images.unsplash.com/photo-1519710164239-da123dc03ef4?auto=format&fit=crop&w=800&q=80',
        },
        {
          'id': '3',
          'senderId': 'me',
          'text': 'Saving this for the campaign deck. Perfect balance of tech + luxury.',
          'timestamp': '6:12 PM',
          'isMe': true,
        },
      ];
    // Jordan — casual chat.
    case 'd5':
      return [
        {
          'id': '1',
          'senderId': 'jordan',
          'text': 'Got the sneakers in. Fit is true‑to‑size.',
          'timestamp': 'Yesterday',
          'isMe': false,
          'avatarUrl':
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=100&q=80',
        },
        {
          'id': '2',
          'senderId': 'me',
          'text': 'Perfect. I’ll shoot them on the concrete set tonight.',
          'timestamp': 'Yesterday',
          'isMe': true,
        },
      ];
    default:
      return const [];
  }
});

final discoverCreatorsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'name': '@AlexVogue',
      'realName': 'Alexander Chen',
      'avatarUrl':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
      'isFollowing': false,
    },
    {
      'name': '@StudioNoir',
      'realName': 'Jordan Blake',
      'avatarUrl':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
      'isFollowing': false,
    },
    {
      'name': '@MonoGear',
      'realName': 'Taylor Reed',
      'avatarUrl':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
      'isFollowing': true,
    },
    {
      'name': '@ElenaV',
      'realName': 'Elena Vasquez',
      'avatarUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
      'isFollowing': false,
    },
    {
      'name': '@DipArchive',
      'realName': 'Marcus Cole',
      'avatarUrl':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=200&q=80',
      'isFollowing': false,
    },
  ];
});

final trendingMoodboardProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=600&q=80',
      'likes': '1.2k',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=600&q=80',
      'likes': '3.1k',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1558171813-4c088753af8f?auto=format&fit=crop&w=600&q=80',
      'likes': '892',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=600&q=80',
      'likes': '2.4k',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=600&q=80',
      'likes': '5.6k',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1469334031218-e382a71b716b?auto=format&fit=crop&w=600&q=80',
      'likes': '1.8k',
    },
  ];
});

/// Mock profile + private rows for edit profile screen.
final editProfileProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'avatarUrl':
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
    'name': 'Alex Obsidian',
    'username': '@alex_drops',
    'bio':
        'Architect of digital experiences. Focused on the intersection of luxury streetwear and functional UI. Based in the shadows.',
    'link': 'obsidian.design',
    'email': 'alex@obsidian.design',
    'phone': '+1 (555) 000-1234',
    'gender': 'Male',
  };
});

/// Flat feed for activity tabs: `forTabs` contains `all` and/or `purchases`.
/// `section`: `yesterday` | `last24h` | `last7days` | `older` (for subheadings).
/// `followBack`: show FOLLOW BACK CTA instead of thumbnail.
final activityTabFeedProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'forTabs': ['all', 'purchases'],
      'section': 'last24h',
      'username': '@alex_vogue',
      'body': 'purchased from your drop',
      'time': '2M',
      'avatarUrl':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
      'thumbnailUrl': _watchImg,
      'showUnreadDot': true,
      'followBack': false,
    },
    {
      'forTabs': ['all'],
      'section': 'last24h',
      'username': '@elenav',
      'body': 'mentioned you in a thread',
      'time': '1H',
      'avatarUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
      'thumbnailUrl': _headphonesImg,
      'showUnreadDot': true,
      'followBack': false,
    },
    {
      'forTabs': ['all', 'purchases'],
      'section': 'last24h',
      'username': '@dip_archive',
      'body': 'purchased Obsidian Steel Chrono',
      'time': '4H',
      'avatarUrl':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=200&q=80',
      'thumbnailUrl': _shoeImg,
      'showUnreadDot': false,
      'followBack': false,
    },
    {
      'forTabs': ['all'],
      'section': 'yesterday',
      'username': '@squad_crafts',
      'body': 'commented: "This colorway is insane."',
      'time': 'YESTERDAY',
      'avatarUrl':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
      'thumbnailUrl': _lensImg,
      'showUnreadDot': false,
      'followBack': false,
    },
    {
      'forTabs': ['all'],
      'section': 'last7days',
      'username': '@mono_gear',
      'body': 'wants you in their buyer circle',
      'time': '2D',
      'avatarUrl':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
      'thumbnailUrl': null,
      'showUnreadDot': false,
      'followBack': true,
    },
    {
      'forTabs': ['all', 'purchases'],
      'section': 'older',
      'username': '@noir_room',
      'body': 'liked your collection',
      'time': '3D',
      'avatarUrl':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=200&q=80',
      'thumbnailUrl': _watchImg,
      'showUnreadDot': false,
      'followBack': false,
    },
  ];
});

/// Mock followers for [FollowConnectionsScreen] (per profile handle — same pool for demo).
final followersForHandleProvider =
    Provider.family<List<Map<String, dynamic>>, String>((ref, _) {
  return [
    {
      'displayName': 'Marcus Thorne',
      'username': '@mthorne_design',
      'avatarUrl':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=200&q=80',
      'isFollowing': false,
    },
    {
      'displayName': 'Julianne V.',
      'username': '@jv_atelier',
      'avatarUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
      'isFollowing': true,
      'badge': 'gold',
    },
    {
      'displayName': 'Sarah Chen',
      'username': '@sarahc',
      'avatarUrl':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=200&q=80',
      'isFollowing': false,
      'badge': 'green',
    },
    {
      'displayName': 'Jordan Blake',
      'username': '@studio_noir',
      'avatarUrl':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
      'isFollowing': true,
    },
  ];
});

/// Mock following list for [FollowConnectionsScreen].
final followingForHandleProvider =
    Provider.family<List<Map<String, dynamic>>, String>((ref, _) {
  return [
    {
      'displayName': 'Elena V Studio',
      'username': '@elenav_studio',
      'avatarUrl':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
      'isFollowing': true,
    },
    {
      'displayName': 'Noir Room',
      'username': '@noir_room',
      'avatarUrl':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
      'isFollowing': true,
    },
    {
      'displayName': 'Mono Gear',
      'username': '@mono_gear',
      'avatarUrl':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
      'isFollowing': true,
      'badge': 'green',
    },
    {
      'displayName': 'Taylor Reed',
      'username': '@mono_gear_official',
      'avatarUrl':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
      'isFollowing': true,
    },
  ];
});

/// Pending follow requests (Follow requests tab).
final followRequestsInboxProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'username': '@kaze_atelier',
      'fullName': 'Kaze Atelier',
      'avatarUrl':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
    },
    {
      'username': '@noir_supply',
      'fullName': 'Noir Supply Co.',
      'avatarUrl':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
    },
    {
      'username': '@pixel_muse',
      'fullName': 'Muse Park',
      'avatarUrl':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
    },
  ];
});

/// Activity sections for [ActivityView] (`title` + `items`).
/// Each item: `username`, `action`, `time`, `type`: `likeComment` | `newFollower` | `followRequest`,
/// optional `avatarUrl`, `thumbnailUrl`, `showUnreadDot`.
final activitySectionsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'title': 'New',
      'items': [
        {
          'username': '@alex_vogue',
          'action': 'liked your dip',
          'time': '2m',
          'type': 'likeComment',
          'avatarUrl':
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
          'thumbnailUrl': _watchImg,
          'showUnreadDot': true,
        },
        {
          'username': '@studio_noir',
          'action': 'started following you',
          'time': '15m',
          'type': 'newFollower',
          'avatarUrl':
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
        },
        {
          'username': '@mono_gear',
          'action': 'wants to follow you',
          'time': '1h',
          'type': 'followRequest',
          'avatarUrl':
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
        },
        {
          'username': '@elenav',
          'action': 'commented: "This colorway is insane."',
          'time': '2h',
          'type': 'likeComment',
          'avatarUrl':
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
          'thumbnailUrl': _headphonesImg,
        },
      ],
    },
    {
      'title': 'This Week',
      'items': [
        {
          'username': '@dip_archive',
          'action': 'purchased from your drop',
          'time': '3d',
          'type': 'likeComment',
          'avatarUrl':
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=200&q=80',
          'thumbnailUrl': _shoeImg,
        },
        {
          'username': '@squad_crafts',
          'action': 'liked your collection',
          'time': '4d',
          'type': 'likeComment',
          'avatarUrl':
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
          'thumbnailUrl': _lensImg,
        },
      ],
    },
    {
      'title': 'Earlier',
      'items': [
        {
          'username': '@noir_room',
          'action': 'started following you',
          'time': '1w',
          'type': 'newFollower',
          'avatarUrl':
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=200&q=80',
        },
      ],
    },
  ];
});

/// Users for [FollowListView] (same pool for Followers / Following tabs).
final followListUsersProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'displayName': 'Alex Obsidian',
      'username': '@alex_drops',
      'avatarUrl':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
    },
    {
      'displayName': 'Jordan Blake',
      'username': '@studio_noir',
      'avatarUrl':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
    },
    {
      'displayName': 'Elena Vasquez',
      'username': '@elenav',
      'avatarUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
    },
    {
      'displayName': 'Marcus Cole',
      'username': '@dip_archive',
      'avatarUrl':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=200&q=80',
    },
    {
      'displayName': 'Taylor Reed',
      'username': '@mono_gear',
      'avatarUrl':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
    },
  ];
});

/// Inbox threads for [InboxView].
/// Optional: `unreadCount`, `showDipBadge` (green dip badge on avatar).
final inboxThreadsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'id': 'd1',
      'displayName': 'Alex Rivera',
      'username': '@alexrivera',
      'preview': 'Yo! Just saw the Luna drop...',
      'timestamp': '2m',
      'isUnread': true,
      'unreadCount': 2,
      'showDipBadge': true,
      'avatarUrl':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
    },
    {
      'id': 'd2',
      'displayName': 'Sarah Chen',
      'username': '@sarahc',
      'preview': 'Sounds good, tracking sent.',
      'timestamp': 'Yesterday',
      'isUnread': false,
      'unreadCount': 0,
      'avatarUrl':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=200&q=80',
    },
    {
      'id': 'd3',
      'displayName': 'Marcus Thorne',
      'username': '@marcus_vibe',
      'preview': '🔥 That chrono is clean.',
      'timestamp': 'Yesterday',
      'isUnread': false,
      'unreadCount': 0,
      'avatarUrl':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=200&q=80',
    },
    {
      'id': 'd4',
      'displayName': 'Lila Vogue',
      'username': '@lilavogue',
      'preview': 'Drop goes live in 20m. Squad buy active.',
      'timestamp': '4h',
      'isUnread': true,
      'unreadCount': 1,
      'avatarUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
    },
    {
      'id': 'd5',
      'displayName': 'Jordan Steel',
      'username': '@jordan_steel',
      'preview': 'See you at the pickup spot.',
      'timestamp': '3 days ago',
      'isUnread': false,
      'unreadCount': 0,
      'avatarUrl':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
    },
  ];
});

/// Lookup helper for chat metadata given a `/chat/room/:id` route id.
final chatThreadByIdProvider =
    Provider.family<Map<String, dynamic>?, String>((ref, id) {
  final threads = ref.watch(inboxThreadsProvider);
  for (final t in threads) {
    if (t['id'] == id) return t;
  }
  return null;
});

/// Inbox thread id for a peer handle (lowercase, no `@`), or null if none.
final chatThreadIdByHandleProvider =
    Provider.family<String?, String>((ref, raw) {
  final h = raw.trim().toLowerCase().replaceAll('@', '');
  final threads = ref.watch(inboxThreadsProvider);
  for (final t in threads) {
    final u = (t['username'] as String?)?.replaceFirst('@', '').toLowerCase();
    if (u == h) return t['id'] as String?;
  }
  return null;
});

/// Comments for [CommentsView].
final commentsFeedProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'username': 'marcus_vibe',
      'time': '2h',
      'body': 'This drop is insane 🔥',
    },
    {
      'username': 'lena.noir',
      'time': '4h',
      'body': 'Copped in cart — checkout was smooth.',
    },
    {
      'username': 'alex_drops',
      'time': '5h',
      'body': 'Anyone know if they restock?',
    },
    {
      'username': 'mono_gear',
      'time': '1d',
      'body': 'Quality is even better in person.',
    },
  ];
});
