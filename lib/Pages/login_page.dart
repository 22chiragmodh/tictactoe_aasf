import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/authform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  var _isloading = false;

  void _submitauthform(String email, String username, String password,
      bool islogin, BuildContext ctx) async {
    UserCredential authresult;

    try {
      setState(() {
        _isloading = true;
      });

      if (islogin) {
        authresult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authresult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }

      await FirebaseFirestore.instance
          .collection('GamePlayer')
          .doc(authresult.user!.uid)
          .set({
        'username': username,
        'email': email,
        'password': password,
      });
      print(authresult.user!.uid);
    } on PlatformException catch (err) {
      String? message = "An error occurred, please check your crendittals";

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message!,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );

      setState(() {
        _isloading = false;
      });
    } catch (err) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            err.toString(),
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      // print(err);

      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blueGrey,
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(),
          child: AuthForm(_submitauthform, _isloading),
        ),
      ),
    );
  }
}
