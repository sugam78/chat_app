import 'package:chat_app/Services/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<Map<String,dynamic>>> getUserStream(){
    return firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverId,message,type) async{
    Message newMessage = Message(
        timestamp: Timestamp.now(), message: message,
        receiverId: receiverId,
        senderEmail: auth.currentUser!.email.toString(),
        senderId: auth.currentUser!.uid,
        type: type,
    );
    List<String> ids = [auth.currentUser!.uid,receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    await firestore.collection("chat_room").doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    List<String> ids = [userId,otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return firestore.collection("chat_room").doc(chatRoomId).collection('messages').orderBy("timestamp",descending: false).snapshots();
  }


}