import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/ws_edit/ws_edit_view.dart';

import '../../components/post_list/post_list_view.dart';
import '../../components/post_list/post_upload_view.dart';
import '../../configs/const_text.dart';
import '../../configs/config_edit_view.dart';
import '../../models/workspace.dart';
import '../../repositories/ws_bloc.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WsListView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<WsBloc>(context, listen: false);
   // final _pbloc = Provider.of<PostBloc>(context, listen:false);


    return Scaffold(
      appBar: AppBar(title: Text(ConstText.wsListView)),
      persistentFooterButtons: <Widget>[
      /*  TextButton(
          child: Text(
            'Button 1',
          ),
          onPressed: () {

          },
        ),
        */

        IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {_moveToSettingView(context);}

        ),
        IconButton(
            icon: Icon(Icons.add_comment),
            onPressed: (){_moveToCreateView(context, _bloc);}
        ),

        //  TextField(decoration:InputDecoration(hintText:'テキスト投稿')),
      ],
      body: StreamBuilder<List<WorkSpace>>(
        stream: _bloc.wsStream,
        builder: (BuildContext context, AsyncSnapshot<List<WorkSpace>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {

                WorkSpace ws = snapshot.data[index];

                return Slidable(


                  actionExtentRatio: 0.2,
                  actionPane: SlidableScrollActionPane(),
                  actions: [

                    IconSlideAction(
                      caption: 'アップロード',
                      color: Colors.indigo,
                      icon: Icons.share,
                      onTap: () {
                        _bloc.wid = ws.id;
                        _bloc.title = ws.title;
                        _movetoUploadView( context, ws );

                      },
                    ),
                    IconSlideAction(
                      caption: '投稿',
                      color: Colors.lightBlue,
                      icon: Icons.input,
                      onTap: () {
                        _bloc.wid = ws.id;
                        _bloc.title = ws.title;
                        _moveToPostView( context, ws);
                      },
                    ),
                  ],
                  secondaryActions: [
                    IconSlideAction(
                      caption: '編集',
                      color: Colors.black45,
                      icon: Icons.edit_attributes,
                      onTap: () {
                        _moveToEditView(context, _bloc, ws);
                      },
                    ),
                    IconSlideAction(
                      caption: '削除',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        _bloc.delete(ws.id);
                      },
                    ),
                  ],
                  child: Container(
                    decoration: BoxDecoration(color: Colors.deepOrange[50]),
                    child: ListTile(
                      onTap: (){
                        _bloc.wid = ws.id;
                        _bloc.title = ws.title;

                        _moveToPostView( context, ws);
                       // _moveToEditView(context, _bloc, ws);
                      },
                      leading: Icon(
                        Icons.account_circle,
                        color: Colors.lightBlue,
                      ),
                      title: Text(ws.title,
                          style: TextStyle(color: Colors.black87)),
                      subtitle: Text(_timeformated(ws.dueDate),style: TextStyle(color: Colors.black87) ),
                    ),
                  ),



                );



              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
   /*   floatingActionButton: FloatingActionButton(
        onPressed: (){ _moveToCreateView(context, _bloc); },
        child: Icon(Icons.add, size: 40),
      ),

    */
    );
  }

  _timeformated( DateTime tm){
    initializeDateFormatting("ja_JP");
    var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
    var formatted = formatter.format(tm); // DateからString
    return formatted;
  }
  _moveToSettingView(BuildContext context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //

    var LineChannel  = prefs.getString('line_channel') ?? '1656109293';


    var postURL = prefs.getString('post_url') ?? 'https://uploadrep.herokuapp.com/rep.php';



    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConfigEditView(context,  LineChannel, postURL))
    );


  }
  _moveToPostView(BuildContext context, WorkSpace wk) {

//print(wk.id);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>  PostListView(wksp: wk))
    );

  }

  _movetoUploadView( BuildContext context, WorkSpace wk ){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>  PostUploadView(wksp: wk))
    );
  }

    _moveToEditView(BuildContext context, WsBloc bloc, WorkSpace todo) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WsEditView(wsBloc: bloc, workspace: todo))
    );

    _moveToCreateView(BuildContext context, WsBloc _bloc) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WsEditView(wsBloc: _bloc, workspace: WorkSpace.newWorkSpace()))
    );
  }




