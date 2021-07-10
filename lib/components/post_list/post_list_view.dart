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
import 'dart:async';

class PostListView extends StatefulWidget {
  String wid;
  WorkSpace wksp;
  String title;




  //final Postd post;
  final Postd _newPost = Postd.newPost();


  var _image;
  final picker = ImagePicker();

  // final WorkSpace _newWS = WorkSpace.newWorkSpace();

  PostListView({Key key, @required this.wksp}) {
    this.wid = wksp.id;
    this.wksp = wksp;
    this.title = wksp.title;
  }

  @override
  _PostListViewState createState() => _PostListViewState();


}
class _PostListViewState extends State<PostListView > {

  ScrollController _scrollController = new ScrollController();
  WsBloc _bloc;
  final Postd _newPost = Postd.newPost();
  var _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.of<WsBloc>(context, listen: false);
    final messageTextInputCtl = new TextEditingController();
    final postList = _bloc.reportPostBloc();

    final titlestring = _bloc.title;


    var lcount = 0;
    final _formKey = GlobalKey<FormState>();

    if (postList != null) {
      lcount = postList.length;
    }
    return Scaffold(
      appBar: AppBar(title: Text(titlestring)),
      /*
      persistentFooterButtons: <Widget>[

        IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () {

              _moveToAddPhotoView(context, _bloc);
            }

        ),
        IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () {
            // print("add pic ");

              _moveToAddpicView(context, _bloc);
            }

        ),
        IconButton(
            icon: Icon(Icons.movie_creation),
            onPressed: () {

             // _moveToAddPhotoView(context, _bloc);
            }

        ),

        IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: () {

              // _moveToAddPhotoView(context, _bloc);
            }

        ),
        IconButton(
            icon: Icon(Icons.record_voice_over),
            onPressed: () {

              // _moveToAddPhotoView(context, _bloc);
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

       */
      body: Stack(
        alignment: Alignment.bottomCenter,
        children : <Widget>
      [
      GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
       child: StreamBuilder<List<Postd>>(

        stream: _bloc.postStream,
        builder: (BuildContext context, AsyncSnapshot<List<Postd>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 10.0, right: 5.0, bottom: 50.0, left: 5.0),
              itemBuilder: (BuildContext context, int index) {
                Postd ws = snapshot.data[index];

                return Slidable(


                  actionExtentRatio: 0.2,
                  actionPane: SlidableScrollActionPane(),
                  actions: [

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

                  ),

                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Container(
                  color: Colors.green[100],
                  child: Column(
                      children: <Widget>[
                        new Form(
                            key: _formKey,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  new Flexible(
                                      child: new TextFormField(
                                        controller: messageTextInputCtl,
                                        keyboardType: TextInputType.multiline,

                                        maxLines: 10,
                                        minLines: 1,
                                        decoration: const InputDecoration(
                                          hintText: 'メッセージを入力してください',
                                        ),
                                        onTap: (){
                                          // タイマーを入れてキーボード分スクロールする様に
                                          Timer(
                                            Duration(milliseconds: 200),
                                            _scrollToBottom,
                                          );
                                        },
                                      )),
                                  Material(
                                    color: Colors.indigoAccent,
                                    child: Center(
                                      child: Ink(
                                        decoration: const ShapeDecoration(
                                          color: Colors.indigo,
                                          shape: CircleBorder(),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.send),
                                          color: Colors.white,
                                          onPressed: () {
                                            _addMessage(messageTextInputCtl.text);
                                            FocusScope.of(context).unfocus();
                                            messageTextInputCtl.clear();
                                            Timer(
                                              Duration(milliseconds: 200),
                                              _scrollToBottom,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                            )
                        ),
                      ]
                  )
              ),
            ],
          )

      ]
      )
    );
  }
  void _scrollToBottom(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + MediaQuery.of(context).viewInsets.bottom,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }
  _getItemListTile( Postd ws ){

   switch(ws.kind ){
     case 1:   // image
       return( ListTile(
         onTap: () {

         },
         leading: Image.file(File(ws.image)) ,
        // title: Text(ws.note,
         //    style: TextStyle(color: Colors.black87)),
         subtitle: Text(_timeformated(ws.postDate),
             style: TextStyle(color: Colors.black87)),
       )
       );
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

  _addMessage(String message){

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



  _moveToAddPhotoView(BuildContext context, WsBloc _bloc){
    _getImageFromPhoto();

  }
  _moveToAddpicView(BuildContext context, WsBloc _bloc){
    _getImageFromGallery();


  }

  Future _getImageFromPhoto() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);


    if ( pickedFile != null) {
      print(pickedFile.path);
      _createNewPost(  pickedFile  );
      _image = File(pickedFile.path);

    }
  }
  Future _getImageFromGallery() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);


      if ( pickedFile != null) {
        print(pickedFile.path);
        _createNewPost(  pickedFile  );
        _image = File(pickedFile.path);

      }

  }

  _createNewPost( PickedFile pfile ){
    _newPost.image = pfile.path;
    _newPost.note = pfile.path;
    _newPost.kind = 1;
    _bloc.createPost(_newPost);
    _image = File(pfile.path);
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