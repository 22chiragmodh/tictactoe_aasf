import 'package:flutter/material.dart';
import './Pages/playgame_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './Pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: StreamBuilder(
          builder: (ctx, usersnapshots) {
            if (usersnapshots.hasData) {
              return const PlayGame();
            }
            return const LoginPage();
          },
          stream: FirebaseAuth.instance.authStateChanges()),
    );
  }
}
