// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Replace with your Firebase config from google-services.json
    return const FirebaseOptions(
      apiKey: 'YOUR_API_KEY',
      appId: 'YOUR_APP_ID',
      messagingSenderId: 'YOUR_SENDER_ID',
      projectId: 'YOUR_PROJECT_ID',
      authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
      storageBucket: 'YOUR_PROJECT_ID.appspot.com',
      measurementId: 'YOUR_MEASUREMENT_ID',
    );
  }
}
