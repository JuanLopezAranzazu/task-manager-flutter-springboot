import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/tasks_screen.dart';
import '../screens/task_form_screen.dart';
import '../models/task.dart';

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

final routerNotifierProvider =
    Provider((ref) => _RouterNotifier(ref));

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final path = state.matchedLocation;

      if (auth.isChecking) {
        return path == '/' ? null : '/';
      }

      final publicRoutes = ['/login', '/register'];
      final isPublic = publicRoutes.contains(path);

      if (!auth.isAuthenticated && !isPublic) return '/login';
      if (auth.isAuthenticated && (isPublic || path == '/')) return '/tasks';

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(
        path: '/login',
        pageBuilder: (_, state) => _fade(state, const LoginScreen()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (_, state) => _slide(state, const RegisterScreen()),
      ),
      GoRoute(
        path: '/tasks',
        pageBuilder: (_, state) => _fade(state, const TasksScreen()),
        routes: [
          GoRoute(
            path: 'new',
            pageBuilder: (_, state) =>
                _slide(state, const TaskFormScreen()),
          ),
          GoRoute(
            path: 'edit/:id',
            pageBuilder: (_, state) {
              final task = state.extra as Task;
              return _slide(state, TaskFormScreen(task: task));
            },
          ),
        ],
      ),
    ],
  );
});

CustomTransitionPage _fade(GoRouterState state, Widget child) =>
    CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );

CustomTransitionPage _slide(GoRouterState state, Widget child) =>
    CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic))
            .animate(animation),
        child: child,
      ),
    );
