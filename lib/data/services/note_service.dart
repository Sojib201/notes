import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';

class NoteService {
  final CollectionReference noteCollection =
  FirebaseFirestore.instance.collection('notes');

  User? get user => FirebaseAuth.instance.currentUser;

  Future<DocumentReference> addNote(
      String title, String description,) async {
    return await noteCollection.add({
      'uid': user!.uid,
      'title': title,
      'description': description,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote(String id, String title, String description,) async {
    final updateNoteCollection =
    FirebaseFirestore.instance.collection('notes').doc(id);
    return await updateNoteCollection.update({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNoteStatus(String id, bool completed) async {
    return await noteCollection.doc(id).update({'completed': completed});
  }

  Future<void> deleteNote(String id) async {
    return await noteCollection.doc(id).delete();
  }

  Stream<List<NoteModel>> get noteList {
    return noteCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(noteListFromSnapshot);
  }

  List<NoteModel> noteListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return NoteModel(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        completed: data['completed'] ?? false,
        // timeStamp: data['createdAt'] ?? data['timeStamp'] ?? Timestamp.now(),
        timeStamp: doc['createdAt'] ?? Timestamp.now(),
      );
    }).toList();
  }
}