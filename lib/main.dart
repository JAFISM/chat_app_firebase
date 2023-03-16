import 'package:chat_app_firebase/helper/helper_function.dart';
import 'package:chat_app_firebase/pages/auth/login_page.dart';
import 'package:chat_app_firebase/pages/home_page.dart';
import 'package:chat_app_firebase/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    // run the initialization for the web
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: Constants.apiKey,
          appId: Constants.appId,
          messagingSenderId: Constants.messagingSenderId,
          projectId: Constants.projectId
      ));
  }
  else{
    // run the initialization for the android , ios
    await Firebase.initializeApp();
  }
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isSgnedIn = false;

  @override
  void initState() {
    getUserLoggedInStatus();
    super.initState();
  }
   getUserLoggedInStatus() async{
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if(value!=null){
        _isSgnedIn =value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff3E54AC),
        scaffoldBackgroundColor: Color(0xffECF2FF),
      ),
      debugShowCheckedModeBanner: false,
      home:_isSgnedIn?  const HomePage() : const LoginPage(),
    );
  }
}