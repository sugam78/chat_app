

import 'dart:io';

import 'package:chat_app/Services/chat_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoom extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  const ChatRoom({super.key,required this.receiverEmail,required this.receiverId});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController message = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if(focusNode.hasFocus){
        Future.delayed(
          Duration(milliseconds: 500), () => scrollDown(),
        );
      }
    });
    Future.delayed(
      Duration(milliseconds: 500), () => scrollDown(),
    );
  }



  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    message.dispose();
    super.dispose();
  }

  final scrollController = ScrollController();

  void scrollDown(){
    scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn
    );
  }

  void sendMessage()async{
    if(message.text.isNotEmpty){
      await ChatServices().sendMessage(widget.receiverId, message.text,'text');
      message.clear();
    }
    scrollDown();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: ChatServices().getMessages(auth.currentUser!.uid, widget.receiverId), builder: (context,snapshot){
              if(snapshot.hasError){
                return Center(child: Text('Error'),);
              }
              else if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              return ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  bool isCurrentUser = data['senderId'] == auth.currentUser!.uid;
                  var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

                  return Container(
                    alignment: alignment,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: isCurrentUser ? Colors.purpleAccent : Colors.grey,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        data['message'],
                        style: TextStyle(fontSize: 23),
                      ),
                    ),
                  );
                },
              );
            }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    focusNode: focusNode,
                    controller: message,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1),
                        )
                    ),
                  ),
                ),
                IconButton(onPressed: sendMessage, icon: Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
