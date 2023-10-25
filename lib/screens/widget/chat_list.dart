// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatting_app/screens/widget/chat_left.dart';
import 'package:chatting_app/screens/widget/chat_right.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chatting_app/models/msg_contant.dart';

// ignore: must_be_immutable
class ChatList extends StatelessWidget {
  ChatList({
    Key? key,
    required this.msgList,
    required this.scrollController,
  }) : super(key: key);

  final List<Msgcontent> msgList;
  final user = FirebaseAuth.instance.currentUser;
  ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      reverse: true,
      semanticChildCount: msgList.length,
      itemCount: msgList.length,
      itemBuilder: (BuildContext context, int index) {
        final msg = msgList[index];
        if (user!.uid == msg.uid) {
          return ChatRight(msgItem: msg);
        }
        return ChatLeft(msgItem: msg);
      },
    );
  }
}
