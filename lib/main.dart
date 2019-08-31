import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SpUtil.init();
    LogUtil.init(isDebug: true, tag: "zhoujiulong");
    return BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: MaterialApp(
        title: '豆瓣电影',
        theme: ThemeData(primaryColor: Colors.white, scaffoldBackgroundColor: Colors.white),
        home: SplashPage(),
      ),
    );
  }
}
