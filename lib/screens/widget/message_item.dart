// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chatting_app/models/msg.dart';
import 'package:chatting_app/screens/chat_screen.dart';

import '../../constants/duktime.dart';

// ignore: must_be_immutable
class MessageItem extends StatelessWidget {
  MessageItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  QueryDocumentSnapshot<Msg> item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      docId: item.id,
                      toUid: item.data().to_uid!,
                      toName: item.data().to_name!,
                      toAvator: item.data().to_avatar!,
                    ),
                  ));
            },
            leading: const CircleAvatar(
              radius: 25,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.data().from_name!,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.data().last_msg!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Divider()
              ],
            ),
            trailing: Text(
              duTimeLineFormat(
                (item.data().last_time as Timestamp).toDate(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
