import 'package:flutter/material.dart';
import 'note_repository.dart';

class Note {
  final String id;
  String title;

  Note({required this.id, required this.title});
}

class NoteProvider with ChangeNotifier {
  final NoteRepository _repository = NoteRepository();
  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  NoteProvider() {
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    _isLoading = true;
    notifyListeners();
    _notes = await _repository.fetchNotes();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(String title) async {
    try {
      await _repository.addNote(title);
      await _fetchNotes();
      if (_scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Note added successfully')));
      }
    } catch (e) {
      if (_scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(const SnackBar(content: Text('Error adding note')));
      }
    }
  }

  Future<void> updateNote(String id, String title) async {
    try {
      await _repository.updateNote(id, title);
      await _fetchNotes();
      if (_scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Note updated successfully')));
      }
    } catch (e) {
      if (_scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(const SnackBar(content: Text('Error updating note')));
      }
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _repository.deleteNote(id);
      await _fetchNotes();
      if (_scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Note deleted successfully')));
      }
    } catch (e) {
      if (_scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(const SnackBar(content: Text('Error deleting note')));
      }
    }
  }
}

final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();
