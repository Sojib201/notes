import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_router.dart';
import '../../data/models/note_model.dart';
import '../controllers/note_controller.dart';

class NoteDetailPage extends StatelessWidget {
  final Map<String, dynamic> note;

  const NoteDetailPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NoteController>();
    final noteModel = NoteModel.fromMap(note);
    final theme = Theme.of(context);

    final formattedDate =
    DateFormat('MMMM d, yyyy · h:mm a').format(noteModel.timeStamp.toDate());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(
              AppRouter.editNote,
              extra: noteModel.toMap(),
            ),
            tooltip: 'Edit note',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.error),
            onPressed: () => controller.deleteNote(context, noteModel.id),
            tooltip: 'Delete note',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              if (noteModel.title.isNotEmpty) ...[
                Text(
                  noteModel.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
              ],
              Text(
                noteModel.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}