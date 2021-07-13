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


class PostListView extends StatelessWidget {
  String wid;
  WorkSpace wksp;
  String title;

  WsBloc  _bloc;

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
  Widget build(BuildContext context)  {
    _bloc = Provider.of<WsBloc>(context, listen: false);

    final postList = _bloc.reportPostBloc();

    final titlestring = _bloc.title;

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
/*
      Expanded(
        flex: 1,
        child:  IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: () {

              // _moveToAddPhotoView(context, _bloc);
            }

        ),
      ),

      Expanded(
        flex: 1,
        child:   IconButton(
            icon: Icon(Icons.record_voice_over),
            onPressed: () {

              // _moveToAddPhotoView(context, _bloc);
            }

        ),
      ),

 */

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
            icon: Icon(Icons.video_call),
            onPressed: () {

              _moveToAddVideoView(context, _bloc);
            }

        ),
        IconButton(
            icon: Icon(Icons.video_library),
            onPressed: () {

              _moveToAddVideoFromGalley(context, _bloc);
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

_getItemListTile( Postd ws )  {
    GenThumbnailImage  _futureImage;

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