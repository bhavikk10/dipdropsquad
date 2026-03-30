import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_gate.dart';
import '../screens/main_scaffold.dart';
import '../features/feed/presentation/home_feed_screen.dart';
import '../screens/drops_screen.dart';
import '../screens/profile_screen.dart';
import '../features/explore/presentation/explore_screen.dart';
import '../features/profile/presentation/edit_profile_screen.dart';
import '../features/profile/presentation/follow_connections_screen.dart';
import '../features/profile/presentation/become_dropper_intro_screen.dart';
import '../features/profile/presentation/become_dropper_form_screen.dart';
import '../features/profile/presentation/become_dropper_status_screen.dart';
import '../features/drops/presentation/product_detail_screen.dart';
import '../features/chat/presentation/chat_screen.dart';
import '../features/create/presentation/create_chooser_screen.dart';
import '../features/create/presentation/new_dip_screen.dart';
import '../features/create/presentation/new_drop_screen.dart';
import '../features/auth/presentation/welcome_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/auth/presentation/verify_email_screen.dart';
import '../screens/auth/terms_screen.dart';
import '../features/activity/presentation/activity_screen.dart';
import '../features/chat/presentation/inbox_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/auth/welcome',
  redirect: (context, state) {
    final loc = state.uri.path;
    final wantsAuth = loc.startsWith('/auth/');

    // Until platform rules are accepted, keep the user in the auth flow.
    if (!AuthGate.termsAccepted && !wantsAuth) {
      return '/auth/welcome';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/auth/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/auth/verify',
      builder: (context, state) => const VerifyEmailScreen(),
    ),
    GoRoute(
      path: '/auth/terms',
      builder: (context, state) => const TermsScreen(),
    ),
    GoRoute(
      path: '/activity',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ActivityScreen(),
    ),
    GoRoute(
      path: '/inbox',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const InboxScreen(),
    ),
    GoRoute(
      path: '/create/dip',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const NewDipScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved),
              child: child,
            ),
          );
        },
      ),
    ),
    GoRoute(
      path: '/create/drop',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const NewDropScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved),
              child: child,
            ),
          );
        },
      ),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeFeedScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const ExploreScreen(),
        ),
        // Create chooser: shell child so [MainScaffold] tab bar stays visible.
        GoRoute(
          path: '/create',
          builder: (context, state) => const CreateChooserScreen(),
        ),
        GoRoute(
          path: '/drops',
          builder: (context, state) => const DropsScreen(),
          routes: [
            GoRoute(
              path: 'detail/:id',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return ProductDetailScreen(dropId: id);
              },
            ),
          ]
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) => const Center(child: Text('Chat List')),
          routes: [
            GoRoute(
              path: 'room/:id',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return ChatScreen(chatId: id);
              },
            ),
          ]
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: 'u/:handle',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final handle = state.pathParameters['handle'] ?? '';
                return ProfileScreen(viewedHandle: handle);
              },
            ),
            GoRoute(
              path: 'edit',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const EditProfileScreen(),
            ),
            GoRoute(
              path: 'dropper',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const BecomeDropperIntroScreen(),
              routes: [
                GoRoute(
                  path: 'apply',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const BecomeDropperFormScreen(),
                ),
                GoRoute(
                  path: 'status',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const BecomeDropperStatusScreen(),
                ),
              ],
            ),
            GoRoute(
              path: 'connections',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final q = state.uri.queryParameters;
                final handle = (q['handle'] ?? 'alex_drops').toLowerCase();
                final name = q['name'] ?? 'Profile';
                final tab = int.tryParse(q['tab'] ?? '0') ?? 0;
                return FollowConnectionsScreen(
                  profileHandle: handle,
                  displayName: name,
                  initialTab: tab,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
