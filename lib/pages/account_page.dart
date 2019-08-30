import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_sample/index/index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///我的主页
class AccountPage extends StatelessWidget {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  AccountBloc _accountBloc;

  @override
  Widget build(BuildContext context) {
    _accountBloc = BlocProvider.of<AccountBloc>(context);
    if (_accountBloc.eventModel.musicModel == null) {
      Timer(Duration(milliseconds: 50), () {
        _accountBloc.getDataByType(context, COLLECTION_TYPE.WANT_LOOK);
      });
    }

    List<Widget> widgets = <Widget>[];
    widgets.add(_buildTopWidget());
    widgets.add(SliverPersistentHeader(
      floating: true,
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: Density.instance.dp(88),
        maxHeight: Density.instance.dp(88),
        child: Container(
          color: ColorRes.ACCOUNT_PAGE_TOP_BG,
          child: Stack(
            children: <Widget>[],
          ),
        ),
      ),
    ));
    widgets.add(StreamBuilder(
      initialData: _accountBloc.eventModel,
      stream: _accountBloc.collectionStream,
      builder: (BuildContext context, AsyncSnapshot<AccountListEventModel> snapshot) {
        AccountListEventModel model = snapshot.data;
        List<SubjectsModel> subjects = (model == null || model.musicModel == null || model.musicModel.subjects == null)
            ? <SubjectsModel>[]
            : model.musicModel.subjects;
        COLLECTION_TYPE type =
            (model == null || model.collectionType == null) ? COLLECTION_TYPE.WANT_LOOK : model.collectionType;

        return SliverStickyHeaderBuilder(
          builder: (context, state) => _buildStickyBar(context, type, subjects.length),
          sliver: _ButtomList(subjects),
        );
      },
    ));

    return Scaffold(
      appBar: AppBarContainer(
        child: null,
        backgroundColor: ColorRes.ACCOUNT_PAGE_TOP_BG,
      ),
      body: Listener(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: Density.instance.dp(400),
              color: ColorRes.ACCOUNT_PAGE_TOP_BG,
            ),
            ScrollConfiguration(
              behavior: MyScrollBehavior(),
              child: StreamBuilder(
                  initialData: LoadingState.success,
                  stream: _accountBloc.loadingStream,
                  builder: (BuildContext context, AsyncSnapshot<LoadingState> snapshot) {
                    if (snapshot.data == LoadingState.success) {
                      _refreshController.refreshCompleted();
                    } else {
                      _refreshController.refreshFailed();
                    }
                    return SmartRefresher(
                      controller: _refreshController,
                      onRefresh: () {
                        _accountBloc.getDataByType(context, _accountBloc.eventModel.collectionType, isRefresh: true);
                      },
                      header: ClassicHeader(),
                      child: CustomScrollView(
                        slivers: widgets,
                      ),
                    );
                  }),
            ),
            Positioned(
              top: Density.instance.dp(19),
              right: Density.instance.dp(30),
              child: Container(
                width: Density.instance.dp(50),
                height: Density.instance.dp(50),
                child: Image.asset(
                  ImageUtil.getImagePath("ic_setting"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
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
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: Density.instance.dp(4)),
            borderRadius: BorderRadius.circular(Density.instance.dp(80)),
          ),
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
                borderRadius: BorderRadius.all(Radius.circular(Density.instance.dp(8))),
              ),
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

    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        height: Density.instance.dp(270),
        color: ColorRes.ACCOUNT_PAGE_TOP_BG,
        child: Stack(
          children: widgets,
        ),
      ),
    );
  }

  //构建吸顶部分
  Widget _buildStickyBar(BuildContext context, COLLECTION_TYPE choiceType, int size) {
    List<Widget> widgets = <Widget>[];

    //左侧描述文案
    widgets.add(Text(
      _accountBloc.getTypeDesc(choiceType),
      style: TextStyle(
        color: ColorRes.TEXT_NORMAL,
        fontSize: Density.instance.sp(26),
      ),
    ));
    widgets.add(Padding(
      padding: EdgeInsets.only(left: Density.instance.dp(8)),
      child: Text(
        "$size",
        style: TextStyle(
          color: ColorRes.TEXT_GRAY,
          fontSize: Density.instance.sp(26),
        ),
      ),
    ));

    widgets.add(Expanded(child: Container()));

    //中间类型
    List<Widget> typeWidgets = <Widget>[];
    typeWidgets.add(_buildTypeButton(context, COLLECTION_TYPE.WANT_LOOK, choiceType == COLLECTION_TYPE.WANT_LOOK));
    typeWidgets.add(_buildTypeButton(context, COLLECTION_TYPE.LOOKING, choiceType == COLLECTION_TYPE.LOOKING));
    typeWidgets.add(_buildTypeButton(context, COLLECTION_TYPE.SEEN, choiceType == COLLECTION_TYPE.SEEN));
    widgets.add(Padding(
      padding: EdgeInsets.only(right: Density.instance.dp(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Density.instance.dp(35)),
        child: Container(
          height: Density.instance.dp(60),
          width: Density.instance.dp(270),
          color: ColorRes.WINDOW_BG,
          child: Row(
            children: typeWidgets,
          ),
        ),
      ),
    ));

    //右侧分割线
    widgets.add(Container(
      width: Density.instance.dp(1),
      height: Density.instance.dp(50),
      color: ColorRes.LINE,
    ));

    //筛选部分
    widgets.add(
      Container(
        width: Density.instance.dp(50),
        height: Density.instance.dp(30),
        padding: EdgeInsets.only(
          left: Density.instance.dp(20),
        ),
        child: Image.asset(
          ImageUtil.getImagePath("ic_screen"),
          fit: BoxFit.fill,
        ),
      ),
    );
    widgets.add(GestureDetector(
      onTap: () {
        Fluttertoast.showToast(msg: "筛选功能正在开发中");
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: Density.instance.dp(8),
        ),
        child: Text(
          "筛选",
          style: TextStyle(
            color: ColorRes.TEXT_HAVY,
            fontSize: Density.instance.sp(28),
          ),
        ),
      ),
    ));

    return Container(
      width: double.infinity,
      height: Density.instance.dp(100),
      padding: EdgeInsets.only(
        left: Density.instance.dp(25),
        right: Density.instance.dp(25),
      ),
      color: Colors.white,
      child: Row(
        children: widgets,
      ),
    );
  }

  //创建类型按钮
  Widget _buildTypeButton(BuildContext context, COLLECTION_TYPE type, bool checked) {
    _choiceCollectionType() {
      _accountBloc.setCollection(type);
      _accountBloc.getDataByType(context, type);
    }

    Widget child;
    if (checked) {
      child = Container(
        width: Density.instance.dp(90),
        height: Density.instance.dp(60),
        decoration: BoxDecoration(
          border: Border.all(width: Density.instance.dp(2), color: ColorRes.LINE),
          borderRadius: BorderRadius.all(Radius.circular(Density.instance.dp(30))),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Density.instance.dp(30)),
          child: Container(
            color: Colors.white,
            child: Center(
              child: Text(
                _accountBloc.getTypeDesc(type),
                style: TextStyle(color: ColorRes.TEXT_NORMAL, fontSize: Density.instance.sp(26)),
              ),
            ),
          ),
        ),
      );
    } else {
      child = Container(
        width: Density.instance.dp(90),
        height: Density.instance.dp(60),
        child: Center(
          child: Text(
            _accountBloc.getTypeDesc(type),
            style: TextStyle(color: ColorRes.TEXT_GRAY, fontSize: Density.instance.sp(26)),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: _choiceCollectionType,
      child: child,
    );
  }
}

///底部列表
class _ButtomList extends StatelessWidget {
  List<SubjectsModel> subjects;

  _ButtomList(this.subjects);

  @override
  Widget build(BuildContext context) {
    return _buildList(subjects);
  }

  //构建底部列表
  Widget _buildList(List<SubjectsModel> subjects) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            color: Colors.white,
            child: index < subjects.length ? _buildItem(subjects[index]) : _buildFooter(),
          );
        },
        childCount: subjects.length > 0 ? subjects.length + 1 : 0,
      ),
    );
  }

  //创建 item
  Widget _buildItem(SubjectsModel data) {
    if (data == null) data = SubjectsModel();
    String title = data.title != null ? data.title : "未知标题";
    String imgSrc = data.images == null ? "" : data.images.small ?? "";

    StringBuffer msg = StringBuffer();
    msg.write(data.year != null ? "${data.year} / " : "");
    if (data.pubdates != null) {
      data.pubdates.forEach((value) {
        msg.write("$value ");
      });
      msg.write("/ ");
    }
    if (data.genres != null) {
      data.genres.forEach((value) {
        msg.write("$value ");
      });
      msg.write("/ ");
    }
    if (data.directors != null) {
      data.directors.forEach((value) {
        if (value.name != null) {
          msg.write("${value.name} /");
        }
      });
    }
    String msgStr = msg.toString();
    if (msgStr.endsWith("/")) {
      msgStr = msgStr.substring(0, msgStr.length - 1);
    }

    return _buildItemWidget(data, title, imgSrc, msgStr);
  }

  //构建 item 控件
  Widget _buildItemWidget(SubjectsModel data, String title, String imgSrc, String msgStr) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              left: Density.instance.dp(25),
              right: Density.instance.dp(25),
              top: Density.instance.dp(30),
              bottom: Density.instance.dp(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildItemLeftImg(imgSrc),
              Expanded(child: _buildItemCenterMsg(data, title, msgStr)),
            ],
          ),
        ),
        Container(
          color: ColorRes.LINE,
          height: Density.instance.dp(1),
        )
      ],
    );
  }

  //绘制 item 左边图片
  Widget _buildItemLeftImg(String imgSrc) {
    return Container(
      width: Density.instance.dp(160),
      height: Density.instance.dp(230),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Density.instance.dp(8)),
        child: CachedNetworkImage(
          imageUrl: imgSrc,
          placeholder: (context, url) => ImgPlaceHolder(),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  //构建 item 中间信息
  Widget _buildItemCenterMsg(SubjectsModel data, String title, String msgStr) {
    return Padding(
      padding: EdgeInsets.only(left: Density.instance.dp(26), right: Density.instance.dp(10)),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  TextStyle(color: ColorRes.TEXT_HAVY, fontSize: Density.instance.sp(32), fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: Density.instance.dp(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  StaticRatingBar(
                    rate: data.rating.average / 2,
                    size: Density.instance.dp(24),
                    colorDark: ColorRes.TEXT_GRAY,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Density.instance.dp(10)),
                    child: Text(
                      "${data.rating.average}",
                      style: TextStyle(color: ColorRes.TEXT_GRAY, fontSize: Density.instance.sp(26)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Density.instance.dp(20)),
              child: Text(
                msgStr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: ColorRes.TEXT_GRAY, fontSize: Density.instance.sp(22)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //底部没有更多了
  Widget _buildFooter() {
    return Container(
      height: Density.instance.dp(60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: ColorRes.LINE,
            height: Density.instance.dp(1),
            width: Density.instance.dp(30),
          ),
          Padding(
              padding: EdgeInsets.only(left: Density.instance.dp(15), right: Density.instance.dp(15)),
              child: Text(
                "THE END",
                style: TextStyle(color: ColorRes.LINE, fontSize: Density.instance.dp(22)),
              )),
          Container(
            color: ColorRes.LINE,
            height: Density.instance.dp(1),
            width: Density.instance.dp(30),
          ),
        ],
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
