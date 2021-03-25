import 'package:firebase_chat/models/message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var controller = TextEditingController();
  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildMessageList(),
        _buildMessageBox(),
      ],
    );
  }

  Widget _buildMessageBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {

              },
              child: Icon(
                Icons.image,
                color: Colors.blue[400],
                size: 32,
              ),
            ),
          ),
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
                      borderSide: BorderSide.none/*(
                        color: Colors.blue,
                      )*/,
                    ),
                    contentPadding: EdgeInsets.only(
                        top: 2.0, left: 13.0, right: 13.0, bottom: 2.0),
                    hintText: "Type your message...",
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
                color: Colors.blue[400],
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// for user 1

  Widget _buildMessageList() {

    /*SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });*/

    var chatRef =
        FirebaseDatabase.instance.reference().child('chats').child('1' + '2');

    return Expanded(
      child: StreamBuilder(
        stream: chatRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          } else {
            Event event = snapshot.data;
            Map map = event.snapshot.value as Map;
            List<Message> messageList = [];

            if (map != null) {
              List keyList = map.keys.toList();
              keyList.sort();
              for (var key in keyList) {
                messageList.add(Message.fromSnapshot(map[key.toString()]));
              }
            }

            List<Message> newMessageList = [];
            for(int i = messageList.length-1; i >= 0; i--){
              newMessageList.add(messageList[i]);
            }


            return ListView.builder(
              //controller: scrollController,
              itemCount: newMessageList.length,
              //shrinkWrap: true,
              reverse: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Message message = newMessageList[index];
                return _chatItem(message);
              },
            );
          }
        },
      ),
    );
  }

  void _sendMessage() {
    String text = controller.text;

    if (text.isEmpty) return;

    var chatRef = FirebaseDatabase.instance.reference().child('chats');

    var dateTime = DateTime.now();
    Message message = Message(
      from: '1',
      to: '2',
      text: text,
      date: '${dateTime.day}/${dateTime.month}/${dateTime.year}',
      time: '${dateTime.hour}/${dateTime.minute}/${dateTime.second}',
    );

    var uniqueKey = DateTime.now().millisecondsSinceEpoch.toString();
    chatRef
        .child('1' + '2')
        .child(uniqueKey)
        .set(
          message.toJson(),
        )
        .then((value) {
      controller.text = '';
    });
    chatRef
        .child('2' + '1')
        .child(uniqueKey)
        .set(
          message.toJson(),
        )
        .then((value) {
      controller.text = '';
    });
  }

  /// for user 2

  /*Widget _buildMessageList() {
    var chatRef = FirebaseDatabase.instance
        .reference()
        .child('chats')
        .child('2'+'1');

    return Expanded(
      child: StreamBuilder(
        stream: chatRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          } else {
            Event event = snapshot.data;
            Map map = event.snapshot.value as Map;
            List<Message> messageList = [];

            if(map != null){
              List keyList = map.keys.toList();
              keyList.sort();
              for (var key in keyList) {
                messageList.add(Message.fromSnapshot(map[key.toString()]));
              }
            }

            return ListView.builder(
              controller: scrollController,
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(messageList[index].text),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _sendMessage() {
    String text = controller.text;

    if(text.isEmpty) return;

    var chatRef = FirebaseDatabase.instance.reference().child('chats');

    var dateTime = DateTime.now();
    Message message = Message(
      from: '2',
      to: '1',
      text: text,
      date: '${dateTime.day}/${dateTime.month}/${dateTime.year}',
      time: '${dateTime.hour}/${dateTime.minute}/${dateTime.second}',
    );

    var uniqueKey = DateTime.now().millisecondsSinceEpoch.toString();
    chatRef.child('2'+'1').child(uniqueKey).set(
      message.toJson(),
    ).then((value){
      controller.text = '';
    });
    chatRef.child('1'+'2').child(uniqueKey).set(
      message.toJson(),
    ).then((value){
      controller.text = '';
    });
  }*/

  Widget _chatItem(Message message) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Align(
        alignment:
            (message.from == '1' ? Alignment.topRight : Alignment.topLeft),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:
                (message.from == '1' ? Colors.green[200] : Colors.blue[200]),
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            message.text,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
