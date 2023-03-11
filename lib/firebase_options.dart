// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSmLBCf7-ziHbfEGvU4Ca1UqZmM4duELE',
    appId: '1:450986871741:android:b918f5b348d4338dd960d4',
    messagingSenderId: '450986871741',
    projectId: 'lovetap3-dd028',
    databaseURL: 'https://lovetap3-dd028-default-rtdb.firebaseio.com',
    storageBucket: 'lovetap3-dd028.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCGsEqWwbdO2gZOD8b0UOeetM7yaEAIkyE',
    appId: '1:450986871741:ios:6565e1ef390ed070d960d4',
    messagingSenderId: '450986871741',
    projectId: 'lovetap3-dd028',
    databaseURL: 'https://lovetap3-dd028-default-rtdb.firebaseio.com',
    storageBucket: 'lovetap3-dd028.appspot.com',
    androidClientId: '450986871741-h1pp2d0rineb98b431hsivle6umfbnpv.apps.googleusercontent.com',
    iosClientId: '450986871741-61lnfdthpslmhgeok31tbeha04c6k8j3.apps.googleusercontent.com',
    iosBundleId: 'com.KopaunikSoftware.lovetap3',
  );
}
