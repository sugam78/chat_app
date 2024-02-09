import 'package:chat_app/Provider/theme_provider.dart';
import 'package:chat_app/UI/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/loading_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyAvi9G_CfURVHddOncZe1AttKwerXnyPFQ',
        appId: '1:1084703884153:android:55b76060a894779828e5a8',
        messagingSenderId: '1084703884153',
        projectId: 'chatapp-46229',

    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>LoadingProvider()),
        ChangeNotifierProvider(create: (_)=>ThemeProvider()),
      ],
      child:  Builder(builder: (context){
    return MaterialApp(
    title: 'Chat App',
    home: const SplashScreen(),
    debugShowCheckedModeBanner: false,
    theme: Provider.of<ThemeProvider>(context).themeData,
    );
    })
    );
  }
}
