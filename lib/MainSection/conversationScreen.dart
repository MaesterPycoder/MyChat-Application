import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychat/DataBases/database.dart';
import 'package:mychat/models/Constants.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String receiverName;
  ConversationScreen({this.chatRoomId, this.receiverName});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  bool _msgActive = false;
  TextEditingController msgText = TextEditingController();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  Stream chatMessagesStream;

  @override
  void initState() {
    dataBaseMethods.getConservationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  Widget messageTile(String message, bool isSendByme) {
    return Container(
      alignment: isSendByme ? Alignment.centerRight : Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSendByme ? Colors.indigo[900] : Colors.white30,
          borderRadius: isSendByme
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )
              : BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapShot) {
        return snapShot.hasData
            ? ListView.builder(
                itemCount: snapShot.data.docs.length,
                itemBuilder: (context, index) {
                  return messageTile(
                      snapShot.data.docs[index].get("Message"),
                      snapShot.data.docs[index].get("sendBy") ==
                          Constants.user);
                },
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }

  sendMessage() {
    if (msgText.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "Message": msgText.text,
        "sendBy": Constants.user,
        "timeStamp": DateTime.now().millisecondsSinceEpoch,
      };
      dataBaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
    }
  }

  Widget msgTypeField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: TextField(
                autocorrect: false,
                cursorColor: Colors.yellow,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      _msgActive = true;
                    });
                  } else {
                    setState(() {
                      _msgActive = false;
                    });
                  }
                },
                controller: msgText,
                decoration: InputDecoration(
                  hintText: "message...",
                  hintStyle: TextStyle(
                    color: Colors.white70,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.indigoAccent,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, right: 5),
            child: FloatingActionButton(
              onPressed: () {
                sendMessage();
                msgText.clear();
              },
              splashColor: _msgActive ? Colors.green : Colors.red,
              mini: true,
              backgroundColor: _msgActive ? Colors.indigo : Colors.grey,
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 25.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(widget.receiverName),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: msgTypeField(),
            ),
          ],
        ),
      ),
    );
  }
}
