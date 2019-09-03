import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';

class NoMoreWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return _buildFooter();
  }

  Widget _buildFooter() {
    return Container(
      height: Density.instance.dp(60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: ColorRes.LINE,
            height: Density.instance.dp(1),
            width: Density.instance.dp(30),
          ),
          Padding(
              padding: EdgeInsets.only(left: Density.instance.dp(15), right: Density.instance.dp(15)),
              child: Text(
                "THE END",
                style: TextStyle(color: ColorRes.LINE, fontSize: Density.instance.dp(22)),
              )),
          Container(
            color: ColorRes.LINE,
            height: Density.instance.dp(1),
            width: Density.instance.dp(30),
          ),
        ],
      ),
    );
  }
}