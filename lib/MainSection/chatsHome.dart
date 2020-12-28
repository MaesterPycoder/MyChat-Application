import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychat/Authentication/signIn.dart';
import 'package:mychat/DataBases/database.dart';
import 'package:mychat/MainSection/conversationScreen.dart';
import 'package:mychat/MainSection/search.dart';
import 'package:mychat/Authentication/services.dart';
import 'package:mychat/models/Constants.dart';
import 'package:mychat/models/helperFunctions.dart';

class ChatHome extends StatefulWidget {
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  AuthMethods _auth = AuthMethods();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  Stream chatRoomStream;
  String receiverName;
  String chatRoomId;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  Widget chatListTile(String userName, String chatRoomId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId: chatRoomId,receiverName: receiverName,),
            ));
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 2),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Colors.white30,
        child: Row(
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.indigo[900]),
              child: Icon(
                CupertinoIcons.person_crop_circle_badge_checkmark,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              userName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapShot) {
          return snapShot.hasData
              ? ListView.builder(
                  itemCount: snapShot.data.docs.length,
                  itemBuilder: (context, index) {
                    receiverName = snapShot.data.docs[index]
                        .get("chatRoomId")
                        .toString()
                        .replaceAll("-", "")
                        .replaceAll(Constants.user, "");
                        chatRoomId = snapShot.data.docs[index]
                        .get("chatRoomId");
                    return chatListTile(receiverName,chatRoomId);
                  },
                )
              : Container(
                  child: Center(child: CircularProgressIndicator()),
                );
        });
  }

  getUserInfo() async {
    Constants.user = await HelperFunctions.getUserUserNameSharedPreference();
    dataBaseMethods.getChatRooms(Constants.user).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        centerTitle: true,
        title: Row(
          children: [Icon(Icons.chat), Text("MyChart")],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        actions: [
          GestureDetector(
            child: Icon(Icons.search),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen())),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              _auth.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            },
            child: Icon(Icons.logout),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: chatRoomList(),
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
    );
  }
}
