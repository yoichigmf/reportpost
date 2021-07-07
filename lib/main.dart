import 'package:flutter/material.dart';
import 'components/app.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main()  async {
  WidgetsFlutterBinding.ensureInitialized();

  await _getPrefItems();
    runApp(WsApp());

}

_getPrefItems() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // 以下の「counter」がキー名。見つからなければ０を返す

    String _Line_channel  = prefs.getString('line_channel') ?? '1656109293';
  // LineSDK.instance.setup('1656109293').then((_) {
  LineSDK.instance.setup(_Line_channel).then((_) {
    print('LineSDK Prepared');
  });
}