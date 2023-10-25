import 'package:chatting_app/models/user_data.dart';

import 'package:chatting_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

import '../models/msg.dart';

class FirebaseService {
  final db = FirebaseFirestore.instance;

  final user = FirebaseAuth.instance.currentUser;
  // sign up with google
  Future<void> signUpGoole() async {
    // ...
    // The `GoogleAuthProvider` can also be used here.
    try {
      final GoogleSignInAccount? user = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await user?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );


          await FirebaseAuth.instance.signInWithCredential(credential);
      print("userID: ${user!.id}");

      var userbase = await db
          .collection("users")
          .withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData userData, options) => userData.toFirestore(),
          )
          .where("id", isEqualTo: user.id)
          .get();
      if (userbase.docs.isEmpty) {
        final data = UserData(
          id: user.id,
          name: user.displayName,
          email: user.photoUrl,
          photoUrl: user.photoUrl,
          location: "",
          fcmToken: "",
          addTime: Timestamp.now(),
        );
        await db
            .collection("users")
            .withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userData, options) =>
                  userData.toFirestore(),
            )
            .add(data);
      }
    } catch (e) {
      print(e);
    }
  }

  // get chat
  Future<void> getChat(UserData toUserdata, BuildContext context) async {
    try {
      var fromMessage = await db
          .collection("message")
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg.toFirestore())
          .where("from_uid", isEqualTo: user!.uid)
          .where("to_uid", isEqualTo: toUserdata.id)
          .get();
      var toMessage = await db
          .collection("message")
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg.toFirestore())
          .where("from_uid", isEqualTo: toUserdata.id)
          .where("to_uid", isEqualTo: user!.uid)
          .get();

      if (fromMessage.docs.isEmpty && toMessage.docs.isEmpty) {
        final userdata = await db
            .collection("users")
            .where("id", isEqualTo: user!.uid)
            .withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userData, options) =>
                  userData.toFirestore(),
            )
            .get();
        var msgData = Msg(
          from_uid: user!.uid,
          to_uid: toUserdata.id,
          from_name: userdata.docs.first.data().name,
          to_name: toUserdata.name,
          from_avatar: userdata.docs.first.data().photoUrl,
          to_avatar: toUserdata.photoUrl,
          last_msg: "",
          last_time: Timestamp.now(),
          msg_num: 0,
        );
        db
            .collection("message")
            .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg.toFirestore(),
            )
            .add(msgData)
            .then((value) => {
                  "doc_id": value.id,
                  "to_uid": toUserdata.id ?? "",
                  "to_name": toUserdata.name ?? "",
                  "to_avatar": toUserdata.photoUrl ?? ""
                });
      } else {
        if (fromMessage.docs.isNotEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  docId: fromMessage.docs.first.id,
                  toUid: toUserdata.id ?? '',
                  toName: toUserdata.name ?? '',
                  toAvator: toUserdata.photoUrl ?? '',
                ),
              ));
          // Get.toNamed("/chat", parameters: {
          //   "doc_id": fromMessage.docs.first.id,
          //   "to_uid": to_userdata.id ?? "",
          //   "to_name": to_userdata.name ?? "",
          //   "to_avatar": to_userdata.photourl ?? ""
          // });
        }
        if (toMessage.docs.isNotEmpty) {
          // Get.toNamed("/chat", parameters: {
          //     "doc_id": toMessage.docs.first.id,
          //     "to_uid": to_userdata.id ?? "",
          //     "to_name": to_userdata.name ?? "",
          //     "to_avatar": to_userdata.photourl ?? ""
          //   });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  docId: toMessage.docs.first.id,
                  toUid: toUserdata.id ?? '',
                  toName: toUserdata.name ?? '',
                  toAvator: toUserdata.photoUrl ?? '',
                ),
              ));
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
