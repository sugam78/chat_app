import 'package:chat_app/Authentication/verify_phone.dart';
import 'package:chat_app/Utilities/toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/loading_provider.dart';
import '../Widgets/reusuable_button.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  TextEditingController controller = TextEditingController();
  TextEditingController name = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final loadingProvider =
    Provider.of<LoadingProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login with Phone number'),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: name,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Enter Your Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1),
                ),
              ),
              maxLength: 16,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Your Name';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter phone number';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer<LoadingProvider>(builder: (context, value, index) {
              return ReusuableButton(
                  title: 'Continue',
                  loading: value.loading,
                  onTap: () {
                    loadingProvider.Change();
                    auth.verifyPhoneNumber(
                        phoneNumber: controller.text,
                        verificationCompleted: (_) {
                          loadingProvider.Change();
                        },
                        verificationFailed: (e) {
                          loadingProvider.Change();
                          Utilities().toastMesssage(e.toString());
                        },
                        codeSent: (String id, int? token) {
                          loadingProvider.Change();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerifyPhone(
                                    id: id,
                                    name: name.text,
                                  )));
                        },
                        codeAutoRetrievalTimeout: (e) {
                          loadingProvider.Change();
                          Utilities().toastMesssage(e);
                        });
                  });
            }),
          ],
        ));
  }
}
