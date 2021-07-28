import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';


class ConfigStore {


  static init_AuthAPI() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //

    String _Line_channel = prefs.getString('line_channel') ?? '1656109293';
    // LineSDK.instance.setup('1656109293').then((_) {
    LineSDK.instance.setup(_Line_channel).then((_) {
      print('LineSDK Prepared');
    });

  }

  static  get_keyValueStr( String key ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return( prefs.getString(key));

  }

  static  get_PostURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('post_url');

    return url;


  }

  static  get_LineChannel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String channnel = prefs.getString('line_channel');

    return channnel;


  }
  static save_Instance( String channel, String url ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('line_channel',channel  );
    prefs.setString('post_url', url );
  }

  static  get_Param() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


  }
  _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 以下

    String _Line_channel = prefs.getString('line_channel') ?? '1656109293';
    // LineSDK.instance.setup('1656109293').then((_) {
    LineSDK.instance.setup(_Line_channel).then((_) {
      print('LineSDK Prepared');
    });
  }

}
