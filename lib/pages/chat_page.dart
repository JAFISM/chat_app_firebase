import 'package:chat_app_firebase/pages/group_info.dart';
import 'package:chat_app_firebase/service/database_service.dart';
import 'package:chat_app_firebase/shared/constants.dart';
import 'package:chat_app_firebase/widget/message_tile.dart';
import 'package:chat_app_firebase/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage({Key? key, required this.groupId, required this.groupName, required this.userName}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String admin="";
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController =TextEditingController();


  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }
  getChatAndAdmin(){
    DatabaseService().getChats(widget.groupId).then((val){
      setState(() {
        chats=val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value){
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: (){
            nextScreen(context,  GroupInfo(
              groupId: widget.groupId,
              groupName: widget.groupName,
              adminName: admin,
            ));
          }, icon: const Icon(Icons.info_outline))
        ],
      ),
      body: Stack(
        children: [
          //chat message here
          chatMessage(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Color(0xffECF2FF),
              child: Row(
                children: [
                  Expanded(child: Container(
                   padding: EdgeInsets.symmetric(horizontal: 8.0),
                   decoration: BoxDecoration(
                   color: Constants.c1.withOpacity(0.8),
                   borderRadius: BorderRadius.circular(25.0),),
                    child: TextFormField(
                      controller: messageController,
                      style: TextStyle(
                        color: Colors.white
                      ),
                      decoration: InputDecoration(
                        hintText: "Send  a Message",
                        hintStyle: TextStyle(color: Colors.white,fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  )),
                  SizedBox(width: 12,),
                  GestureDetector(
                    onTap: (){
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Center(child: Icon(Icons.send,color: Colors.white,),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  chatMessage() {
    return StreamBuilder(
      stream: chats,
      builder: (context,AsyncSnapshot snapshot){
        return snapshot.hasData
        ? ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (context,index){
          return MessageTile(message: snapshot.data.docs[index]['message'],
              sender: snapshot.data.docs[index]['sender'],
              sendByMe: widget.userName==snapshot.data.docs[index]['sender']);
        },
        )
            :Container();
      },
    );
  }

  sendMessage() {
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> chatMessageMap={
        "message" : messageController.text,
        "sender"  : widget.userName,
        "time"    :DateTime.now().microsecondsSinceEpoch
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
