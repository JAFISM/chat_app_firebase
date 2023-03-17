import 'package:chat_app_firebase/pages/group_info.dart';
import 'package:chat_app_firebase/service/database_service.dart';
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
      body: Center(
        child: Text(widget.groupName),
      ),
    );
  }
}
