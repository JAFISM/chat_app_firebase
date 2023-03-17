import 'package:chat_app_firebase/helper/helper_function.dart';
import 'package:chat_app_firebase/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  bool isLoading =false;
  QuerySnapshot ? searchSnapshot;
  bool hasUserSearched=false;
  String userName="";
  User? user;

  @override
  void initState() {
    getCurrentUserIdandName();
    super.initState();
  }
  getCurrentUserIdandName()async{
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName =value!;
      });
    });
    User? user= FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text("Search",style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    color: Colors.white
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Serach groups...",
                    hintStyle: TextStyle(color: Colors.white,fontSize: 16)
                  ),
                )),
                GestureDetector(
                  onTap: (){
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.search,color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),): groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async{
    if(_searchController.text.isNotEmpty){
      setState(() {
        isLoading=true;
      });
      await DatabaseService().searchByName(_searchController.text).then((snapshot){
        setState(() {
          searchSnapshot=snapshot;
          isLoading=true;
        });
      });
    }
  }
  groupList(){
    return hasUserSearched ? ListView.builder(
      shrinkWrap: true,
        itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context,index){
        return groupTile(
          userName,
          searchSnapshot!.docs[index]['groupId'],
          searchSnapshot!.docs[index]['groupName'],
          searchSnapshot!.docs[index]['admin'],
        );
        })
        :Container();
  }
  Widget groupTile(String userName,String groupId,String groupName,String admin){
    return Text("Hello");
  }

}
