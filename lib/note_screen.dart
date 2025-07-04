import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note_provider.dart'; // Ensure this import is correct

class NoteScreen extends StatelessWidget {
  final TextEditingController _noteController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(controller: _noteController),
        actions: [
          TextButton(
            onPressed: () {
              if (_noteController.text.isNotEmpty) {
                Provider.of<NoteProvider>(context, listen: false)
                    .addNote(_noteController.text);
                _noteController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context, Note note) {
    _noteController.text = note.title;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(controller: _noteController),
        actions: [
          TextButton(
            onPressed: () {
              if (_noteController.text.isNotEmpty) {
                Provider.of<NoteProvider>(context, listen: false)
                    .updateNote(note.id, _noteController.text);
                _noteController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(title: const Text('Notes')),
          body: noteProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : noteProvider.notes.isEmpty
                  ? const Center(
                      child: Text('Nothing here yet—tap ➕ to add a note'))
                  : ListView.builder(
                      itemCount: noteProvider.notes.length,
                      itemBuilder: (context, index) {
                        final note = noteProvider.notes[index];
                        return ListTile(
                          title: Text(note.title),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _showEditNoteDialog(context, note)),
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      noteProvider.deleteNote(note.id)),
                            ],
                          ),
                        );
                      },
                    ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddNoteDialog(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
