import 'package:chat_app/Provider/theme_provider.dart';
import 'package:chat_app/Services/chat_services.dart';
import 'package:chat_app/Themes/light_mode.dart';
import 'package:chat_app/UI/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  with WidgetsBindingObserver{
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    setStatus('Online');
  }

  void setStatus(String status)async{
    await fireStore.doc(auth.currentUser!.uid).update({
      "Status" : status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if(state == AppLifecycleState.resumed){
      setStatus('Online');
    }else{
      setStatus('Offline');
    }

    super.didChangeAppLifecycleState(state);
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Chat'),

      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
                stream: ChatServices().getUserStream(), builder: (context,snapshots){
                  if(snapshots.hasError){
                    return Text('Error');
                  }
                  else if(snapshots.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: snapshots.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var userData = snapshots.data![index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatRoom(
                                      receiverEmail: userData['name'],
                                      receiverId: userData['uid'],
                                    ),
                                  ),
                                );
                              },
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.person, size: 23,),
                                          SizedBox(width: 10,),
                                          Text(userData['name'], style: TextStyle(fontSize: 23),),
                                        ],
                                      ),
                                      Text(userData['Status']),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],
                        );
                      },
                    ),
                  );
            }),
          ],
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                  child: Icon(Icons.message_outlined)
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                trailing: Icon(
                    Icons.home),
                title: Text('HOME'),
              ),
              ListTile(
                trailing: CupertinoSwitch(
                    value: provider.themeData == lightMode? false: true,
                    onChanged: (value){
                      provider.onChange();
                }
                ),
                title: Text('Dark Mode'),
              ),
              ListTile(
                onTap: ()async{
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.setBool('login', false);
                  auth.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                trailing: Icon(
                  Icons.logout),
                title: Text('Logout'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
