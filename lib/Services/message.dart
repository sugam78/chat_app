import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderId;
  final String receiverId;
  final String senderEmail;
  final String message;
  final String type;
  final Timestamp timestamp;

  Message({
    required this.timestamp,required this.message,required this.receiverId,required this.senderEmail,required this.senderId, required this.type
});

  Map<String,dynamic> toMap(){
    return{
      'senderId' : senderId,
      'receiverId' : receiverId,
      'senderEmail' : senderEmail,
      'message' : message,
      'type': type,
      'timestamp' : timestamp,
    };
  }
}