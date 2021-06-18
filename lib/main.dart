import 'package:flutter/material.dart';
import 'components/app.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();


  // LineSDK.instance.setup('1620019587').then((_) {
  LineSDK.instance.setup('1656109293').then((_) {
    print('LineSDK Prepared');
  });
  runApp(WsApp());
}