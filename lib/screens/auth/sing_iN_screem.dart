import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import your authentication provider

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.onTap});
  final Function()? onTap;

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sign In"),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);
                    },
                    child: const Text('Sign In'),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("not have account  "),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.onTap;
                      });
                    },
                    child: const Text(
                      "Create!",
                      style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
