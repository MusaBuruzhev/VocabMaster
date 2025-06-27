
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
   
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for android.');
      case TargetPlatform.iOS:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for ios.');
      case TargetPlatform.macOS:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for macos.');
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyAi_A31evnFeA0H8ArkmGSMNPA5nny9pTo",
      authDomain: "word-5ea2b.firebaseapp.com",
      projectId: "word-5ea2b",
      storageBucket: "word-5ea2b.firebasestorage.app",
      messagingSenderId: "397197821278",
      appId: "1:397197821278:web:5a16935546c9476e377bcf",
      measurementId: "G-72QM1Q5ENL"
  );
}