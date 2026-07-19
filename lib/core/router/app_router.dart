import 'package:go_router/go_router.dart';
import 'package:ustam_gelsin/features/home/screens/home_screen.dart';
import 'package:ustam_gelsin/features/home/screens/insaat_rehberi.dart';
import 'package:ustam_gelsin/features/rehber/screens/rehber_detay_screen.dart'; // TEK DOĞRU YOL BU

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/rehber',
      builder: (context, state) => const InsaatRehberiScreen(),
    ),
    GoRoute(
      path: '/rehber/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return RehberDetayScreen(slug: slug);
      },
    ),
  ],
);