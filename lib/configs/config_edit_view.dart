import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../configs/const_text.dart';
import '../../models/workspace.dart';
import '../../repositories/ws_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigEditView extends StatelessWidget {



  String _postURL;
  String _LineChannel;


  ConfigEditView(BuildContext context, String lChannel, String pURL)  {
    // Dartでは参照渡しが行われるため、todoをそのまま編集してしまうと、
    // 更新せずにリスト画面に戻ったときも値が更新されてしまうため、
     _postURL = pURL;
     _LineChannel = lChannel;

     // _initInstance();

  }

  _initInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //

    var LineChannel  = prefs.getString('line_channel') ?? '1656109293';

    _setLineChannel(LineChannel );
    print(_LineChannel);
    var postURL = prefs.getString('post_url') ?? 'https://uploadrep.herokuapp.com/rep.php';

    _setURL(postURL);
    print(_postURL);

  }

  _save_Instance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('line_channel', _LineChannel );
    prefs.setString('post_url', _postURL );
  }

  @override
  Widget build(BuildContext context)  {
    //_initInstance();
    print(_LineChannel);
    print(_postURL);
    return Scaffold(
        appBar: AppBar(title: Text("設定編集")),
        body: Container(
          padding: const EdgeInsets.all(30.0),
         child: Form(

          child: Column(

            children:[
    const SizedBox(height: 20),
          TextFormField(
               decoration: InputDecoration(labelText: "ライン認証チャンネルID"),
               initialValue: _LineChannel ,
               onChanged: _setLineChannel,
             ),
              const SizedBox(height: 20),
          TextFormField(
          decoration: InputDecoration(labelText: "データポストURL"),
           initialValue: _postURL,
           onChanged: _setURL,
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

                 _save_Instance();
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



  Widget _urlTextFormField() =>
      TextFormField(
        decoration: InputDecoration(labelText: "URL"),
        initialValue: _postURL,
        onChanged: _setURL,
      );

  void _setURL(String url) {
    _postURL = url;
  }
  void _setLineChannel(String channel){
    _LineChannel = channel ;
  }

}

