import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///我的主页
class AccountPage extends StatelessWidget {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    widgets.add(_buildTopWidget());
    widgets.add(_buildStickyBar());
    widgets.add(_buildList());

    return Scaffold(
      appBar: AppBarContainer(
        child: null,
        backgroundColor: ColorRes.ACCOUNT_PAGE_TOP_BG,
      ),
      body: Listener(
        onPointerDown: (event) {
          LogUtil.d("zhoujiulong:onPointerDown");
          LogUtil.d(event.toString());
        },
        onPointerMove: (event) {
          LogUtil.d("zhoujiulong:onPointerMove");
          LogUtil.d(event.toString());
        },
        onPointerUp: (event) {
          LogUtil.d("zhoujiulong:onPointerUp");
          LogUtil.d(event.toString());
        },
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: Density.instance.dp(500),
              color: ColorRes.ACCOUNT_PAGE_TOP_BG,
            ),
            SmartRefresher(
              controller: _refreshController,
              onRefresh: () {
                _refreshController.refreshCompleted();
              },
              header: ClassicHeader(),
              child: CustomScrollView(
                slivers: widgets,
              ),
            )
          ],
        ),
      ),
    );
  }

  //构建顶部信息
  Widget _buildTopWidget() {
    List<Widget> widgets = <Widget>[];

    //左侧头像
    widgets.add(
      Positioned(
        left: Density.instance.dp(60),
        top: Density.instance.dp(95),
        child: Container(
          width: Density.instance.dp(160),
          height: Density.instance.dp(160),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Density.instance.dp(80)),
            child: Image.asset(
              ImageUtil.getImagePath("ic_head_pla"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );

    //中间名称和按钮
    widgets.add(Positioned(
      left: Density.instance.dp(260),
      top: Density.instance.dp(110),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //名字
          Text(
            "long",
            style: TextStyle(
              fontSize: Density.instance.sp(36),
              color: Colors.white,
            ),
          ),
          //我的电影票按钮
          Padding(
            padding: EdgeInsets.only(top: Density.instance.dp(40)),
            child: Container(
              width: Density.instance.dp(260),
              height: Density.instance.dp(70),
              decoration: BoxDecoration(
                  border: Border.all(width: Density.instance.dp(2), color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(Density.instance.dp(8)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: Density.instance.dp(34),
                    height: Density.instance.dp(28),
                    child: Image.asset(
                      ImageUtil.getImagePath("ic_ticket"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(width: Density.instance.dp(20)),
                  Text(
                    "我的电影票",
                    style: TextStyle(color: Colors.white, fontSize: Density.instance.sp(26)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));

    //右侧设置图标
    widgets.add(
      Positioned(
        top: Density.instance.dp(30),
        right: Density.instance.dp(30),
        child: Container(
          width: Density.instance.dp(54),
          height: Density.instance.dp(54),
          child: Image.asset(
            ImageUtil.getImagePath("ic_setting"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );

    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        height: Density.instance.dp(350),
        color: ColorRes.ACCOUNT_PAGE_TOP_BG,
        child: Stack(
          children: widgets,
        ),
      ),
    );
  }

  Widget _buildStickyBar() {
    return SliverPersistentHeader(
      pinned: true, //是否固定在顶部
      floating: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 50, //收起的高度
        maxHeight: 50, //展开的最大高度
        child: Container(
          padding: EdgeInsets.only(left: 16),
          color: Colors.pink,
          alignment: Alignment.centerLeft,
          child: Text("浮动", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            height: 50,
            color: index % 2 == 0 ? Colors.white : Colors.blue,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text("我是第${index}个item"),
          );
        },
        childCount: 30,
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
