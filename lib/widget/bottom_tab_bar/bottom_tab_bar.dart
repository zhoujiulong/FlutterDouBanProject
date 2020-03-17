import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_sample/index/util_index.dart';

import 'bottom_tab_bar_item.dart';

///自定义底部导航栏
class BottomTabBar extends StatefulWidget {
  BottomTabBar(
      {Key key,
      this.items,
      this.selectedColor,
      this.unSelectedColor,
      this.backgroundColor = Colors.transparent,
      this.onTap,
      this.currentIndex = 0,
      this.iconSize = 24.0,
      this.fontSize = 10,
      this.iconTopMargin = 6,
      this.iconBottomMargin = 0,
      this.fontBottomMargin = 8})
      : assert(items != null),
        assert(items.length >= 2),
        assert(0 <= currentIndex && currentIndex < items.length);

  //底部Item
  final List<BottomTabBarItem> items;

  //按钮点击监听
  final ValueChanged<int> onTap;

  //当前选中的角标
  final int currentIndex;

  //导航栏背景颜色
  final Color backgroundColor;

  //选中的颜色
  final Color selectedColor;

  //未选中颜色
  final Color unSelectedColor;

  //图片大小
  final double iconSize;

  //底部文字大小
  final double fontSize;

  //图标顶部间距
  final double iconTopMargin;

  //图标底部间距
  final double iconBottomMargin;

  //底部文字底部间距
  final double fontBottomMargin;

  @override
  _BottomTabBarState createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    assert(debugCheckHasMaterialLocalizations(context));

    //SafeArea适配底布区域
    return SafeArea(
      bottom: true,
      child: Stack(
        children: <Widget>[
          //设置导航栏背景颜色
          Positioned.fill(child: Material(color: widget.backgroundColor)),
          Container(
            width: Density.instance.screenWidth,
            height: Density.instance.dp(1),
            color: Color.fromARGB(100, 167, 161, 164),
          ),
          Row(
            children: _createTiles(),
          )
        ],
      ),
    );
  }

  ///根据传进来的底部按钮数量进行创建
  List<Widget> _createTiles() {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    assert(localizations != null);
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < widget.items.length; i += 1) {
      children.add(
        _BottomNavigationTile(
          widget.items[i],
          widget.iconSize,
          widget.fontSize,
          i == widget.currentIndex,
          i == widget.currentIndex
              ? widget.selectedColor
              : widget.unSelectedColor,
          widget.iconTopMargin,
          widget.iconBottomMargin,
          widget.fontBottomMargin,
          () {
            //Item点击事件，加上角标调用传进来的方法
            if (widget.onTap != null) widget.onTap(i);
          },
        ),
      );
    }
    return children;
  }
}

class _BottomNavigationTile extends StatelessWidget {
  _BottomNavigationTile(
    this.item,
    this.iconSize,
    this.fontSize,
    this.selected,
    this.iconColor,
    this.iconTopMargin,
    this.iconBottomMargin,
    this.fontBottomMargin,
    this.onTap,
  );

  final BottomTabBarItem item;
  final double iconSize;
  final double fontSize;
  final VoidCallback onTap;
  final bool selected;
  final Color iconColor;
  final double iconTopMargin;
  final double iconBottomMargin;
  final double fontBottomMargin;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _buildInkWidget(),
    );
  }

  ///创建单个 Item 控件
  Widget _buildInkWidget() {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: <Widget>[
          //通过占位的方式撑开，使得点击范围达到最大值，暂时没想到更好的方法
          Positioned.fill(child: Material(color: Colors.transparent)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildIcon(),
              _buildFixedLabel(),
            ],
          )
        ],
      ),
    );
  }

  ///创建图标
  Widget _buildIcon() {
    return Center(
      child: Container(
        width: iconSize,
        height: iconSize,
        margin: EdgeInsets.only(top: iconTopMargin, bottom: iconBottomMargin),
        child: Image.asset(selected ? item.activeIcon : item.icon),
      ),
    );
  }

  ///创建底部文字
  Widget _buildFixedLabel() {
    return Container(
      margin: EdgeInsets.only(bottom: fontBottomMargin),
      child: Text(
        item.text,
        style: TextStyle(fontSize: fontSize, color: iconColor),
      ),
    );
  }
}
