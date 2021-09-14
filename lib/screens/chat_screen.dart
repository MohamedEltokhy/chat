import 'package:chat/widgets/chat/messages.dart';
import 'package:chat/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState(){
    super.initState();
    initializedNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.logout,color: Colors.white,),
                    SizedBox(width: 8,),
                    Text("Logout",style: TextStyle(color: Colors.white),),
                  ],
                ),
                value: 'logout',
              )
            ],
            onChanged: (itemIdentifier){
              if(itemIdentifier =='logout'){
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessages(),
          ],
        ),
      ),
    );
  }

  initializedNotification(){
    FirebaseMessaging.instance.getInitialMessage();
    //for ground
   FirebaseMessaging.onMessage.listen((message) {
     if(message.notification !=null){
       print(message.notification!.body);
       print(message.notification!.title);
      }
   });
   FirebaseMessaging.onMessageOpenedApp.listen((message) {

   });
  }
}
