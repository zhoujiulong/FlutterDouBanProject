import 'package:flutter/material.dart';
import 'package:movie_sample/index/bloc_index.dart';
import 'package:movie_sample/index/page_index.dart';
import 'package:movie_sample/index/res_index.dart';
import 'package:movie_sample/index/util_index.dart';
import 'package:movie_sample/index/widget_index.dart';

class MainPage extends StatelessWidget {
  //底部导航栏Items
  final List<BottomTabBarItem> tabBarItems = [
    BottomTabBarItem(
        '热映', ImageUtil.getImagePath("ic_hot_play_unselected"), ImageUtil.getImagePath("ic_hot_play_selected")),
    BottomTabBarItem(
        '找片', ImageUtil.getImagePath("ic_find_movie_unselected"), ImageUtil.getImagePath("ic_find_movie_selected")),
    BottomTabBarItem(
        '我的', ImageUtil.getImagePath("ic_account_unselected"), ImageUtil.getImagePath("ic_account_selected")),
  ];

  //Item对应的页面
  final List<Widget> widgetOptions = [
    HotPage(),
    FindMoviePage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    return StreamBuilder(
      stream: applicationBloc.mainIndexStream,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        int index = (snapshot.data >= 0 && snapshot.data < widgetOptions.length) ? snapshot.data : 0;
        return Scaffold(
          bottomNavigationBar: BottomTabBar(
            items: tabBarItems,
            selectedColor: ColorRes.TEXT_NORMAL,
            unSelectedColor: ColorRes.TEXT_GRAY,
            currentIndex: index,
            onTap: (int i) {
              applicationBloc.sendMainIndexEvent(i);
            },
            iconSize: Density.instance.dp(42),
            fontSize: Density.instance.dp(20),
            iconTopMargin: Density.instance.dp(20),
            iconBottomMargin: Density.instance.dp(5),
            fontBottomMargin: Density.instance.dp(12),
          ),
          body: SizedBox.expand(
            child: widgetOptions.elementAt(index),
          ),
        );
      },
    );
  }
}
