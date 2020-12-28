import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  getUserByUserName(String searchText) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .orderBy('Name')
        .startAt([searchText]).endAt([searchText + '\uf8ff']).get();
  }

  getUserInfo(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {});
  }

  uploadUserInfo(userMap) async {
    await FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) async {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {});
  }

  addConversationMessage(String chatRoomId, messageMap) async {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {});
  }

  getConservationMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async{
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
