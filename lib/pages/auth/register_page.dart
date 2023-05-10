import 'package:chat_app_firebase/helper/helper_function.dart';
import 'package:chat_app_firebase/pages/auth/login_page.dart';
import 'package:chat_app_firebase/pages/home_page.dart';
import 'package:chat_app_firebase/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../shared/constants.dart';
import '../../widget/widgets.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullName = '';
  AuthService authService=AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //  backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme
          .of(context)
          .primaryColor,),) :
      SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Rho-Voiceless!", style: TextStyle(color: Constants.c1,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),),
                Text("Create your account now to chat and explore ",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                Image.asset("assets/register_img.png",),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person, color: Theme
                          .of(context)
                          .primaryColor,)
                  ),
                  onChanged: (val) {
                    setState(() {
                      fullName = val;
                    });
                  },
                  validator: (val) {
                    if (val!.isNotEmpty) {
                      return null;
                    }
                    else {
                      return "Name Cannot be empty";
                    }
                  },
                ),
               // SizedBox(height: 15,),
                TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: "E-Mail",
                        prefixIcon: Icon(Icons.email, color: Theme
                            .of(context)
                            .primaryColor,)
                    ),
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    validator: (val) {
                      return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val!)
                          ? null
                          : "Please enter a valid email";
                    }
                ),
                // SizedBox(
                //   height: 15,
                // ),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock, color: Theme
                          .of(context)
                          .primaryColor,)
                  ),
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 6) {
                      return " Password must be at least 6 character";
                    }
                    else {
                      return null;
                    }
                  },
                ),
                //SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(onPressed: () {
                    register();
                  }, child: Text("Register", style: TextStyle(fontSize: 16),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme
                            .of(context)
                            .primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                  ),
                ),
                //SizedBox(height: 15),
                Text.rich(
                  TextSpan(
                      text:
                      "Already have an account ?",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Login here",
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .primaryColor
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                nextScreen(context, LoginPage());
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

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
   await authService
       .registerUserWithEmailandPassword(fullName, email, password)
       .then((value) async{
       if(value == true) {
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserEmailSF(email);
        await HelperFunctions.saveUserNameSF(fullName);
        nextScreenReplace(context, HomePage());
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
