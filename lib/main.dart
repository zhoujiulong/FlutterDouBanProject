import 'package:flutter/material.dart';
import 'package:movie_sample/index/bloc_index.dart';
import 'package:movie_sample/index/page_index.dart';
import 'package:movie_sample/index/util_index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SpUtil.init();
    return BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
        home: SplashPage(),
      ),
    );
  }
}
