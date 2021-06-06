import 'dart:async';
import 'dart:core';
import '../models/workspace.dart';
import '../models/post.dart';
import '../repositories/db_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';

class WsBloc {

  final _wsController = StreamController<List<WorkSpace>>();
  //final _cwsController = StreamController<List<WorkSpace>>();
  // current ws

  final _postController = BehaviorSubject<List<Postd>>();


  Stream<List<WorkSpace>> get wsStream => _wsController.stream;
  //Stream<List<WorkSpace>> get cwsStream => _cwsController.stream;
  Stream<List<Postd>> get postStream => _postController.stream;

  String  wid;
  String  title;


  WsBloc(){
    getWorkSpaces();
  }
  getWorkSpaces() async {
    _wsController.sink.add(await DBProvider.db.getAllWs());
  }



  getPost() async {
    _postController.sink.add(await DBProvider.db.getPostinWS(this.wid));
  }

/*
  setCurrent( WorkSpace ws){
     _cwsController.sink.add( [ws]);
  }
*/

  reportBloc() {
    getWorkSpaces();
  }

  reportPostBloc() {
    getPost();
  }


  dispose() {
    _wsController.close();
    //_cwsController.close();
    _postController.close();
  }

  create(WorkSpace rep) {
    rep.assignUUID();
    DBProvider.db.createWs(rep);
    getWorkSpaces();
  }

  update(WorkSpace rep) {
    DBProvider.db.updateWs(rep);


    getWorkSpaces();
  }

  delete(String id) {
    DBProvider.db.deleteWs(id);

    DBProvider.db.deletePostInWs(id);

    getWorkSpaces();
  }

  createPost(Postd rep) {
    rep.assignUUID();
    rep.wid = this.wid;


     print( this.wid);
     Future<Position> pos = _getLocate();

     //  位置情報設定
    pos.then((position) {
      rep.lat = position.latitude;
      rep.lon = position.longitude;
      print("set location");
      //rep.lat = pos.
      DBProvider.db.createPost(rep);
      getPost();
    }

    );


    // pos.then()


  }


  Future<Position> _getLocate() async {


    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("POSITION=");
    print(position);

    return Future.value(position);



  }

  updatePost(Postd rep) {
    DBProvider.db.updatePost(rep);
    getPost();
  }

  deletePost(String id) {
    DBProvider.db.deletePost(id);
    getPost();
  }
}
