import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movielist/login.dart';
import 'homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MovieListApp());
}

class MovieListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        './home': (context) => MyHomePage(title: 'My Movie List App'),
        './login': (contxet) => LoginPage()
      },
      title: 'Movie List',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? MyHomePage(title: 'My Movie List App')
          : LoginPage(),
    );
  }
}
