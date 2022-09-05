import 'dart:io';

import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitform, this.isloading, {Key? key}) : super(key: key);

  final bool isloading;

  final void Function(String email, String username, String password,
      bool islogin, BuildContext ctx) submitform;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _islogin = true;
  String _useremail = '';
  String _username = '';
  String _userpassword = '';

  void _trysubmit() {
    final isValid = _formkey.currentState!.validate();

    FocusScope.of(context).unfocus(); //hide soft keyboard

    // if (!_islogin) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: const Text('you are not valid user'),
    //     backgroundColor: Theme.of(context).errorColor,
    //   ));

    //   return;
    // }

    if (isValid) {
      _formkey.currentState?.save();
      // print(_username);
      // print(_useremail);
      // print(_userpassword);
      widget.submitform(_useremail.trim(), _username.trim(),
          _userpassword.trim(), _islogin, context);
    }

    //use those value to send our firebase api
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      key: const ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'please enter a valid email address';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: "Email Address",
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      onSaved: (value) {
                        _useremail = value!;
                      },
                    ),
                    if (!_islogin)
                      TextFormField(
                        key: const ValueKey('username'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Please enter atleast 4 characters';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Username",
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 16.0)),
                        onSaved: (value) {
                          _username = value.toString();
                        },
                      ),
                    TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.password),
                          labelText: "Password",
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 16.0)),
                      onSaved: (value) {
                        _userpassword = value!;
                      },
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    if (widget.isloading) const CircularProgressIndicator(),
                    if (!widget.isloading)
                      ElevatedButton(
                        onPressed: _trysubmit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          primary: Colors.transparent,
                          textStyle: const TextStyle(
                            fontSize: 23,
                          ),
                        ),
                        child: Text(_islogin ? 'Login' : 'Signup'),
                      ),
                    if (!widget.isloading)
                   const SizedBox(height: 12),
                      ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _islogin = !_islogin;
                            });
                          },
                          icon: const Icon(Icons.account_circle),
                          label: Text(
                              _islogin
                                  ? 'Create a new account'
                                  : 'I have already an account',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white))),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       _islogin = !_islogin;
                    //     });
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Colors.transparent,
                    //      shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12.0),
                    //     ),
                    //     textStyle: const TextStyle(
                    //       fontSize: 23,
                    //     ),
                    //   ),
                    //   child: Text(_islogin
                    //       ? 'Create a new account'
                    //       : 'I have already an account'),
                    // ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
