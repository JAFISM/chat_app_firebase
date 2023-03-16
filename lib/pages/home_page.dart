import 'package:chat_app_firebase/helper/helper_function.dart';
import 'package:chat_app_firebase/pages/auth/login_page.dart';
import 'package:chat_app_firebase/pages/profile_page.dart';
import 'package:chat_app_firebase/pages/serach_page.dart';
import 'package:chat_app_firebase/service/auth_service.dart';
import 'package:chat_app_firebase/widget/widgets.dart';
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

  @override
  void initState() {
    gettingUserData();
    super.initState();
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
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              leading: Icon(Icons.group),
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
                authService.signOut().whenComplete(() {
                  nextScreenReplace(context, LoginPage());
                });
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              leading: Icon(Icons.logout),
              title: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
