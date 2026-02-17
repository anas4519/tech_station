import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/bottom_nav_shell.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/devices/presentation/bloc/device_detail_bloc.dart';
import '../../features/devices/presentation/pages/home_page.dart';
import '../../features/devices/presentation/pages/device_detail_page.dart';
import '../../features/devices/presentation/pages/categories_page.dart';
import '../../features/compare/presentation/pages/compare_page.dart';
import '../../features/community/presentation/pages/community_page.dart';
import '../../features/account/presentation/pages/account_page.dart';
import '../../injection_container.dart';
import '../../features/devices/domain/usecases/get_device_by_id.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router(AuthBloc authBloc) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      redirect: (context, state) {
        final authState = authBloc.state;
        final isAuth = authState is AuthAuthenticated;
        final isOnLogin = state.matchedLocation == '/login';
        final isOnRegister = state.matchedLocation == '/register';

        if (!isAuth && !isOnLogin && !isOnRegister) {
          return '/login';
        }
        if (isAuth && (isOnLogin || isOnRegister)) {
          return '/';
        }
        return null;
      },
      refreshListenable: _GoRouterAuthNotifier(authBloc),
      routes: [
        // ── Auth Routes ──
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),

        // ── Main Shell ──
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return BottomNavShell(navigationShell: navigationShell);
          },
          branches: [
            // Home
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const HomePage(),
                ),
              ],
            ),
            // Categories
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/categories',
                  builder: (context, state) => const CategoriesPage(),
                ),
              ],
            ),
            // Compare
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/compare',
                  builder: (context, state) => const ComparePage(),
                ),
              ],
            ),
            // Community
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/community',
                  builder: (context, state) => const CommunityPage(),
                ),
              ],
            ),
            // Account
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/account',
                  builder: (context, state) => const AccountPage(),
                ),
              ],
            ),
          ],
        ),

        // ── Device Detail (full-screen) ──
        GoRoute(
          path: '/device/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final deviceId = state.pathParameters['id']!;
            return BlocProvider(
              create: (_) =>
                  DeviceDetailBloc(getDeviceById: sl<GetDeviceById>()),
              child: DeviceDetailPage(deviceId: deviceId),
            );
          },
        ),
      ],
    );
  }
}

/// Notifier that listens to AuthBloc state changes for GoRouter refresh
class _GoRouterAuthNotifier extends ChangeNotifier {
  _GoRouterAuthNotifier(AuthBloc authBloc) {
    authBloc.stream.listen((_) => notifyListeners());
  }
}
