import 'package:go_router/go_router.dart';
import 'package:my_portfolio/splash_screen.dart';

class PageRoutes {
  static final goRouter = GoRouter(
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    ],
  );
}
