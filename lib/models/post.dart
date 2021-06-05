import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import  '../configs/const_text.dart';

class Postd {
  String id;
  String wid;
  DateTime postDate;
  String note;
  String image;
  int kind;
  int pflag;
  double lat;
  double lon;


  Postd({this.id, @required this.wid,  @required this.note,@required this.lat,@required this.lon,@required this.postDate, @required this.image, @required this.kind, @required this.pflag});
  Postd.newPost() {
    wid = "";
    postDate = DateTime.now();
    note = "";
    image = "";
    pflag = 0;
    kind = ConstType.note;
    lat = 0.0;
    lon = 0.0;



  }

  assignUUID() {
    id = Uuid().v4();
  }

  //
  factory Postd.fromMap(Map<String, dynamic> json) => Postd(
      id: json["id"],
      wid: json["wid"],
      // DateTime型は文字列で保存されているため、DateTime型に変換し直す
      postDate: DateTime.parse(json["postDate"]).toLocal(),
      note: json["note"],
      image: json["image"],
      pflag: json["pflag"],
      kind: json["kind"],
      lat: json["lat"].toDouble(),
      lon: json["lon"].toDouble()

  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "wid": wid,
    // sqliteではDate型は直接保存できないため、文字列形式で保存する
    "postDate": postDate.toUtc().toIso8601String(),
    "note": note,
    "image": image,
     "pflag": pflag,
     "kind": kind,
     "lat": lat,
     "lon":lon
  };
}
