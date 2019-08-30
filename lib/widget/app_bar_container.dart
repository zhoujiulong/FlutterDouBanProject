import 'package:flutter/material.dart';

///使用传进来的控件作为标题
class AppBarContainer extends StatelessWidget implements PreferredSizeWidget {
  AppBarContainer({@required this.child, this.height = 0, this.backgroundColor = Colors.transparent});

  final Widget child;
  final double height;
  final Color backgroundColor;

  @override
  Size get preferredSize {
    //设置标题栏高度，一般app中的标题栏高度是统一的
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    //如果需要添加标题右侧按钮或者右侧副标题可添加进来
    List<Widget> children = <Widget>[];
    if (child != null) {
      children.add(child);
    }

    return Container(
      color: backgroundColor,
      child: SafeArea(
          top: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: children,
          )),
    );
  }
}
