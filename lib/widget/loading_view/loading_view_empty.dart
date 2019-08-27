import 'package:flutter/material.dart';
import 'package:movie_sample/index/util_index.dart';

///加载中页面
class LoadingViewEmpty extends StatelessWidget {
  final GestureTapCallback emptyRetryListener;

  LoadingViewEmpty(this.emptyRetryListener);

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
          width: Density.instance.dp(120),
          height: Density.instance.dp(120),
          child: Image.asset(ImageUtil.getImagePath("ic_empty_page")),
        ),
        GestureDetector(
          onTap: emptyRetryListener,
          child: Padding(
            padding: EdgeInsets.all(Density.instance.dp(20)),
            child: Text(
              "暂无数据\n点击重新加载",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromARGB(255, 51, 51, 51), fontSize: Density.instance.sp(28)),
            ),
          ),
        ),
      ],
    );
  }
}
