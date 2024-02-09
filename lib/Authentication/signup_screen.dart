import 'package:chat_app/Authentication/login_screen.dart';
import 'package:chat_app/Provider/loading_provider.dart';
import 'package:chat_app/Utilities/toast_message.dart';
import 'package:chat_app/Widgets/reusuable_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final loadingProvider =
    Provider.of<LoadingProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Sign Up'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Your Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1),
                  ),
                ),
                maxLength: 16,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: pass,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<LoadingProvider>(builder: (context, value, index) {
                return ReusuableButton(
                    title: 'Sign Up',
                    loading: value.loading,
                    onTap: () {
                      loadingProvider.Change();
                      auth
                          .createUserWithEmailAndPassword(
                          email: email.text.toString(),
                          password: pass.text.toString())
                          .then((value) async{
                        loadingProvider.Change();
                        await _firestore.collection('users').doc(auth.currentUser!.uid).set(
                            {
                              "name" : name.text,
                              "email": email.text,
                              "uid": auth.currentUser!.uid,
                              "Status": "Unavailable"
                            }
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      }).onError((error, stackTrace) {
                        loadingProvider.Change();
                        Utilities().toastMesssage(error.toString());
                      });
                    });
              }),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text('Login')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
