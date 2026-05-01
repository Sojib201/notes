import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_router.dart';
import '../controllers/auth_controller.dart';
import '../controllers/note_controller.dart';
import '../controllers/theme_controller.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_bar_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final noteController = Get.find<NoteController>();
    final authController = Get.find<AuthController>();
    final themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);

    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? user?.email?.split('@').first ?? 'there';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRouter.addNote),
        tooltip: 'Add Note',
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}
