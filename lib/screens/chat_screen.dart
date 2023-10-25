// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:chatting_app/models/msg_contant.dart';
import 'package:chatting_app/screens/widget/chat_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.docId,
    required this.toUid,
    required this.toName,
    required this.toAvator,
  }) : super(key: key);

  final String docId;
  final String toUid;
  final String toName;
  final String toAvator;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  List<Msgcontent> msgList = [];
  dynamic listener;

  void sendMessage() async {
    String sendContent = textController.text;

    final content = Msgcontent(
        uid: user!.uid,
        content: sendContent,
        type: "text",
        addtime: Timestamp.now()); // Msgcontent
    await db
        .collection("message")
        .doc(widget.docId)
        .collection("msgList")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgcontent, options) =>
                msgcontent.toFirebase())
        .add(content)
        .then((DocumentReference doc) {
      print("Document snapshot added with id, ${doc.id}");
      textController.clear();
      focusNode.unfocus();
    });
    await db.collection("message").doc(widget.docId).update({
      "last_msg": sendContent,
      "last_time": Timestamp.now(),
    });
  }

  void getMessage() {
    var messages = db
        .collection("message")
        .doc(widget.docId)
        .collection("msgList")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgcontent, options) =>
                msgcontent.toFirebase())
        .orderBy("addtime", descending: false);
    msgList.clear();
    listener = messages.snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null) {
              setState(() {
                msgList.insert(0, change.doc.data()!);
              });
            }
            break;
          case DocumentChangeType.modified:
            break;
          case DocumentChangeType.removed:
            break;
        }
      }
    }, onError: (error) {
      print("listener failed:$error");
    });
  }

  File? selectImage;

  void takePicture() async {
    final takeImage = ImagePicker();

    final imagePicture = await takeImage.pickImage(
      source: ImageSource.gallery,
    );
    if (imagePicture == null) {
      print("waxba ma hilen");
      return;
    }
    setState(() {
      selectImage = File(imagePicture.path);
    });
    print(selectImage);
    // widget.selectPicture(selectImage!);
  }

  @override
  void initState() {
    super.initState();
    getMessage();
  }

  @override
  void dispose() {
    listener.cancel();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(widget.toName),
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatList(
            msgList: msgList,
            scrollController: scrollController,
          )),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 5, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    color: Colors.white,
                    child: TextField(
                      focusNode: focusNode,
                      autofocus: false,
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: "send message",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        suffixIcon: GestureDetector(
                          onTap: takePicture,
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blueGrey,
                            child: Icon(Icons.image),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
