import 'package:chat_app_firebase/helper/helper_function.dart';
import 'package:chat_app_firebase/pages/auth/login_page.dart';
import 'package:chat_app_firebase/pages/profile_page.dart';
import 'package:chat_app_firebase/pages/serach_page.dart';
import 'package:chat_app_firebase/service/auth_service.dart';
import 'package:chat_app_firebase/service/database_service.dart';
import 'package:chat_app_firebase/widget/group_tile.dart';
import 'package:chat_app_firebase/widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService =AuthService();
  String userName="";
  String email="";
  Stream? groups;
  bool _isLoading= false;
  String groupName='';

  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  //String Manipulation
  String getId(String res){
    return res.substring(0,res.indexOf("_"));
  }
  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }

  gettingUserData() async{
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email=value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName=val!;
      });
    });
    // getting the list of in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot){
      setState(() {
        groups=snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Groups",style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold),),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            nextScreen(context, SearchPage());
          }, icon: Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color(0xffECF2FF),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle,size: 150,color: Colors.grey[800],),
            SizedBox(height: 15,),
            Text(userName,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 30,),
            Divider(height: 2,),
            ListTile(
              onTap: (){},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              leading: Icon(Icons.group),
              title: Text("Groups"),
            ),
            ListTile(
              onTap: (){
                nextScreenReplace(context, ProfilePage(userName: userName,email: email,));
              },
              // selectedColor: Theme.of(context).primaryColor,
              // selected: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              leading: Icon(Icons.person),
              title: Text("Profile"),
            ),
            ListTile(
              onTap: ()async{
                showDialog(
                  barrierDismissible: false,
                    context: context, builder: (context){
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to logout?"),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.cancel,color: Colors.red,)),
                      IconButton(onPressed: () async{
                        await authService.signOut();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>LoginPage()),
                            (route)=>false);
                      }, icon: Icon(Icons.done,color: Colors.green,))
                    ],
                  );
                });
              },
              // selectedColor: Theme.of(context).primaryColor,
              // selected: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              leading: Icon(Icons.logout),
              title: Text("Logout"),
            ),
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,size: 30,
        ),
      ),
    );
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot){
        //make some checks
        if(snapshot.hasData){
          if(snapshot.data['groups']!= null){
            if(snapshot.data['groups'].length!=0){
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context,index){
                    int reverseIndex = snapshot.data['groups'].length-index-1;
                  return GroupTile(
                      userName: snapshot.data['fullName'],
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]));
                  }
              );
            }else{
              return noGroupWidget();
            }
          }else{
            return noGroupWidget();
          }

        }else{
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      }
    );
  }
  popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
        context: context, builder: (context){
      return StatefulBuilder(
        builder: (context,setState) {
         return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            backgroundColor: Color(0xffECF2FF),
            title: Text("Create a group", textAlign: TextAlign.left,),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true ? Center(
                  child: CircularProgressIndicator(color: Theme
                      .of(context)
                      .primaryColor,),)
                    : TextField(
                  onChanged: (val) {
                    setState(() {
                      groupName = val;
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme
                                  .of(context)
                                  .primaryColor
                          ),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red
                          ),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme
                                  .of(context)
                                  .primaryColor
                          ),
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text("Cancel"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme
                        .of(context)
                        .primaryColor
                ),
              ),
              ElevatedButton(onPressed: () async {
                if (groupName != "") {
                  setState(() {
                    _isLoading = true;
                  });
                  DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                      .createGroup(
                      userName, FirebaseAuth.instance.currentUser!.uid,
                      groupName)
                      .whenComplete(() {
                    _isLoading = false;
                  });
                  Navigator.of(context).pop();
                  showSnackbar(
                      context, Color(0xff655DBB), "Group created Successfully");
                }
              }, child: Text("Create"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme
                        .of(context)
                        .primaryColor),
              ),
            ],
          );
        });
    });
  }

  noGroupWidget() {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              popUpDialog(context);
            },
              child: Icon(Icons.add_circle,color: Colors.grey[700],size: 75,)),
          SizedBox(height: 20,),
          Text("You've not joined any groups, tap on th add icon to create a group or also search from top search buton",textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
