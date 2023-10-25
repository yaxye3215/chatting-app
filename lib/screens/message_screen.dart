import 'package:chatting_app/screens/widget/message_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/msg.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String docid = '';
  List<QueryDocumentSnapshot<Msg>> messages = [];
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  var listener;
  // final RefreshController refreshController =
  //     RefreshController(initialRefresh: true);
  asyncLoadAllData() async {
    var fromMessage = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: user!.uid)
        .get();

    var toMessages = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("to_uid", isEqualTo: user!.uid)
        .get();

    if (fromMessage.docs.isNotEmpty) {
      setState(() {
        messages.addAll(fromMessage.docs);
      });

      print(
        "dhririka lsitiga waaa: $messages",
      );

      // print(doc.data().email);
    }
    if (toMessages.docs.isNotEmpty) {
      setState(() {
        messages.addAll(toMessages.docs);
      });

      print(
        "dhririka lsitiga waaa: $messages",
      );
    }
  }

  // void onRefresh() {
  //   asyncLoadAllData().then((_) {
  //     refreshController.refreshCompleted(resetFooterState: true);
  //   }).catchError((_) {
  //     refreshController.refreshFailed();
  //   });
  // }

  // void onLoading() {
  //   asyncLoadAllData().then((_) {
  //     refreshController.loadComplete();
  //   }).catchError((_) {
  //     refreshController.loadFailed();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    asyncLoadAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('message'),
        elevation: 10,
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            var item = messages[index];
            return MessageItem(
              item: item,
            );
          },
        ),
      ),
    );
  }
}
