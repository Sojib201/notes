import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_router.dart';
import '../controllers/note_controller.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final noteController = Get.find<NoteController>();


    return Scaffold(
      body: SafeArea(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRouter.addNote),
        tooltip: 'Add Note',
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}
