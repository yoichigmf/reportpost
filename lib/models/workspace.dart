import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class WorkSpace {
  String id;
  String title;
  DateTime dueDate;
  String note;
  String url;
  String username;
  String passwd;

  WorkSpace({this.id, @required this.title, @required this.dueDate, @required this.note, @required this.url, @required this.username, @required this.passwd});
  WorkSpace.newWorkSpace() {
    title = "";
    dueDate = DateTime.now();
    note = "";
    url ="";
    username = "";
    passwd = "";
  }

  assignUUID() {
    id = Uuid().v4();
  }

  // staticでも同じ？
  factory WorkSpace.fromMap(Map<String, dynamic> json) => WorkSpace(
      id: json["id"],
      title: json["title"],
      // DateTime型は文字列で保存されているため、DateTime型に変換し直す
      dueDate: DateTime.parse(json["dueDate"]).toLocal(),
      note: json["note"],
      url: json["url"],
      username: json["username"],
      passwd: json["passwd"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    // sqliteではDate型は直接保存できないため、文字列形式で保存する
    "dueDate": dueDate.toUtc().toIso8601String(),
    "note": note,
    "url": url,
     "username": username,
     "passwd": passwd
  };
}
