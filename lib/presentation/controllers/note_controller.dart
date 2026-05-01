import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/note_model.dart';
import '../../data/services/note_service.dart';

class NoteController extends GetxController {
  final NoteService _noteService = NoteService();

  final RxList<NoteModel> notes = <NoteModel>[].obs;
  final RxList<NoteModel> searchResults = <NoteModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxBool isSaving = false.obs;
  final RxString searchQuery = ''.obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  StreamSubscription? _notesSubscription;

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    startListeningToNotes();
  }

  @override
  void onClose() {
    _notesSubscription?.cancel();
    titleController.dispose();
    descriptionController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void startListeningToNotes() {
    if (uid.isEmpty) return;
    isLoading.value = true;

    _notesSubscription?.cancel();
    _notesSubscription = _noteService.noteList.listen(
          (noteList) {
        notes.assignAll(noteList);
        isLoading.value = false;
      },
      onError: (e) {
        isLoading.value = false;
        _showError('Failed to load notes.');
      },
    );
  }

  Future<void> addNote(BuildContext context) async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (description.isEmpty) {
      _showError('Description cannot be empty.');
      return;
    }

    isSaving.value = true;
    try {
      await _noteService.addNote(
        title,
        description,
      );
      _clearForm();
      if (context.mounted) {
        Navigator.of(context).pop();
        _showSuccess('Note saved!');
      }
    } catch (e) {
      _showError('Failed to save note. Please try again.');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateNote(BuildContext context, String noteId) async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (description.isEmpty) {
      _showError('Description cannot be empty.');
      return;
    }

    isSaving.value = true;
    try {
      await _noteService.updateNote(
        noteId,
        title,
        description,
      );
      _clearForm();
      if (context.mounted) {
        Navigator.of(context).pop();
        _showSuccess('Note updated!');
      }
    } catch (e) {
      _showError('Failed to update note. Please try again.');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteNote(BuildContext context, String noteId) async {
    final confirmed = await _showDeleteDialog(context);
    if (!confirmed) return;

    try {
      await _noteService.deleteNote(noteId);
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      _showSuccess('Note deleted.');
    } catch (e) {
      _showError('Failed to delete note.');
    }
  }

  Future<void> search(String query) async {
    searchQuery.value = query;

    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      QuerySnapshot snapshot = await _noteService.noteCollection
          .where('uid', isEqualTo: uid)
          .get();

      final allNotes = _noteService.noteListFromSnapshot(snapshot);
      final lowerQuery = query.toLowerCase();

      final results = allNotes.where((note) {
        return note.title.toLowerCase().contains(lowerQuery) ||
            note.description.toLowerCase().contains(lowerQuery);
      }).toList();

      searchResults.assignAll(results);
    } catch (e) {
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    searchResults.clear();
  }

  void loadNoteForEditing(Map<String, dynamic> noteMap) {
    final note = NoteModel.fromMap(noteMap);
    titleController.text = note.title;
    descriptionController.text = note.description;
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Note',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content:
        const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF5252),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ??
        false;
  }

  void _showSuccess(String message) {
    if (Get.context != null) {
      Get.snackbar(
        'Success',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF00BFA5),
        colorText: const Color(0xFFFFFFFF),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _showError(String message) {
    if (Get.context != null) {
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF5252),
        colorText: const Color(0xFFFFFFFF),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}