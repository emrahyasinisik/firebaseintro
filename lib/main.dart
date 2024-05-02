import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseintro/firebase_options.dart';
import 'package:firebaseintro/screens/auth.dart';
import 'package:firebaseintro/screens/homePage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          // Oturum durumu değişikliği dinleniyor
          if (snapshot.hasData) {
            // Kullanıcı oturum açık ise HomePage'e yönlendir
            return const HomePage();
          } else {
            // Kullanıcı oturum kapalı ise Auth sayfasına yönlendir
            return const Auth();
          }
        },
      ),
    ),
  );
}
