import 'package:cloud_firestore/cloud_firestore.dart';
import 'note_provider.dart';

class NoteRepository {
  final CollectionReference _notes =
      FirebaseFirestore.instance.collection('notes');

  Future<List<Note>> fetchNotes(String userId) async {
    try {
      final snapshot = await _notes
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) =>
              Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  Future<void> addNote(String title, String userId) async {
    try {
      final now = DateTime.now();
      await _notes.add({
        'title': title,
        'userId': userId,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  Future<void> updateNote(String id, String title) async {
    try {
      await _notes.doc(id).update({
        'title': title,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _notes.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }
}
