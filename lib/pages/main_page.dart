import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
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
    FindPage(),
    BlocProvider(bloc: AccountBloc(), child: AccountPage()),
  ];

  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    this._pageController = PageController(initialPage: this._currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomTabBar(
        items: tabBarItems,
        selectedColor: ColorRes.TEXT_NORMAL,
        unSelectedColor: ColorRes.TEXT_GRAY,
        currentIndex: _currentIndex,
        onTap: (int i) {
          setState(() {
            this._currentIndex = i;
            this._pageController.jumpToPage(this._currentIndex);
          });
        },
        iconSize: Density.instance.dp(42),
        fontSize: Density.instance.dp(20),
        iconTopMargin: Density.instance.dp(20),
        iconBottomMargin: Density.instance.dp(5),
        fontBottomMargin: Density.instance.dp(12),
      ),
      body: PageView(
        controller: _pageController,
        children: widgetOptions,
      ),
    );
  }
}
