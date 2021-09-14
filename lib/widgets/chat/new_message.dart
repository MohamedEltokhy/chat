

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({Key? key}) : super(key: key);

  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = TextEditingController();
  String _enteredMessage = "";

  _sendMessage() async{
    FocusScope.of(context).unfocus();
    // send message here
    final user =  FirebaseAuth.instance.currentUser;
    final userDate = await FirebaseFirestore.instance.collection('users').
        doc(user!.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt' : Timestamp.now(),
      'username' : userDate['username'],
      'userId' : user.uid,
      'userImage' : userDate['image_url'],
    });
    _controller.clear();
    setState(() {
      _enteredMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: Colors.white),
              cursorColor: Theme.of(context).primaryColor,
              controller: _controller,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                  hintText: 'Send a message...',
                  hintStyle: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onChanged: (val) {
                setState(() {
                  _enteredMessage = val;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
              disabledColor: Colors.white,
              onPressed: (){
                _enteredMessage.trim().isEmpty ? null : _sendMessage();
              // setState(() {
              //   _enteredMessage.trim().isEmpty ? null : _sendMessage();
              // });
              },
              icon: Icon(Icons.send)),
        ],
      ),
    );
  }
}
