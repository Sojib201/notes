import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:notes_app/presentation/controllers/auth_controller.dart';
import 'package:notes_app/presentation/controllers/note_controller.dart';
import 'core/constants/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(NoteController());

  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Obx(() => MaterialApp.router(
      title: 'Notable',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // themeMode: themeController.themeMode,
      themeMode: Get.find<ThemeController>().themeMode,
      routerConfig: AppRouter.router,
    ));
  }
}

