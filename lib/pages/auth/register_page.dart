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
  final formKey=GlobalKey<FormState>();
  String email='';
  String password='';
  String fullName='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //  backgroundColor: Theme.of(context).primaryColor,
      // ),
      body:
      SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 80),
            child: Form(
              key:formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Rho-Voiceless!",style: TextStyle(color:Constants.c1,fontSize: 40,fontWeight: FontWeight.bold),),
                  Text("Create your account now to chat and explore ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  Image.asset("assets/register_img.png",),
                  TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: "Full Name",
                          prefixIcon: Icon(Icons.person,color: Theme.of(context).primaryColor,)
                      ),
                      onChanged: (val){
                        setState(() {
                          fullName=val;
                        });
                      },
                      validator: (val){
                        if(val!.isNotEmpty){
                          return null;
                        }
                        else{
                          return "Name Cannot be empty";
                        }
                      },
                  ),
                  SizedBox(height: 15,),
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
                      register();
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
      ),
    );
  }

   register() {

   }
}
