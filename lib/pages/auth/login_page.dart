import 'package:chat_app_firebase/pages/auth/register_page.dart';
import 'package:chat_app_firebase/shared/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widget/widgets.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey=GlobalKey<FormState>();
  String email='';
  String password='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //  backgroundColor: Theme.of(context).primaryColor,
      // ),
      body:
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

   login() {
    if(formKey.currentState!.validate()){}
   }
}
