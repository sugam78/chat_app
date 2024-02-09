import 'package:chat_app/Authentication/forgot_password.dart';

import 'package:chat_app/Authentication/phone_login.dart';
import 'package:chat_app/Authentication/signup_screen.dart';
import 'package:chat_app/UI/home_screen.dart';
import 'package:chat_app/Widgets/reusuable_button.dart';
import 'package:chat_app/Provider/loading_provider.dart';
import 'package:chat_app/Utilities/toast_message.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loadingProvider =
    Provider.of<LoadingProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Login'),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 80,),
                      Icon(Icons.message_outlined,size: 90,),
                      SizedBox(height: 10,),
                      Text('Welcome Back'),
                      const SizedBox(
                        height: 30,
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
                      Consumer<LoadingProvider>(
                          builder: (context, value, index) {
                            return ReusuableButton(
                                title: 'Login',
                                loading: value.loading,
                                onTap: () {
                                  loadingProvider.Change();
                                  auth
                                      .signInWithEmailAndPassword(
                                      email: email.text.toString(),
                                      password: pass.text.toString())
                                      .then((value) async {
                                    SharedPreferences sp =
                                    await SharedPreferences.getInstance();
                                    sp.setBool('login', true);

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const HomeScreen()));
                                    loadingProvider.Change();
                                  }).onError((error, stackTrace) {
                                    loadingProvider.Change();
                                    Utilities().toastMesssage(error.toString());
                                  });
                                });
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      ReusuableButton(
                          title: 'Login with Phone number',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PhoneLogin()));
                          }),
                      const SizedBox(
                        height: 30,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Dont have an account?'),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const SignUpScreen()));
                              },
                              child: const Text('Sign Up')),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const ForgotPassword()));
                          },
                          child: const Text('Forgot password'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
