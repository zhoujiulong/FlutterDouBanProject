import 'package:flutter/material.dart';
import 'package:movie_sample/index/bloc_index.dart';
import 'package:movie_sample/index/page_index.dart';
import 'package:movie_sample/index/util_index.dart';
import 'package:movie_sample/index/widget_index.dart';

class HotPage extends StatefulWidget {
  int currentPage = 0;
  List<Widget> tabItems;
  List<Widget> tabPages;

  HotPage() {
    tabItems = [Text("正在热映"), Text("即将上映")];
    tabPages = [
      BlocProvider(
        bloc: HotPlayBloc(),
        child: HotPlayPage(),
      ),
      SoonPlayPage()
    ];
  }

  @override
  State<StatefulWidget> createState() {
    return _HotPageState();
  }
}

class _HotPageState extends State<HotPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: widget.tabItems.length, initialIndex: widget.currentPage, vsync: this);
    _pageController = PageController(initialPage: widget.currentPage, keepPage: true);
    return Scaffold(
      appBar: AppBarContainer(
        height: Density.instance.dp(80),
        child: Column(
          children: <Widget>[
            TabBar(
              controller: _tabController,
              //可以和TabBarView使用同一个TabController
              tabs: widget.tabItems,
              isScrollable: false,
              indicatorColor: Color.fromARGB(255, 51, 51, 51),
              indicatorWeight: Density.instance.dp(4),
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.only(bottom: Density.instance.dp(10), top: Density.instance.dp(25)),
              labelColor: Color.fromARGB(255, 51, 51, 51),
              labelStyle: TextStyle(
                fontSize: Density.instance.sp(28),
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelColor: Color.fromARGB(100, 51, 51, 51),
              unselectedLabelStyle: TextStyle(
                fontSize: Density.instance.sp(28),
                fontWeight: FontWeight.bold,
              ),
              onTap: (index) {
                widget.currentPage = index;
                _pageController.jumpToPage(index);
              },
            ),
            Container(
              width: Density.instance.screenWidth,
              height: Density.instance.dp(1),
              color: Color.fromARGB(100, 167, 161, 164),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: widget.tabPages,
        onPageChanged: (index) {
          widget.currentPage = index;
          _tabController.animateTo(index);
        },
      ),
    );
  }
}
