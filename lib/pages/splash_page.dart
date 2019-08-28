import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    Density.instance.init(context, 750, 750);
    _timer = Timer(Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
    });
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Container(
        color: Colors.white,
        child: Center(
          child: Container(
              width: Density.instance.dp(350),
              height: Density.instance.dp(350),
              child: Image.asset(
                ImageUtil.getImagePath("ic_splash"),
                fit: BoxFit.fill,
              )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
