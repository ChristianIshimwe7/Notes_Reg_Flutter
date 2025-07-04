import 'package:cloud_firestore/cloud_firestore.dart';
import 'note_provider.dart'; // Add this import to use the Note class

class NoteRepository {
  final CollectionReference _notes =
      FirebaseFirestore.instance.collection('notes');

  Future<List<Note>> fetchNotes() async {
    final snapshot = await _notes.get();
    return snapshot.docs
        .map((doc) => Note(id: doc.id, title: doc['title']))
        .toList();
  }

  Future<void> addNote(String title) async {
    await _notes
        .add({'title': title, 'timestamp': FieldValue.serverTimestamp()});
  }

  Future<void> updateNote(String id, String title) async {
    await _notes.doc(id).update({'title': title});
  }

  Future<void> deleteNote(String id) async {
    await _notes.doc(id).delete();
  }
}
