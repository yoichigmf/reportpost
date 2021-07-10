import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../configs/const_text.dart';
import '../repositories/ws_bloc.dart';


import 'ws_list/ws_list_view.dart';


class WsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Provider<WsBloc>(
        create: (context) => new WsBloc(),
        dispose: (context, bloc) => bloc.dispose(),
      child: MaterialApp(
        title: ConstText.appTitle,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // ダークモード対応
        darkTheme: ThemeData(
            brightness: Brightness.dark,
          primarySwatch: Colors.lightBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
          home:WsListView(),
      )
    );
    /*
    return MaterialApp(
      title: ConstText.appTitle,
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      // ダークモード対応
      darkTheme: ThemeData(
          brightness: Brightness.dark
      ),
      home: Provider<WsBloc>(
          create: (context) => new WsBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        child: WsListView(),
      ),




    );

     */
  }
}


/*
class WsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ConstText.appTitle,
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      // ダークモード対応
      darkTheme: ThemeData(
          brightness: Brightness.dark
      ),
      home: Provider<WsBloc>(
          create: (context) => new WsBloc(),
          dispose: (context, bloc) => bloc.dispose(),
          child: WsListView()
      ),
    );
  }
}

 */