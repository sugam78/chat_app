import 'package:chat_app/Utilities/toast_message.dart';
import 'package:chat_app/Widgets/reusuable_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter your email address',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 1),
              ),
            ),
          ),
          ReusuableButton(
              title: 'Continue',
              onTap: () {
                auth
                    .sendPasswordResetEmail(email: email.text.toString())
                    .then((value) {
                  Utilities().toastMesssage('Code sent. Check your email');
                }).onError((error, stackTrace) {
                  Utilities().toastMesssage(error.toString());
                });
              }),
        ],
      ),
    );
  }
}
