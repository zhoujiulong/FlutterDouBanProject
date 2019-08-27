import 'package:flutter/material.dart';
import 'package:movie_sample/index/util_index.dart';

///加载中页面
class LoadingViewLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildLoadingWidget();
  }

  Widget _buildLoadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: Density.instance.dp(52),
          height: Density.instance.dp(52),
          child: CircularProgressIndicator(
            strokeWidth: Density.instance.dp(5),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(Density.instance.dp(20)),
          child: Text(
            "加载中...",
            style: TextStyle(color: Color.fromARGB(255, 51, 51, 51), fontSize: Density.instance.sp(28)),
          ),
        ),
      ],
    );
  }
}
