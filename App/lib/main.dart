import 'package:flutter/material.dart';
import 'package:project/Pages/home.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'PROJECT_NAME',
      options: const FirebaseOptions(
          apiKey: "FIREBASE_API_KEY",
          appId: "APP_ID",
          messagingSenderId: "MSG_S_ID",
          projectId: "PROJECT_ID",
          storageBucket: 'STORAGE_BUCKET'
      )
  );
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
  );
}