// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chatting_app/service/firebasse_service.dart';

// Import your authentication provider

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final Function()? onTap;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  String image = '';
  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    final imagePicker = await picker.pickImage(source: ImageSource.gallery);
    if (imagePicker == null) {
      return;
    }
    setState(() {
      image = imagePicker.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'username'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: ' Password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // FirebaseService().signUp(
                      //   email: emailController.text,
                      //   password: passwordController.text,
                      //   userName: usernameController.text,
                      // );
                    },
                    child: const Text('Sign Up'),
                  ),
                  Row(
                    children: [
                      const Text("already have account  "),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.onTap;
                          });
                        },
                        child: const Text(
                          "Login!",
                          style:
                              TextStyle(fontSize: 20, color: Colors.blueGrey),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
