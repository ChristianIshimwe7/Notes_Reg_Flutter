import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'note_repository.dart';

class Note {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  Note({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Note.fromFirestore(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      title: data['title'] ?? '',
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: data['updatedAt']?.toDate() ?? DateTime.now(),
      userId: data['userId'] ?? '',
    );
  }
}

class NoteProvider with ChangeNotifier {
  final NoteRepository _repository = NoteRepository();
  List<Note> _notes = [];
  bool _isLoading = false;
  BuildContext? _context;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  void setContext(BuildContext context) {
    _context = context;
  }

  Future<void> fetchNotes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _notes = await _repository.fetchNotes(user.uid);
    } catch (e) {
      _showSnackBar('Error fetching notes: ${e.toString()}', Colors.red);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(String title) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _repository.addNote(title, user.uid);
      await fetchNotes();
      _showSnackBar('Note added successfully', Colors.green);
    } catch (e) {
      _showSnackBar('Error adding note: ${e.toString()}', Colors.red);
    }
  }

  Future<void> updateNote(String id, String title) async {
    try {
      await _repository.updateNote(id, title);
      await fetchNotes();
      _showSnackBar('Note updated successfully', Colors.green);
    } catch (e) {
      _showSnackBar('Error updating note: ${e.toString()}', Colors.red);
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _repository.deleteNote(id);
      await fetchNotes();
      _showSnackBar('Note deleted successfully', Colors.green);
    } catch (e) {
      _showSnackBar('Error deleting note: ${e.toString()}', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
        ),
      );
    }
  }
}
