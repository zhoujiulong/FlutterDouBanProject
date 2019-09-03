import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:movie_sample/index/index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///即将上映
class SoonPlayPage extends StatelessWidget {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  SoonPlayBloc _hotPlayBloc;

  void _refresh() {
    _hotPlayBloc.getSoonPlayData();
  }

  @override
  Widget build(BuildContext context) {
    _hotPlayBloc = BlocProvider.of<SoonPlayBloc>(context);
    if (_hotPlayBloc.movieModel == null) {
      _hotPlayBloc.getSoonPlayData();
    }

    return StreamBuilder(
        initialData: _hotPlayBloc.movieModel == null ? LoadingState.loading : LoadingState.success,
        stream: _hotPlayBloc.loadingStream,
        builder: (BuildContext context, AsyncSnapshot<LoadingState> snapshot) {
          if (snapshot.data == LoadingState.success) {
            _refreshController.refreshCompleted();
          } else {
            _refreshController.refreshFailed();
          }
          return LoadingView(
            state: snapshot.data,
            contentWidget: StreamBuilder(
                initialData: _hotPlayBloc.movieModel,
                stream: _hotPlayBloc.soonPlayStream,
                builder: (BuildContext context, AsyncSnapshot<MovieModel> snapshot) {
                  return _buildContentView(context, snapshot);
                }),
            allRetryListener: () {
              _hotPlayBloc.setLoadingState(LoadingState.loading);
              _hotPlayBloc.getSoonPlayData();
            },
          );
        });
  }

  //创建列表布局
  Widget _buildContentView(BuildContext context, AsyncSnapshot<MovieModel> snapshot) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Container(
        color: Colors.white,
        child: ScrollConfiguration(
            behavior: MyScrollBehavior(),
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _refresh,
              header: ClassicHeader(),
              child: _buildListView(snapshot.data.subjects),
            )),
      ),
    );
  }

  //创建列表
  Widget _buildListView(List<SubjectsModel> subjects) {
    Map<String, List<SubjectsModel>> yearItem = Map<String, List<SubjectsModel>>();
    subjects.forEach((SubjectsModel data) {
      String year = data.pubdates[0].substring(0, data.pubdates[0].indexOf("("));
      List<SubjectsModel> itemList;
      if (yearItem.containsKey(year)) {
        itemList = yearItem[year];
      } else {
        itemList = List<SubjectsModel>();
        yearItem[year] = itemList;
      }
      itemList.add(data);
    });

    List<Widget> widgets = List<Widget>();
    Iterable<String> keys = yearItem.keys;
    for (int i = 0; i < keys.length; i++) {
      String key = keys.elementAt(i);
      widgets.add(_buildSliverSticky(key, yearItem[key], i == keys.length - 1));
    }

    return CustomScrollView(
      slivers: widgets,
    );
  }

  //创建分组
  Widget _buildSliverSticky(String year, List<SubjectsModel> items, bool isLast) {
    return SliverStickyHeaderBuilder(
      builder: (context, state) => _buildItemTopYear(year),
      sliver: new SliverList(
        delegate: new SliverChildBuilderDelegate(
          (context, i) => isLast && i == items.length ? NoMoreWidget() : _buildItem(items, i),
          childCount: isLast ? items.length + 1 : items.length,
        ),
      ),
    );
  }

  //创建 item
  Widget _buildItem(List<SubjectsModel> list, int index) {
    SubjectsModel data = list[index];

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
    return _buildItemView(list, data, index, title, msgStr, imgSrc);
  }

  //构建 item 控件
  Widget _buildItemView(
      List<SubjectsModel> list, SubjectsModel data, int index, String title, String msgStr, String imgSrc) {
    List<Widget> childers = <Widget>[];
    childers.add(Padding(
      padding: EdgeInsets.only(
          left: Density.instance.dp(25),
          right: Density.instance.dp(25),
          top: Density.instance.dp(30),
          bottom: Density.instance.dp(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildItemImg(imgSrc),
          _buildItemCenterMsg(title, msgStr),
          _buildItemRightMsg(),
        ],
      ),
    ));
    childers.add(Container(
      color: ColorRes.LINE,
      height: Density.instance.dp(1),
    ));

    return Column(
      children: childers,
    );
  }

  //item 顶部年份
  Widget _buildItemTopYear(String year) {
    return Container(
      height: Density.instance.dp(60),
      width: double.infinity,
      color: ColorRes.WINDOW_BG,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: Density.instance.dp(25)),
        child: Text(
          year,
          style: TextStyle(color: ColorRes.TEXT_GRAY, fontSize: Density.instance.sp(28)),
        ),
      ),
    );
  }

  //item 左侧图片
  Widget _buildItemImg(String imgSrc) {
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

  //item 中间信息
  Widget _buildItemCenterMsg(String title, String msgStr) {
    return Padding(
      padding: EdgeInsets.only(left: Density.instance.dp(26), right: Density.instance.dp(10)),
      child: Container(
        width: Density.instance.dp(360),
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
              child: Text(
                msgStr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: ColorRes.TEXT_GRAY, fontSize: Density.instance.sp(26)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //item 右侧信息
  Widget _buildItemRightMsg() {
    return Expanded(
      child: Container(
        height: Density.instance.dp(230),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: Density.instance.dp(35),
                height: Density.instance.dp(35),
                child: Image.asset(
                  ImageUtil.getImagePath("ic_want_look"),
                  fit: BoxFit.fill,
                ),
              ),
              Text(
                "想看",
                style: TextStyle(color: ColorRes.YELLOW, fontSize: Density.instance.sp(26)),
              ),
              Padding(
                padding: EdgeInsets.only(top: Density.instance.dp(15)),
                child: Text(
                  "1.4万人看过",
                  style: TextStyle(color: ColorRes.LINE, fontSize: Density.instance.sp(22)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
