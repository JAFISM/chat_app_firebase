import 'package:chat_app_firebase/pages/home_page.dart';
import 'package:chat_app_firebase/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../widget/widgets.dart';
import 'auth/login_page.dart';
class ProfilePage extends StatefulWidget {
  String userName;
  String email;
   ProfilePage({Key? key,required this.userName,required this.email}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
        title: Text("Pofile",style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold),),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xffECF2FF),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle,size: 150,color: Theme.of(context).primaryColor,),
            SizedBox(height: 15,),
            Text(widget.userName,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 30,),
            Divider(height: 2,),
            ListTile(
              onTap: (){
                nextScreen(context, HomePage());
              },
              // selectedColor: Theme.of(context).primaryColor,
              // selected: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              leading: Icon(Icons.group),
              title: Text("Groups"),
            ),
            ListTile(
              onTap: (){},
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              leading: Icon(Icons.person,),
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
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: Column(
          children: [
            Center(child: Icon(Icons.account_circle,size: 200,color: Theme.of(context).primaryColor,)),
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Column(
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text("Name",style: TextStyle(fontSize: 17),),
            //           Text(widget.userName,style: TextStyle(fontSize: 17),)
            //         ],
            //       ),
            //       SizedBox(
            //         height: 15,
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text("Email",style: TextStyle(fontSize: 17),),
            //           Text(widget.email,style: TextStyle(fontSize: 17),)
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            // Container(
            //   height: 60,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(15),
            //     color: Theme.of(context).primaryColor
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       Text("Name",style: TextStyle(fontSize: 17,color: Colors.white),),
            //       SizedBox(width: 50,),
            //       Text(widget.userName,style: TextStyle(fontSize: 17,color: Colors.white),),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              tileColor: Theme.of(context).primaryColor,
              leading: Text("Name",style: TextStyle(fontSize: 17,color: Colors.white),),
              trailing: Text(widget.userName,style: TextStyle(fontSize: 17,color: Colors.white) ,),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
             // hoverColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              tileColor: Theme.of(context).primaryColor,
              leading: Text("Email",style: TextStyle(fontSize: 17,color: Colors.white),),
              trailing: Text(widget.email,style: TextStyle(fontSize: 17,color: Colors.white),)
            ),
          ],
        ),
      )
    );
  }
}
