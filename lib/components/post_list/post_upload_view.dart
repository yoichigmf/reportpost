import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/post_edit/post_edit_view.dart';
import '../../configs/const_text.dart';
import '../../models/post.dart';
import '../../models/workspace.dart';
import 'package:flutter/services.dart';
import '../../repositories/ws_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_slidable/flutter_slidable.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_line_sdk/flutter_line_sdk.dart';


class PostUploadView extends StatelessWidget {
  String wid;
  WorkSpace wksp;
  String title;

  WsBloc  _bloc;

  //final Postd post;
  final Postd _newPost = Postd.newPost();

  var _image;
  final picker = ImagePicker();

  // final WorkSpace _newWS = WorkSpace.newWorkSpace();

  PostUploadView({Key key, @required this.wksp}) {
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
      appBar: AppBar(title: Text(titlestring+ " アップロード")),
      persistentFooterButtons: <Widget>[


        IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: () {

              _uploadWorkSpace(context, _bloc);


            }

        ),
        IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
            // print("add pic ");

              _moveToAddpicView(context, _bloc);
            }

        ),
        IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {

             // _moveToAddPhotoView(context, _bloc);
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


  _uploadWorkSpace(BuildContext context, WsBloc bloc) {

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("アップロード確認"),
          content: Text("ワークスペースの投稿をアップロードします"),
          actions: <Widget>[
            // ボタン領域
            TextButton(
              child: Text("OK"),
              onPressed: () {

                //  login
                _loginAndUpload( context, bloc );

               // var accessToken =  LineSDK.instance.currentAccessToken;

                //print(accessToken.toString());
                //  Postdata のアップロード
                //_uploadPostData( context,  bloc);


                print("post dodo");
                Navigator.pop(context);
              }
              ,
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );

  }

  _uploadPostData(BuildContext context, WsBloc bloc) async {
       bloc.getPost();

       var plist = await bloc.getPostd();

       await for (  Postd psd in plist){

           var mapd = psd.toJson();
           //var mapd = "{\"id\"=1}";
           print(mapd);
           var result = fetchApiResults( mapd );
           //print(result);


       }
  }

  _loginAndUpload(BuildContext context, WsBloc bloc) async {
    var accessToken;
    bool _isOnlyWebLogin = false;

    try {
      /// requestCode is for Android platform only, use another unique value in your application.
      final loginOption =
      LoginOption(_isOnlyWebLogin, 'normal', requestCode: 8192);
      final result = await LineSDK.instance
          .login(scopes: ['profile'], option: loginOption);
      final accessToken = await LineSDK.instance.currentAccessToken;

      final idToken = result.accessToken.idToken;


      if (accessToken != null) {
        //print(accessToken.toString());
        //  Postdata のアップロード
        _uploadPostData( context,  bloc);

      }
    }
    on PlatformException catch (e) {
    print(e.message);
    }



  }


  Future<ApiResults> fetchApiResults( var post_data ) async {
    var url = "http://192.168.0.19/report/getpost.php";

    final response = await http.post(Uri.parse(url),
        body: post_data,
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      print("response OK");
      print(response.body);
      //return ApiResults.fromJson(json.decode(response.body));
    } else {
      print("response error");
      throw Exception('Failed');
    }
  }

  _showUploadDialog(BuildContext context, WsBloc bloc){
    showDialog(
        context: context,
        builder: (context) {
          Column(
            children: <Widget>[
              AlertDialog(
                title: Text("アップロード中"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Column(

                        // コンテンツ
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  // ボタン
                ],
              ),
            ],
          );
        }
    );
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

class ApiResults {
  final String message;
  ApiResults({
    this.message,
  });
  factory ApiResults.fromJson(Map<String, dynamic> json) {
    return ApiResults(
      message: json['message'],
    );
  }
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