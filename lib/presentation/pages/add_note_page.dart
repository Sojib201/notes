import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../controllers/note_controller.dart';
import '../widgets/app_button.dart';

class AddNotePage extends StatefulWidget {
  final Map<String, dynamic>? noteToEdit;

  const AddNotePage({super.key, this.noteToEdit});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late final NoteController _controller;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<NoteController>();
    _isEdit = widget.noteToEdit != null;

    if (_isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.loadNoteForEditing(widget.noteToEdit!);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.titleController.clear();
        _controller.descriptionController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(_isEdit ? 'Edit Note' : 'New Note'),
        actions: [
          if (_isEdit)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
              onPressed: () => _controller.deleteNote(
                context,
                widget.noteToEdit!['id'],
              ),
              tooltip: 'Delete note',
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _controller.titleController,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Note title (optional)',
                        hintStyle: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.hintColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 16
                        ),
                        filled: true,
                        fillColor: theme.inputDecorationTheme.fillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(18),
                      ),
                      maxLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _controller.descriptionController,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Write your note here...',
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor,),
                        filled: true,
                        fillColor: theme.inputDecorationTheme.fillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(18),
                        alignLabelWithHint: true,
                      ),
                      maxLines: null,
                      minLines: 12,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Obx(() => AppButton(
                    label: _isEdit ? 'Update Note' : 'Save Note',
                    isLoading: _controller.isSaving.value,
                    icon: _isEdit ? Icons.update_rounded : Icons.save_rounded,
                    onPressed: () {
                      if (_isEdit) {
                        _controller.updateNote(
                          context,
                          widget.noteToEdit!['id'],
                        );
                      } else {
                        _controller.addNote(context);
                      }
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
