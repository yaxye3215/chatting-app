import 'package:chatting_app/screens/contacts_screen.dart';
import 'package:chatting_app/screens/message_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  List screens = [
    const MessageScreen(),
    const ContactsScreen(),
    const Center(
      child: Text("setting"),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: index == 0
          ? screens[0]
          : index == 1
              ? screens[1]
              : screens[2],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        backgroundColor: Colors.white,
        iconSize: 35,
        fixedColor: Colors.black12,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'contacts'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}
