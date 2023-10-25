import 'package:chatting_app/models/user_data.dart';
import 'package:chatting_app/service/firebasse_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<UserData> contacts = [];
  String profile =
      "https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=740&t=st=1698051344~exp=1698051944~hmac=1e23ccdeda340c6412eeb12709256e439948a8e01c6a8413bcc8a907809a3f33";
  final db = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  void getData() async {
    try {
      var usersbase = await db
          .collection("users")
          .where("id", isNotEqualTo: userId)
          .withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData userData, options) => userData.toFirestore(),
          )
          .get();
      for (var doc in usersbase.docs) {
        setState(() {
          contacts.add(doc.data());
        });
        print(doc.data().email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getData();

    super.initState();
    contacts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
        elevation: 10,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          final contant = contacts[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    if (contant.id != null) {
                      FirebaseService().getChat(contant, context);
                    }
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(profile),
                  ),
                  title: Text(
                    "${contant.name}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                  ),
                ),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
