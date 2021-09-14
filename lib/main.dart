import 'package:chat/screens/auth_screen.dart';
import 'package:chat/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/chat_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        canvasColor: Colors.black,
        primarySwatch: Colors.deepOrange,
        backgroundColor: Colors.orange,
        accentColor: Colors.amber,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.deepOrange,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        )
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx ,snapShot){
          if(snapShot.connectionState == ConnectionState.waiting){
            return SplashScreen();
          }

          if(snapShot.hasData){
            return ChatScreen();
          }else{
            return AuthScreen();
          }
        },
      ),
    );
  }
}
