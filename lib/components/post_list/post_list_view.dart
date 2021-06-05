import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/post_edit/post_edit_view.dart';
import '../../configs/const_text.dart';
import '../../models/post.dart';
import '../../models/workspace.dart';

import '../../repositories/ws_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';


class PostListView extends StatelessWidget {
  String wid;
  WorkSpace wksp;
  String title;

  WsBloc  _bloc;

  var _image;
  final picker = ImagePicker();

  // final WorkSpace _newWS = WorkSpace.newWorkSpace();

  PostListView({Key key, @required this.wksp}) {
    this.wid = wksp.id;
    this.wksp = wksp;
    this.title = wksp.title;
  }


  @override
  Widget build(BuildContext context) {
    _bloc = Provider.of<WsBloc>(context, listen: false);

    final postList = _bloc.reportPostBloc();

    final titlestring = _bloc.title;

    var lcount = 0;

    if (postList != null) {
      lcount = postList.length;
    }
    return Scaffold(
      appBar: AppBar(title: Text(titlestring)),
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
            icon: Icon(Icons.add_a_photo),
            onPressed: () {}

        ),
        IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () {
             print("add pic ");

              _moveToAddpicView(context, _bloc);
            }

        ),
        IconButton(
            icon: Icon(Icons.add_comment),
            onPressed: () {
              _moveToCreateView(context, _bloc);
            }
        ),

        //  TextField(decoration:InputDecoration(hintText:'テキスト投稿')),
      ],
      body: StreamBuilder<List<Postd>>(
        stream: _bloc.postStream,
        builder: (BuildContext context, AsyncSnapshot<List<Postd>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Postd ws = snapshot.data[index];

                return Slidable(


                  actionExtentRatio: 0.2,
                  actionPane: SlidableScrollActionPane(),
                  actions: [
/*
                    IconSlideAction(
                      caption: 'アップロード',
                      color: Colors.indigo,
                      icon: Icons.share,
                      onTap: () {},
                    ),
                    IconSlideAction(
                      caption: '投稿',
                      color: Colors.lightBlue,
                      icon: Icons.input,
                      onTap: () {
                        /*_bloc.wid = ws.id;
    _bloc.title = ws.title;
    _moveToPostView( context, ws);

     */
                      },
                    ),

 */
                  ],
                  secondaryActions: [
                    IconSlideAction(
                      caption: '編集',
                      color: Colors.black45,
                      icon: Icons.edit_attributes,
                      onTap: () {
                        //  _moveToEditView(context, _bloc, ws);
                      },
                    ),
                    IconSlideAction(
                      caption: '削除',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        _bloc.deletePost(ws.id);
                      },
                    ),
                  ],
                  child: Container(
                    decoration: BoxDecoration(color: Colors.deepOrange[50]),
                    child:  _getItemListTile( ws ),
                    /*ListTile(
                      onTap: () {
                        /* _bloc.wid = ws.id;
    _bloc.title = ws.title;

    _moveToPostView( context, ws);

    */
                        // _moveToEditView(context, _bloc, ws);
                      },
                      leading: Icon(
                        Icons.account_circle,
                        color: Colors.lightBlue,
                      ),
                      title: Text(ws.note,
                          style: TextStyle(color: Colors.black87)),
                      subtitle: Text(_timeformated(ws.postDate),
                          style: TextStyle(color: Colors.black87)),
                    ),

                     */
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

  _getItemListTile( Postd ws ){

   switch(ws.kind ){
     case 1:   // image
       break;
     case 0:   //  text

     default:
         return( ListTile(
          onTap: () {

          },
          leading: Icon(
         Icons.account_circle,
         color: Colors.lightBlue,
         ),
          title: Text(ws.note,
           style: TextStyle(color: Colors.black87)),
           subtitle: Text(_timeformated(ws.postDate),
           style: TextStyle(color: Colors.black87)),
     )
     );
   }



  }

  _timeformated(DateTime tm) {
    initializeDateFormatting("ja_JP");
    var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
    var formatted = formatter.format(tm); // DateからString
    return formatted;
  }





  _moveToEditView(BuildContext context, WsBloc bloc, Postd post) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostEditView(bloc: bloc, post: post))
      );

  _moveToCreateView(BuildContext context, WsBloc _bloc) =>
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              PostEditView(bloc: _bloc, post: Postd.newPost()))
      );


  _moveToAddpicView(BuildContext context, WsBloc _bloc){
    getImageFromGallery();


  }

  Future getImageFromGallery() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);


      if ( pickedFile != null) {
        print(pickedFile.path);
        _image = File(pickedFile.path);

      }

  }

/*
  _backgroundOfDismissible() => Container(
      alignment: Alignment.centerLeft,
      color: Colors.green,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Icon(Icons.done, color: Colors.white),
      )
  );

  _secondaryBackgroundOfDismissible() => Container(
      alignment: Alignment.centerRight,
      color: Colors.green,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Icon(Icons.done, color: Colors.white),
      )
  );

   */

}



class SubListItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget leading;
  final Color tileColor;

  SubListItem({this.title, this.subTitle, this.leading, this.tileColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      leading: leading,
      onTap: () => {},
      onLongPress: () => {},
      trailing: Icon(Icons.more_vert),
    );
  }
}