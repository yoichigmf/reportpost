import 'dart:io';

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

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:uuid/uuid.dart';
//import 'package:dio/adapter_browser.dart';


import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:reportpost/configs/config_store.dart';

class PostUploadView extends StatelessWidget {
  String wid;
  WorkSpace wksp;
  String title;

  WsBloc _bloc;

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
      appBar: AppBar(title: Text(titlestring + " アップロード")),
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
                    child: _getItemListTile(ws),

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

  _getItemListTile(Postd ws) {
    switch (ws.kind) {
      case 1: // image
        return (ListTile(
          onTap: () {

          },
          leading: Image.file(File(ws.image)),
          // title: Text(ws.note,
          //    style: TextStyle(color: Colors.black87)),
          subtitle: Text(_timeformated(ws.postDate),
              style: TextStyle(color: Colors.black87)),
        )
        );
        break;
      case 0: //  text

      default:
        return (ListTile(
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

          //  data upload 処理のステータスをとってエラーハンドリングを書かなければ
          await _uploadPostData(context, bloc, _dio, postService, accessToken.value, _userProfile.displayName);

          //  ログアウト処理
          //response = await _dio.post(postService, data: new FormData.fromMap(
            //  {'command': 'END', 'token': accessToken.value}));
        }
        else {
          //   ログインエラー処理を書く
          print("error ");
        }
      }
    }
    on PlatformException catch (e) {
      print(e.message);
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



    _showUploadDialog(BuildContext context, WsBloc bloc) {
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


    _moveToAddPhotoView(BuildContext context, WsBloc _bloc) {
      _getImageFromPhoto();
    }
    _moveToAddpicView(BuildContext context, WsBloc _bloc) {
      _getImageFromGallery();
    }

    Future _getImageFromPhoto() async {
      PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);


      if (pickedFile != null) {
        print(pickedFile.path);
        _createNewPost(pickedFile);
        _image = File(pickedFile.path);
      }
    }
    Future _getImageFromGallery() async {
      PickedFile pickedFile = await picker.getImage(
          source: ImageSource.gallery);


      if (pickedFile != null) {
        print(pickedFile.path);
        _createNewPost(pickedFile);
        _image = File(pickedFile.path);
      }
    }

    _createNewPost(PickedFile pfile) {
      _newPost.image = pfile.path;
      _newPost.note = pfile.path;
      _newPost.kind = 1;
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