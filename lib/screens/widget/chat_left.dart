import 'package:chatting_app/models/msg_contant.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatLeft extends StatelessWidget {
  ChatLeft({super.key, required this.msgItem});
  Msgcontent msgItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
          margin: const EdgeInsets.only(left: 4, right: 8, bottom: 10, top: 5),
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: msgItem.type == "text"
              ? Text(
                  "${msgItem.content}",
                  style: const TextStyle(fontSize: 16),
                )
              : GestureDetector(
                  onTap: () {},
                  child: Image.network("${msgItem.content}"),
                ),
        ),
      ],
    );
  }
}
