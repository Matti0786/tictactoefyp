import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  void checkUserExist() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    DocumentSnapshot ds = await db.collection('users').doc(uid).get();
    if (!ds.exists) {
      db
          .collection("users")
          .doc(uid)
          .set({'win': 0, 'loss': 0, "tie": 0, "level": 0});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserExist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Menu"),
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('signin', false);
              prefs.setString('uid', "0");
              Navigator.popAndPushNamed(context, '/signin');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Single Player Button
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/singlePlayerTicTacToe');
            },
            child: Text("Sinle Player"),
          ),
          SizedBox(height: 10),

          // Multi Player Button
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/multiPlayerTicTacToe');
            },
            child: Text("Multi Player"),
          ),
          SizedBox(height: 10),
        ]),
      ),
    );
  }
}
