import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';

class FindPage extends StatefulWidget {
  int currentPage = 0;
  List<Widget> tabItems;
  List<Widget> tabPages;

  FindPage() {
    tabItems = [Text("电影"), Text("电视")];
    tabPages = [
      BlocProvider(bloc: FindMovieBloc(), child: FindMoviePage()),
      BlocProvider(bloc: FindTvBloc(), child: FindTvPage())
    ];
  }

  @override
  State<StatefulWidget> createState() {
    return _FindPageState();
  }
}

class _FindPageState extends State<FindPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  PageController _pageController;

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: widget.tabItems.length, initialIndex: widget.currentPage, vsync: this);
    _pageController = PageController(initialPage: widget.currentPage, keepPage: true);
    return Scaffold(
      appBar: AppBarContainer(
        height: Density.instance.dp(168),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: Density.instance.dp(25), right: Density.instance.dp(25)),
              width: double.infinity,
              height: Density.instance.dp(66),
              child: SearchWidget(),
            ),
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
      body: ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: PageView(
            controller: _pageController,
            children: widget.tabPages,
            onPageChanged: (index) {
              widget.currentPage = index;
              _tabController.animateTo(index);
            },
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
