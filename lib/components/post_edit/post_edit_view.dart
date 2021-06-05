import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import  'package:provider/provider.dart';
import '../../configs/const_text.dart';
import '../../models/post.dart';
import '../../repositories/ws_bloc.dart';

class PostEditView extends StatelessWidget {
  //final _bloc = Provider.of<WsBloc>(context, listen: false);
  final DateFormat _format = DateFormat("yyyy-MM-dd HH:mm");

  WsBloc bloc ;
  final Postd post;
  final Postd _newPost = Postd.newPost();

  String  wid;


  PostEditView({Key key, @required this.bloc, @required this.post}){
    // Dartでは参照渡しが行われるため、todoをそのまま編集してしまうと、
    // 更新せずにリスト画面に戻ったときも値が更新されてしまうため、
    // 新しいインスタンスを作る
    _newPost.id = post.id;

    _newPost.wid = post.wid;
    _newPost.postDate = post.postDate;
    _newPost.note = post.note;
    _newPost.image = post.image;
    _newPost.kind = post.kind;
    _newPost.pflag = post.pflag;
    _newPost.lat = post.lat;
    _newPost.lon = post.lon;


  }

  @override
  Widget build(BuildContext context) {

    bloc = Provider.of<WsBloc>(context);
    return Scaffold(
        appBar: AppBar(title: Text(ConstText.PostEditView)),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              _noteTextFormField(),
              //_postDateTimeFormField(),

              //_imgFormField(),
              _confirmButton(context)
            ],
          ),
        )
    );
  }



  // ↓ https://pub.dev/packages/datetime_picker_formfield のサンプルから引用
  Widget _postDateTimeFormField() => DateTimeField(
      format: _format,
      decoration: InputDecoration(labelText: "投稿日"),
      initialValue: _newPost.postDate ?? DateTime.now(),
      onChanged: _setPostDate,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(
                currentValue ?? DateTime.now()),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      }
  );

  void _setPostDate(DateTime dt) {
    _newPost.postDate = dt;
  }

  Widget _noteTextFormField() => TextFormField(
    decoration: InputDecoration(labelText: "テキスト"),
    initialValue: _newPost.note,
    maxLines: 3,
    onChanged: _setNote,
  );

  void _setNote(String note) {
    _newPost.note = note;
  }


  Widget _imgFormField() => TextFormField(
    decoration: InputDecoration(labelText: "テキスト"),
    initialValue: _newPost.image,
    maxLines: 3,
    onChanged: _setImage,
  );

  void _setImage(String image) {
    _newPost.image = image;
  }

  Widget _confirmButton(BuildContext context) => RaisedButton.icon(
    icon: Icon(
      Icons.tag_faces,
      color: Colors.white,
    ),
    label: Text("決定"),
    onPressed: () {
      print(_newPost.id);

      if (_newPost.id == null) {
        bloc.createPost(_newPost);
      } else {
        bloc.updatePost(_newPost);
      }

      Navigator.of(context).pop();
    },
    shape: StadiumBorder(),
    color: Colors.green,
    textColor: Colors.white,
  );
}