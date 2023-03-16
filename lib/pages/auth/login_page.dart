import 'package:chat_app_firebase/pages/auth/register_page.dart';
import 'package:chat_app_firebase/service/auth_service.dart';
import 'package:chat_app_firebase/service/database_service.dart';
import 'package:chat_app_firebase/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../../widget/widgets.dart';
import '../home_page.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey=GlobalKey<FormState>();
  String email='';
  String password='';
  bool _isLoading=false;
  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //  backgroundColor: Theme.of(context).primaryColor,
      // ),
      body:_isLoading? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),):
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 100),
          child: Form(
            key:formKey,
            child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text("Rho-Voiceless!",style: TextStyle(color:Constants.c1,fontSize: 40,fontWeight: FontWeight.bold),),
                 Text("Login now to see what they they are talking ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                 Image.asset("assets/grp_chat_img.png",),
                 TextFormField(
                   decoration: textInputDecoration.copyWith(
                       labelText: "E-Mail",
                       prefixIcon: Icon(Icons.email,color: Theme.of(context).primaryColor,)
                   ),
                   onChanged: (val){
                     setState(() {
                       email=val;
                     });
                   },
                   validator: (val){
                     return RegExp(
                         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                         .hasMatch(val!)
                         ? null
                         : "Please enter a valid email";
                   }
                 ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock,color: Theme.of(context).primaryColor,)
                  ),
                  onChanged: (val){
                    setState(() {
                      password=val;
                    });
                  },
                  validator: (val){
                    if(val!.length<6){
                      return " Password must be at least 6 character";
                    }
                    else{
                      return null;
                    }
                  },
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: (){
                    login();
                  }, child: Text("Sign In",style: TextStyle(fontSize: 16),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      )
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text.rich(
                    TextSpan(
                        text:
                        "Dont have an account ?",style: TextStyle(color: Colors.black,fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Register here",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor
                          ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            nextScreen(context, RegisterPage());
                          }),
                      ]
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

   login() async{
     if (formKey.currentState!.validate()) {
       setState(() {
         _isLoading = true;
       });
       await authService
           .loginWithUsernameandPassword( email, password)
           .then((value) async{
         if(value == true) {
      QuerySnapshot snapshot=await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
      //saving the value to our shared preference
      await HelperFunctions.saveUserLoggedInStatus(true);
      await HelperFunctions.saveUserEmailSF(email);
      await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
           nextScreenReplace(context, const HomePage());
         }
         else{
           showSnackbar(context, Colors.red, value);
           setState(() {
             _isLoading=false;
           });
         }
       } );
     }
   }
}
