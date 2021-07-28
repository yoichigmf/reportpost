import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/post_edit/post_edit_view.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/post.dart';
import '../../models/workspace.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../repositories/ws_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';
import '../tools/video_thumbnail.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';

import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:reportpost/configs/config_store.dart';


class PostListView extends StatelessWidget {
  String wid;
  WorkSpace wksp;
  String title;

  WsBloc  _bloc;

  //final Postd post;
  final Postd _newPost = Postd.newPost();
  //var _msgTextC = TextEditingController();
  var _image;
  final picker = ImagePicker();



  var _snacontext;


  // final WorkSpace _newWS = WorkSpace.newWorkSpace();

  PostListView({Key key, @required this.wksp}) {
    this.wid = wksp.id;
    this.wksp = wksp;
    this.title = wksp.title;
  }

  _show_snackbar(textmsg){
    ScaffoldMessenger.of(_snacontext).showSnackBar(
        SnackBar(
        content:  Text(textmsg),
    duration: const Duration(seconds: 5),
        ));
  }

  void _showBottom(BuildContext context){
    Scaffold.of(_snacontext)
        .showBottomSheet<Null>((_snacontext) {
      return new Container(
        height: 200,
        padding: new EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            new Text('複数行の内容を'),
            new Text('記載することができるので'),
            new Text('ヘルプなど'),
            new Text('ユーザ補助としても'),
            new Text('つかえます。'),
            new RaisedButton(onPressed: () => Navigator.pop(context), child: new Text('Close'),)
          ],
        ),
      );
    }
    );
  }

  @override
  Widget build(BuildContext context)  {
    _bloc = Provider.of<WsBloc>(context, listen: false);

    final postList = _bloc.reportPostBloc();

    final titlestring = _bloc.title;

    _snacontext =  context;


    var lcount = 0;

    if (postList != null) {
      lcount = postList.length;
    }
    return Scaffold(
      appBar: AppBar(title: Text(titlestring)),
    bottomNavigationBar: new Container(
    padding: EdgeInsets.all(0.0),
    child: Row(
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      Expanded(
        flex: 1,
        child:  IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () {

              _moveToAddPhotoView(context, _bloc);
            }

        ),
      ),
      Expanded(
        flex: 1,
        child: IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () {
              // print("add pic ");

              _moveToAddpicView(context, _bloc);
            }

        ),
      ),

      Expanded(
        flex: 1,
        child:  IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {

              _moveToAddVideoView(context, _bloc);
            }

        ),
      ),


      Expanded(
        flex: 1,
        child:  IconButton(
            icon: Icon(Icons.video_library),
            onPressed: () {

              _moveToAddVideoFromGalley(context, _bloc);
            }

        ),
      ),


      Expanded(
        flex: 1,
        child:   IconButton(
            icon: Icon(Icons.record_voice_over_sharp),
            onPressed: () {
              //_uploadWorkSpace(context, _bloc);
              /*
              Scaffold.of(_snacontext )
                  .showBottomSheet<Null>((_snacontext ) {
                return new Container(
                  height: 200,
                  padding: new EdgeInsets.all(10.0),
                  child: new Column(
                    children: <Widget>[
                      new Text('複数行の内容を'),
                      new Text('記載することができるので'),
                      new Text('ヘルプなど'),
                      new Text('ユーザ補助としても'),
                      new Text('つかえます。'),
                      new RaisedButton(onPressed: () => Navigator.pop(context), child: new Text('Close'),)
                    ],
                  ),
                );
              }
              );

               */
            }
        ),
      ),

      Expanded(
        flex: 1,
        child:   IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: () {
              _uploadWorkSpace(context, _bloc);

            }
        ),
      ),

      Expanded(
        flex: 1,
        child:   IconButton(
            icon: Icon(Icons.add_comment),
            onPressed: () {
              _moveToCreateView(context, _bloc);
            }
        ),
      ),

      ],
    )
    ),

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
                    child: _getItemListTile( ws ),

                  ),

                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),

    );
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
                //  login and upload
                _loginAndUpload(context, bloc);


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


  _loginAndUpload(BuildContext context, WsBloc bloc) async {
    var accessToken;
    bool _isOnlyWebLogin = false;



    String  postService = await ConfigStore.get_PostURL();

    var _dio = Dio();
    var cookieJar=CookieJar();
    _dio.interceptors.add(CookieManager(cookieJar));


    _dio.options.contentType = "multipart/form-data";

    //final clientAdapter = HttpClientAdapter(); //
    // clientAdapter.withCredentials = true;

    //  _dio.httpClientAdapter = clientAdapter; // アダプターをセット
    try {
      /// requestCode is for Android platform only, use another unique value in your application.
      final loginOption =
      LoginOption(_isOnlyWebLogin, 'normal', requestCode: 8192);
      final result = await LineSDK.instance
          .login(scopes: ['profile'], option: loginOption);
      final accessToken = await LineSDK.instance.currentAccessToken;
      final _userProfile = result.userProfile;


      final _friendshpstatus = result.isFriendshipStatusChanged;

      // final idToken = result.accessToken.idToken;

      print("token = ");
      print(accessToken.value);
      print("id = ");
      print (_userProfile.userId);
      print("display name = ");
      print(_userProfile.displayName);
      print("friend ship = ");
      print(_friendshpstatus );



      if (_friendshpstatus ){
        var result = await showDialog<int>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('確認'),
                content: Text('指定LINE BOTと友達になっていないのでアップロードできません'),
                actions: <Widget>[

                  TextButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(1),
                  ),
                ],
              );
            }
        );
        return;
      }

      Response response;


      if (accessToken != null) {
        //print(accessToken.toString());
        //  Postdata のアップロード
        response = await _dio.post(postService, data: new FormData.fromMap(
            {'command': 'START', 'token': accessToken.value}));
        //  Token を渡してログイン

        if (response.statusCode == 200) {
          print("response ok");
          //_msgTextC.text = "アップロード成功" ;
          _show_snackbar("アップロード成功");
          //  umsgbox = Text("response ok");
          //  data upload 処理のステータスをとってエラーハンドリングを書かなければ
          await _uploadPostData(context, bloc, _dio, postService, accessToken.value, _userProfile.displayName);

          //  ログアウト処理
          //response = await _dio.post(postService, data: new FormData.fromMap(
          //  {'command': 'END', 'token': accessToken.value}));
        }
        else {
          //   ログインエラー処理を書く
          _show_snackbar("サーバ接続エラー "+ response.statusMessage);
          //_msgTextC.text = "サーバ接続エラー "+ response.statusMessage;
          //umsgbox = Text("サーバ接続エラー");
          print("error ");
        }
      }
    }
    on PlatformException catch (e) {
      _show_snackbar("サーバ接続エラー "+ e.message);
      //_msgTextC.text = "サーバ接続エラー " + e.message ;
      print(e.message);
    }
    catch( e ) {
      _show_snackbar("サーバ接続エラー "+ e.message);
      print(e.message);
    }
  }

  _uploadPostData(BuildContext context, WsBloc bloc, Dio dio,
      String postService, String accesstoken, String username) async {
    bloc.getPost();

    //  make transaction id
    var transact_id = Uuid().v4();

    var plist = await bloc.getPostd();

    await for (Postd psd in plist) {
      var mapd = psd.toMapJson();
      //var mapd = "{\"id\"=1}";
      // print(mapd);
      var result = await fetchApiResults(mapd, dio, postService, accesstoken, username, transact_id );
      //print(result);


    }
  }


  Future<ApiResults> fetchApiResults(var post_data, Dio dio, String postService,
      String accesstoken, String username , String transact_id ) async {


    post_data['command'] = 'DATA';
    post_data['token'] = accesstoken;

    post_data['user'] = username ;
    post_data['transact_id'] = transact_id ;

    print(post_data);
    var response = await dio.post(postService, data: new FormData.fromMap(
        post_data));
    //  Token を渡してログイン

    if (response.statusCode == 200) {
      print("response ok");

    }
    else {
      print( "response error");


    }
  }

  _getItemListTile( Postd ws )  {
    //GenThumbnailImage  _futureImage;

    //  kind   0 text   1 image 2 movie   3 voice 4 file
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

     case 2:   //   movie
     /*  var i18list = await VideoThumbnail.thumbnailData(
         video: ws.image,
         imageFormat: ImageFormat.JPEG,
         maxWidth: 128,
         quality: 25,
       );



      */
       return( ListTile(

           leading:  Icon(Icons.videocam) ,
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



Future<String> _getVideothumnail( tgfile ) async {


   final fileName = await VideoThumbnail.thumbnailFile(
       video: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
       thumbnailPath: (await getTemporaryDirectory()).path,
   imageFormat: ImageFormat.WEBP,
   maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
   quality: 75,
   );


    return fileName;

  }
  _timeformated(DateTime tm) {
    initializeDateFormatting("ja_JP");
    var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
    var formatted = formatter.format(tm); // DateからString
    return formatted;
  }



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



  _moveToAddVideoView(BuildContext context, WsBloc _bloc){
    _getVideoFromCamera();

  }

  _moveToAddVideoFromGalley(BuildContext context, WsBloc _bloc){
    _getVideoFromGalley();

  }


  Future _getVideoFromCamera() async {
    PickedFile pickedFile = await picker.getVideo(source: ImageSource.camera);


    if ( pickedFile != null) {
      print(pickedFile.path);
      _createNewPost(  pickedFile  ,2);
      _image = File(pickedFile.path);

    }
  }

  Future _getVideoFromGalley() async {
    PickedFile pickedFile = await picker.getVideo(source: ImageSource.gallery);


    if ( pickedFile != null) {
      print(pickedFile.path);
      _createNewPost(  pickedFile  ,2);
      _image = File(pickedFile.path);

    }
  }

  Future _getImageFromPhoto() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);


    if ( pickedFile != null) {
      print(pickedFile.path);
      _createNewPost(  pickedFile ,1 );
      _image = File(pickedFile.path);

    }
  }
  Future _getImageFromGallery() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);


      if ( pickedFile != null) {
        print(pickedFile.path);
        _createNewPost(  pickedFile  ,1);
        _image = File(pickedFile.path);

      }

  }

  _createNewPost( PickedFile pfile , int kind){
    _newPost.image = pfile.path;
    _newPost.note = pfile.path;
    _newPost.kind = kind;
    _bloc.createPost(_newPost);
    _image = File(pfile.path);
  }


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