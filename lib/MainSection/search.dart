import 'package:flutter/material.dart';
import 'package:mychat/DataBases/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mychat/MainSection/conversationScreen.dart';
import 'package:mychat/models/Constants.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _searchActive = false;
  String msg = "Search here";
  TextEditingController searchText = TextEditingController();
  DataBaseMethods databaseMethods = DataBaseMethods();
  QuerySnapshot searchSnapshot;

  @override
  void initState() {
    super.initState();
  }

  _searchUserRequest() {
    String value = searchText.text;
    databaseMethods.getUserByUserName(value).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? Expanded(
            child: ListView.builder(
              itemCount: searchSnapshot.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              itemBuilder: (context, index) {
                return searchTile(
                  userName: searchSnapshot.docs[index].get("Name"),
                  userMail: searchSnapshot.docs[index].get("email"),
                );
              },
            ),
          )
        : Container();
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\-$a';
    } else {
      return '$a\-$b';
    }
  }

  // Craeating Chat room and for message
  createChatRoomAndStartConservation({String userName}) {
    List<String> chatUsers = [userName, Constants.user];
    String chatRoomId = getChatRoomId(userName, Constants.user);
    Map<String, dynamic> chatRoomMap = {
      "users": chatUsers,
      "chatRoomId": chatRoomId,
    };
    databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ConversationScreen(chatRoomId: chatRoomId,receiverName: userName,);
      },
    ));
  }

  Widget searchTile({String userName, String userMail}) {
    return Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(1, 20, 10, 2),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              Text(
                userMail,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              if (userName != Constants.user) {
                createChatRoomAndStartConservation(userName: userName);
              }
            },
            child: Container(
              width: 80,
              height: 40,
              child: Center(
                child: Text(
                  'Message',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.indigo[900],
                borderRadius: BorderRadius.circular(20.0),
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
      ),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(30.0),
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
                            _searchActive = true;
                            searchSnapshot = null;
                          });
                        } else {
                          setState(() {
                            _searchActive = false;
                            searchSnapshot = null;
                          });
                        }
                      },
                      controller: searchText,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Search User",
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
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, right: 5),
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      if (_searchActive) {
                        _searchUserRequest();
                      }
                    },
                    backgroundColor:
                        _searchActive ? Colors.indigo : Colors.grey,
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          searchList(),
        ],
      ),
    );
  }
}
