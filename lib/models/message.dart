import 'package:firebase_database/firebase_database.dart';

class Message {
  String text;
  String from;
  String to;
  String date;
  String time;

  Message({this.text, this.from, this.to, this.date, this.time});

  Message.fromSnapshot(DataSnapshot snapshot) {
    var json = snapshot.value;
    text = json['text'];
    from = json['from'];
    to = json['to'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['from'] = this.from;
    data['to'] = this.to;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}