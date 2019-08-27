import 'package:flutter/material.dart';
import 'package:movie_sample/index/util_index.dart';

///自定义标题栏
///解决官方提供的标题栏高度不可调节，不能按UI添加不同控件问题
class MYAppBar extends StatefulWidget implements PreferredSizeWidget {
  MYAppBar(this.title, {this.showBack = true, this.backgroundColor = Colors.transparent, this.backClickListener});

  //标题
  final String title;

  //是否有返回按钮
  final bool showBack;

  //标题栏背景颜色
  final Color backgroundColor;

  //返回按钮监听，如果需要手动处理返回事件就设置
  final GestureTapCallback backClickListener;

  @override
  Size get preferredSize {
    //设置标题栏高度，一般app中的标题栏高度是统一的
    return Size.fromHeight(Density.instance.dp(88));
  }

  @override
  State createState() {
    return _MYAppBarState();
  }
}

class _MYAppBarState extends State<MYAppBar> {
  void _onBackTap() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //如果需要添加标题右侧按钮或者右侧副标题可添加进来
    List<Widget> children = <Widget>[];
    //添加背景色
    children.add(Positioned.fill(child: Material(color: widget.backgroundColor)));
    //添加标题，标题颜色和字体大小一般固定所以写死
    children.add(Center(
      child: Text(
        widget.title,
        style: TextStyle(fontSize: Density.instance.sp(32), color: Color.fromARGB(255, 51, 51, 51)),
      ),
    ));
    //如果显示返回按钮就添加返回图标
    if (widget.showBack) {
      children.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: (widget.backClickListener != null) ? widget.backClickListener : _onBackTap,
            child: Container(
              width: Density.instance.dp(96),
              height: Density.instance.dp(80),
              padding: EdgeInsets.only(
                  left: Density.instance.dp(30),
                  right: Density.instance.dp(30),
                  top: Density.instance.dp(22),
                  bottom: Density.instance.dp(22)),
              child: Image.asset(
                ImageUtil.getImagePath("ic_back"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ));
    }

    return SafeArea(
      top: true,
      child: Stack(
        children: children,
      ),
    );
  }
}
