import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final Timestamp timeStamp;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.timeStamp,
  });

  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      completed: data['completed'] ?? false,
      timeStamp: data['createdAt'] ?? data['timeStamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': timeStamp,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
    };
  }

  // Create from plain map
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      completed: map['completed'] ?? false,
      timeStamp: map['timeStamp'] is int
          ? Timestamp.fromMillisecondsSinceEpoch(map['timeStamp'])
          : Timestamp.now(),
    );
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    int? colorIndex,
    Timestamp? timeStamp,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class NoteModel {
//   final String id;
//   final String uid; // Changed from userId to uid
//   final String title;
//   final String description;
//   final int colorIndex;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   const NoteModel({
//     required this.id,
//     required this.uid,
//     required this.title,
//     required this.description,
//     this.colorIndex = 0,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   // Create from Firestore document
//   factory NoteModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return NoteModel(
//       id: doc.id,
//       uid: data['uid'] ?? '', // Changed from userId to uid
//       title: data['title'] ?? '',
//       description: data['description'] ?? '',
//       colorIndex: data['colorIndex'] ?? 0,
//       createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//     );
//   }
//
//   // Convert to Firestore map
//   Map<String, dynamic> toFirestore() {
//     return {
//       'uid': uid, // Changed from userId to uid
//       'title': title,
//       'description': description,
//       'colorIndex': colorIndex,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'updatedAt': Timestamp.fromDate(updatedAt),
//     };
//   }
//
//   // Convert to plain map (for passing via go_router extra)
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'uid': uid, // Changed from userId to uid
//       'title': title,
//       'description': description,
//       'colorIndex': colorIndex,
//       'createdAt': createdAt.millisecondsSinceEpoch,
//       'updatedAt': updatedAt.millisecondsSinceEpoch,
//     };
//   }
//
//   // Create from plain map
//   factory NoteModel.fromMap(Map<String, dynamic> map) {
//     return NoteModel(
//       id: map['id'] ?? '',
//       uid: map['uid'] ?? '', // Changed from userId to uid
//       title: map['title'] ?? '',
//       description: map['description'] ?? '',
//       colorIndex: map['colorIndex'] ?? 0,
//       createdAt: DateTime.fromMillisecondsSinceEpoch(
//           map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
//       updatedAt: DateTime.fromMillisecondsSinceEpoch(
//           map['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch),
//     );
//   }
//
//   NoteModel copyWith({
//     String? id,
//     String? uid,
//     String? title,
//     String? description,
//     int? colorIndex,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return NoteModel(
//       id: id ?? this.id,
//       uid: uid ?? this.uid,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       colorIndex: colorIndex ?? this.colorIndex,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
// }