import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../presentation/pages/add_note_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/note_detail_page.dart';
import '../../presentation/pages/register_page.dart';
import '../../presentation/pages/splash_page.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addNote = '/add-note';
  static const String editNote = '/edit-note';
  static const String noteDetail = '/note-detail';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final isAuthRoute =
          state.matchedLocation == login || state.matchedLocation == register;
      final isSplash = state.matchedLocation == splash;

      if (isSplash) return null;

      if (!isLoggedIn && !isAuthRoute) return login;

      if (isLoggedIn && isAuthRoute) return home;

      return null;
    },
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: addNote,
        builder: (context, state) => const AddNotePage(),
      ),
      GoRoute(
        path: editNote,
        builder: (context, state) {
          final note = state.extra as Map<String, dynamic>;
          return AddNotePage(noteToEdit: note);
        },
      ),
      GoRoute(
        path: noteDetail,
        builder: (context, state) {
          final note = state.extra as Map<String, dynamic>;
          return NoteDetailPage(note: note);
        },
      ),
    ],
  );
}
