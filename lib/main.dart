import 'package:flutter/material.dart';
import 'components/app.dart';


import 'configs/config_store.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigStore.init_AuthAPI();

    runApp(WsApp());

}


