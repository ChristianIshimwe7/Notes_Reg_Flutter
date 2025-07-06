Christian ISHIMWE
African Leadership University
Mobile Application Development
Cohort 1

Documentation of Flutter Notes App
Github link : 
Table of Contents
1.	Project Overview
2.	Architecture
3.	Features
4.	Firebase Configuration
5.	Code Structure
6.	Authentication System
7.	Notes Management
8.	Troubleshooting and other Generic errors fixing
9.	Deployment Guide
10.	Best Practices
________________________________________
1.	Project Overview
Application Description
The Flutter Notes App is a cross-platform mobile application that allows users to create, read, update, and delete personal notes. The app integrates with Firebase for authentication and cloud storage, ensuring data persistence and user security.
Technology Stack
I.	Frontend: Flutter (Dart)
II.	Backend: Firebase
III.	Authentication: Firebase Authentication
IV.	Database: Cloud Firestore
V.	State Management: Provider Pattern
VI.	Development Environment: FlutLab
Key Features
•	User authentication (Sign up/Login)
•	Create, Read, update/edit, and delete notes
•	Real-time data synchronization
•	User-specific note storage
•	Responsive UI design
•	Error handling and validation
________________________________________
2.	Architecture
App Architecture Pattern
The application follows the Repository Pattern with Provider State Management:
├── Presentation Layer (UI)
│   ├── AuthScreen (Login/Signup)
│   └── NoteScreen (Notes Management)
├── Business Logic Layer
│   └── NoteProvider (State Management)
├── Data Layer
│   └── NoteRepository (Firebase Operations)
└── Models
    └── Note (Data Model)
Data Flow
1.	User interacts with UI (AuthScreen/NoteScreen)
2.	UI calls Provider methods
3.	Provider calls Repository methods
4.	Repository communicates with Firebase
5.	Data flows back through the same path
________________________________________
3. Features
1. User Authentication
I.	Sign Up: Create new user accounts
II.	Login: Authenticate existing users
III.	Auto-login: Persistent authentication state
IV.	Logout: Secure session termination
V.	Input Validation: Email format and password strength
2. Notes Management
I.	Create Notes: Add new notes with timestamps
II.	View Notes: Display all user notes in chronological order
III.	Edit Notes: Modify existing note content
IV.	Delete Notes: Remove unwanted notes
V.	Real-time Updates: Automatic synchronization across devices
3. User Interface
I.	Material Design: Clean, modern UI
II.	Responsive Layout: Works on different screen sizes
III.	Loading States: Visual feedback during operations
IV.	Error Messages: User-friendly error handling
V.	Empty State: Guidance when no notes exist
________________________________________
4.	Firebase Configuration
Project Setup
I.	Project ID: registration-form-78d72
II.	Project Name: Notes App
III.	Region: Default (US-Central)
Firebase Services Used
I.	Authentication: Email/Password authentication
II.	Firestore: NoSQL document database
III.	Security Rules: User-specific data access
Configuration Files
firebase_options.dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyCLNwKKlrQcImnIU0s46S9AbsbrbPKOUvw',
  appId: '1:444647292036:android:19bdab9384c29c6cbcd6d1',
  messagingSenderId: '444647292036',
  projectId: 'registration-form-78d72',
  storageBucket: 'registration-form-78d72.firebasestorage.app'
);
Main App Initialization
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
________________________________________
5.	Code Structure
File Organization
lib/
├── main.dart                 # App entry point
├── auth_screen.dart          # Authentication UI
├── note_screen.dart          # Notes management UI
├── note_provider.dart        # State management
├── note_repository.dart      # Data operations
└── firebase_options.dart     # Firebase configuration
Key Components
I.  main.dart
•	App initialization
•	Firebase setup
•	Provider configuration
•	Route management
II. auth_screen.dart
•	User authentication UI
•	Form validation
•	Error handling
•	State management
III. note_screen.dart
•	Notes display
•	CRUD operations UI
•	Dialog management
•	User interactions
IV. note_provider.dart
•	State management
•	Business logic
•	Error handling
•	UI updates
V. note_repository.dart
•	Firebase operations
•	Data persistence
•	Query management
•	Exception handling
________________________________________
6.	Authentication System
Authentication Flow
1.	User opens app
2.	StreamBuilder checks authentication state
3.	If authenticated → Navigate to NoteScreen
4.	If not authenticated → Show AuthScreen
Security Features
•	Password Validation: Minimum 6 characters
•	Email Validation: Proper email format
•	Error Handling: Firebase-specific error messages
•	Session Management: Automatic login persistence
Error Handling
1.	ERROR 1
 
This is has been caused by : [cloud_firestore/failed-precondition] The query requires an index. 

It means I was using a Firestore query that filters on multiple fields (likely something like where('uid', ...) and maybe orderBy('timestamp'))—and Firestore needs a composite index to execute it.
This is a normal behavior in Firestore. It only automatically creates single-field indexes, so multi-field combinations require you to manually create an index.

✅ How Firestore Handles This
Firestore is actually being helpful: it generates a direct link in the error message to create the required index. When I click that link, it auto-fills the correct fields and opens the Firebase Console’s index creation screen. Pretty convenient, actually!



2.	ERRO2

Switch (e.code) {
  case 'user-not-found':
    message = 'No user found for that email.';
    break;
  case 'wrong-password':
    message = 'Wrong password provided.';
    break;
  case 'email-already-in-use':
    message = 'The account already exists for that email.';
    break;
  // Additional error cases...
}

What's to Fix:
•	✅ Use lowercase switch — Dart is case-sensitive: Switch ❌ → switch ✅
•	✅ Ensure the entire block is inside a function/method body
•	✅ Declare the message variable before the switch

Fixed code : 

String message;
switch (e.code) {
  case 'user-not-found':
    message = 'No user found for that email.';
    break;
  case 'wrong-password':
    message = 'Wrong password provided.';
    break;
  case 'email-already-in-use':
    message = 'The account already exists for that email.';
    break;
  // Add more cases as needed
  default:
    message = 'Authentication error: ${e.message}';
}



3.	ERROR 3

 

It says :Authentication failed.

Cause : Firebase email/password sign-in not enabled in the Firebase Console.

Resolving : Catching the FirebaseAuthException and using a proper switch...case instead of => to handle error codes:

String message;
switch (e.code) {
  case 'email-already-in-use':
    message = 'Email already in use.';
    break;
  case 'weak-password':
    message = 'Password is too weak.';
    break;
  // other cases...
  default:
    message = 'Authentication error: ${e.message}';
}

________________________________________
7.	Notes Management
Data Model
class Note {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
}
Database Structure
notes (Collection)
├── documentId (Auto-generated)
│   ├── title: String
│   ├── userId: String
│   ├── createdAt: Timestamp
│   └── updatedAt: Timestamp
CRUD Operations
Create Note
await _notes.add({
  'title': title,
  'userId': userId,
  'createdAt': Timestamp.fromDate(now),
  'updatedAt': Timestamp.fromDate(now),
});
Read Notes
final snapshot = await _notes
    .where('userId', isEqualTo: userId)
    .orderBy('updatedAt', descending: true)
    .get();
Update Note
await _notes.doc(id).update({
  'title': title,
  'updatedAt': Timestamp.fromDate(DateTime.now()),
});
Delete Note
await _notes.doc(id).delete();
________________________________________
8.	Troubleshooting and other Generic errors fixing
Common Issues and Solutions
1. Index Missing Error
Problem: [cloud_firestore/failed-precondition] The query requires an index
Solution: Create composite index in Firebase Console:
•	Collection: notes
•	Fields: userId (Ascending), updatedAt (Descending)
2. Authentication Errors
Problem: Various Firebase Auth exceptions
Solutions:
•	Check Firebase Console authentication settings
•	Verify email/password authentication is enabled
•	Check network connectivity
•	Validate user input
3. Permission Denied
Problem: Firestore security rules blocking access
Solution: Update Firestore rules:
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{document} {
      allow read, write: if request.auth != null && 
                           request.auth.uid == resource.data.userId;
    }
  }
}
4. Notes Not Displaying
Possible Causes:
•	Missing Firestore index
•	Incorrect user ID
•	Network connectivity issues
•	Security rules blocking access
Debug Steps:
1.	Check console logs
2.	Verify Firebase Console data
3.	Test with simplified queries
4.	Check authentication state
________________________________________
9.	Deployment Guide
Prerequisites
•	Flutter SDK installed
•	Firebase project configured
•	Android Studio/VS Code setup
Build Steps
1. Development Build
flutter run
2. Release Build (Android)
flutter build apk --release
3. Production Deployment
1.	Generate signed APK
2.	Upload to Google Play Store
3.	Configure Firebase production settings
4.	Update security rules for production
Environment Configuration
•	Development: Test Firebase project
•	Production: Production Firebase project
•	Staging: Separate Firebase project for testing
________________________________________
10.	Best Practices
Code Quality
•	Error Handling: Comprehensive try-catch blocks
•	Input Validation: Client-side and server-side validation
•	Code Organization: Separation of concerns
•	Documentation: Inline comments and documentation
Security
•	Authentication: Secure user authentication
•	Data Access: User-specific data isolation
•	Input Sanitization: Validate all user inputs
•	Security Rules: Proper Firestore security rules
Performance
•	Lazy Loading: Load data as needed
•	Caching: Local data caching where appropriate
•	Optimization: Efficient database queries
•	Resource Management: Proper disposal of resources
User Experience
•	Loading States: Visual feedback during operations
•	Error Messages: Clear, actionable error messages
•	Responsive Design: Works on different screen sizes
•	Accessibility: Proper accessibility features
________________________________________
Future Enhancements
Planned Features
1.	Rich Text Editor: Enhanced note formatting
2.	Categories/Tags: Organize notes by category
3.	Search Functionality: Find notes quickly
4.	Offline Support: Work without internet
5.	Data Export: Export notes to various formats
6.	Sharing: Share notes with other users
7.	Dark Mode: Theme customization
8.	Backup/Restore: Data backup functionality
Technical Improvements
•	Unit Testing: Comprehensive test coverage
•	Integration Tests: End-to-end testing
•	Performance Monitoring: Firebase Performance
•	Analytics: User behavior tracking
•	Crash Reporting: Firebase Crashlytics
________________________________________
11.	Conclusion
The Flutter Notes App demonstrates a complete mobile application with modern architecture, secure authentication, and cloud-based data storage. The app follows best practices for Flutter development and Firebase integration, providing a solid foundation for future enhancements.
Key Achievements
•	✅ Cross-platform mobile application
•	✅ Secure user authentication
•	✅ Real-time data synchronization
•	✅ Clean, maintainable code structure
•	✅ Comprehensive error handling
•	✅ User-friendly interface
Developer Information
•	Created by: Christian ISHIMWE
•	Development Platform: FlutLab
•	Documentation Date: July 2025
•	Version: 1.0.0
________________________________________

