import 'package:author_registration/screens/add_or_edit_author_page.dart';
import 'package:author_registration/screens/homepage.dart';
import 'package:author_registration/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash_screen',
      routes: {
        'splash_screen': (context) => const SplashScreen(),
        '/': (context) => const HomePage(),
        'add_or_edit_author_screen': (context) => const AddOrEditAuthor(),
      },
    ),
  );
}
