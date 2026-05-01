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
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $displayName 👋',
                          style: theme.textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'My Notes',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                        () => _IconBtn(
                      icon: themeController.isDarkMode.value
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      onTap: themeController.toggleTheme,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _IconBtn(
                    icon: Icons.logout_rounded,
                    onTap: () => authController.signOut(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SearchBarWidget(
                controller: noteController.searchController,
                onChanged: noteController.search,
                onClear: noteController.clearSearch,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(
                    () {
                  if (noteController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                      ),
                    );
                  }

                  final isSearchActive = noteController.searchQuery.isNotEmpty;
                  final displayNotes = isSearchActive
                      ? noteController.searchResults
                      : noteController.notes;

                  debugPrint('Notes count: ${noteController.notes.length}, Search results count: ${noteController.searchResults.length}');

                  if (displayNotes.isEmpty) {
                    return EmptyState(
                      isSearch: isSearchActive,
                      searchQuery: noteController.searchQuery.value,
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async => noteController.startListeningToNotes(),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                      itemCount: displayNotes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final note = displayNotes[index];
                        return NoteCard(
                          note: note,
                          onDelete: () => noteController.deleteNote(
                            context,
                            note.id,
                          ),
                          onEdit: () => context.push(
                            AppRouter.editNote,
                            extra: note.toMap(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
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

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 22, color: AppColors.primary),
      ),
    );
  }
}