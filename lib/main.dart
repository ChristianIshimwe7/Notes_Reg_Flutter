import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart';
import 'note_screen.dart';
import 'note_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCLNwKKlrQcImnIU0s46S9AbsbrbPKOUvw",
      authDomain: "registration-form-78d72.firebaseapp.com",
      projectId: "registration-form-78d72",
      storageBucket: "registration-form-78d72.firebasestorage.app",
      messagingSenderId: "444647292036",
      appId: "1:444647292036:android:19bdab9384c29c6cbcd6d1",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: MaterialApp(
        title: 'Notes App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData) {
              return NoteScreen();
            } else {
              return AuthScreen();
            }
          },
        ),
      ),
    );
  }
}
