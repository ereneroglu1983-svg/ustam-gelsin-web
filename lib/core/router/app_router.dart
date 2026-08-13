import 'package:go_router/go_router.dart';
import 'package:ustam_gelsin/features/home/screens/home_screen.dart';
import 'package:ustam_gelsin/features/home/screens/insaat_rehberi.dart';
import 'package:ustam_gelsin/features/rehber/screens/rehber_detay_screen.dart';
import 'package:ustam_gelsin/features/wallet/screens/odeme_sonuc_screen.dart';

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
    // --- ODEME ROUTE'LARI EKLENDI ---
    GoRoute(
      path: '/odeme-basarili',
      builder: (context, state) {
        final amount = state.uri.queryParameters['amount'] ?? '0';
        final paymentId = state.uri.queryParameters['paymentId'] ?? '';
        return OdemeSonucScreen(
          isSuccess: true,
          message: paymentId.isNotEmpty
              ? '$amount TL bakiyene eklendi! (İşlem: $paymentId)'
              : '$amount TL bakiyene eklendi!',
        );
      },
    ),
    GoRoute(
      path: '/odeme-basarisiz',
      builder: (context, state) {
        final reason = state.uri.queryParameters['reason'] ?? '';
        return OdemeSonucScreen(
          isSuccess: false,
          message: reason.isNotEmpty
              ? 'Ödeme başarısız: $reason'
              : 'Ödeme başarısız veya iptal edildi.',
        );
      },
    ),
  ],
);