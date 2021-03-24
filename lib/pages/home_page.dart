import 'package:firebase_chat/pages/chat_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _retriveUserFromFirebase(context);
            },
            child: Text('Chat'),
          ),
        ],
      ),
    );
  }

  void _retriveUserFromFirebase(BuildContext context) {
    /*var databaseReef = FirebaseDatabase.instance.reference().child('users');
    databaseReef.child('1').once().then((snapshot) {
      print(snapshot.value['user_id']);
      print(snapshot.value['user_name']);
    });*/

    /*var chatRef = FirebaseDatabase.instance.reference().child('chats');
    chatRef.child('1').push().set(
      {
        'message': 'hello',
      },
    );*/

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(),
      ),
    );
  }
}
