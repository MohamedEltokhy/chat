import 'package:chat/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat').orderBy('createdAt',descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // progress par show in wait
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          // docs that have the return data
          final docs = snapshot.data!.docs;
          final user =  FirebaseAuth.instance.currentUser;

          return ListView.builder(
            reverse: true,
            itemCount: docs.length,
            itemBuilder: (ctx, index) => MessageBubble(
              docs[index]["text"],
              docs[index]["username"],
              docs[index]["userImage"],
              docs[index]["userId"] == user!.uid,
              key: ValueKey(docs[index].id),
            ),
          );
        });
  }
}
