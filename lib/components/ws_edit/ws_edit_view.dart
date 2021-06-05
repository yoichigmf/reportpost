import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../configs/const_text.dart';
import '../../models/workspace.dart';
import '../../repositories/ws_bloc.dart';

class WsEditView extends StatelessWidget {

  final DateFormat _format = DateFormat("yyyy-MM-dd HH:mm");

  final WsBloc wsBloc;
  final WorkSpace workspace;
  final WorkSpace _newWS = WorkSpace.newWorkSpace();

  WsEditView({Key key, @required this.wsBloc, @required this.workspace}) {
    // Dartでは参照渡しが行われるため、todoをそのまま編集してしまうと、
    // 更新せずにリスト画面に戻ったときも値が更新されてしまうため、
    // 新しいインスタンスを作る
    _newWS.id = workspace.id;
    _newWS.title = workspace.title;
    _newWS.dueDate = workspace.dueDate;
    _newWS.note = workspace.note;

    _newWS.url = workspace.url;
    _newWS.username = workspace.username;
    _newWS.passwd = workspace.passwd;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(ConstText.wsEditView)),
        body: Container(
          padding: const EdgeInsets.all(30.0),
         child: Form(

          child: Column(

            children:[
              const SizedBox(height: 20),
          TextFormField(
          decoration: InputDecoration(labelText: "タイトル"),
           initialValue: _newWS.title,
           onChanged: _setTitle,
         ),
              const SizedBox(height: 20),
           /*  TextFormField(
               decoration: InputDecoration(labelText: "URL"),
               initialValue: _newWS.url,
               onChanged: _setURL,
             ),

            */
             /*
             const SizedBox(height: 20),
             TextFormField(
               decoration: InputDecoration(labelText: "メモ"),
               initialValue: _newWS.note,
               maxLines: 3,
               onChanged: _setNote,
             ),

              */
             ElevatedButton(

               onPressed: () {
                 if (_newWS.id == null) {
                   wsBloc.create(_newWS);
                 } else {
                   wsBloc.update(_newWS);
                 }

                 Navigator.of(context).pop();
               },
               child: Text("決定"),
               style: ElevatedButton.styleFrom(primary: Colors.green,
               ),
             ),


             ]

          ),
        )
        ) );
  }

  Widget _titleTextFormField() =>
      TextFormField(
        decoration: InputDecoration(labelText: "タイトル"),
        initialValue: _newWS.title,
        onChanged: _setTitle,
      );

  void _setTitle(String title) {
    _newWS.title = title;
  }


  Widget _urlTextFormField() =>
      TextFormField(
        decoration: InputDecoration(labelText: "URL"),
        initialValue: _newWS.url,
        onChanged: _setURL,
      );

  void _setURL(String url) {
    _newWS.url = url;
  }


  // ↓ https://pub.dev/packages/datetime_picker_formfield のサンプルから引用
  Widget _dueDateTimeFormField() =>
      DateTimeField(
          format: _format,
          decoration: InputDecoration(labelText: "投稿日"),
          initialValue: _newWS.dueDate ?? DateTime.now(),
          onChanged: _setDueDate,
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

  void _setDueDate(DateTime dt) {
    _newWS.dueDate = dt;
  }

  Widget _noteTextFormField() =>
      TextFormField(
        decoration: InputDecoration(labelText: "メモ"),
        initialValue: _newWS.note,
        maxLines: 3,
        onChanged: _setNote,
      );

  void _setNote(String note) {
    _newWS.note = note;
  }

  Widget _confirmButton(BuildContext context) =>
      ElevatedButton(

        onPressed: () {
          if (_newWS.id == null) {
            wsBloc.create(_newWS);
          } else {
            wsBloc.update(_newWS);
          }

          Navigator.of(context).pop();
        },
        child: Text("決定"),
        style: ElevatedButton.styleFrom(primary: Colors.green,
        ),
      );

}

