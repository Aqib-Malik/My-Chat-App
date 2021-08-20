import 'package:cloud_firestore/cloud_firestore.dart';

class MessageFirebaseServices {
  ///****Uploading message on firebasae******/
  static Future<void> callbacknew(String msg, String chatId, String recId,
      senId, String sendName, String recName, List combId, String url) async {
    //if (msg.length > 0) {
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(chatId)
        .collection('userChats')
        .add({
      'messageBody': msg,
      'reciverId': recId,
      'recivername': recName,
      'senderId': senId,
      'senderName': sendName,
      'createdAt':
          Timestamp.now(), //DateTime.now().toIso8601String().toString(),
      'combineId':
          combId, //FirebaseAuth.instance.currentUser.email + recieverUser.id,
      'msgPic': url
    });
  }
}
