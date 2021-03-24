import 'dart:collection';
import 'dart:developer';

import 'package:firebase_chat/models/message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: _buildBody(),
    );
  }

  int currentLen;

  Widget _buildBody() {
    return Column(
      children: [
        _buildMessageList(),
        _buildMessageBox(),
      ],
    );
  }

  Widget _buildMessageList() {
    var chatRef = FirebaseDatabase.instance
        .reference()
        .child('chats')
        .child('1')
        .orderByChild('time');

    return Expanded(
      child: StreamBuilder(
        stream: chatRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          } else {
            Event event = snapshot.data;
            Map map = event.snapshot.value as Map;

            List keyList = map.keys.toList();
            keyList.sort();

            print('key list = $keyList');

            List<String> messageList = [];

            for(var key in keyList){
              messageList.add(map[key.toString()]['message']);
            }

            currentLen = messageList.length;
            return ListView.builder(
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(messageList[index]),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildMessageBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 20.0,
                maxHeight: 60.0,
              ),
              child: new Scrollbar(
                child: new TextField(
                  controller: controller,
                  cursorColor: Colors.red,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
                        top: 2.0, left: 13.0, right: 13.0, bottom: 2.0),
                    hintText: "Type your message",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => _sendMessage(),
              child: Icon(
                Icons.send,
                color: Colors.blue,
                size: 46,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String text = controller.text;

    if(text.isEmpty) return;
    
    var chatRef = FirebaseDatabase.instance.reference().child('chats');

    var dateTime = DateTime.now();
    Message message = Message(
      from: '1',
      to: '2',
      text: text,
      date: '${dateTime.day}/${dateTime.month}/${dateTime.year}',
      time: '${dateTime.hour}/${dateTime.minute}/${dateTime.second}',
    );

    chatRef.child('1').child(DateTime.now().millisecondsSinceEpoch.toString()).set(
      {
        'message': '${currentLen++}',

      },
    );
  }
}
