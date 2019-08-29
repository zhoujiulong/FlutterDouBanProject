import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SoonPlayPage extends StatelessWidget {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  SoonPlayBloc _hotPlayBloc;

  void _refresh() {
    _hotPlayBloc.getSoonPlayData();
  }

  @override
  Widget build(BuildContext context) {
    _hotPlayBloc = BlocProvider.of<SoonPlayBloc>(context);
    if (_hotPlayBloc.musicModel == null) {
      _hotPlayBloc.getSoonPlayData();
    }

    return StreamBuilder(
        initialData: _hotPlayBloc.musicModel == null ? LoadingState.loading : LoadingState.success,
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
                initialData: _hotPlayBloc.musicModel,
                stream: _hotPlayBloc.soonPlayStream,
                builder: (BuildContext context, AsyncSnapshot<MusicModel> snapshot) {
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
                            child: ListView.builder(
                              itemCount: snapshot.data.subjects.length + 1,
                              padding: EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                return index < snapshot.data.subjects.length
                                    ? _buildItem(snapshot.data.subjects, index)
                                    : _buildFooter();
                              },
                            ),
                          )),
                    ),
                  );
                }),
            allRetryListener: () {
              _hotPlayBloc.setLoadingState(LoadingState.loading);
              _hotPlayBloc.getSoonPlayData();
            },
          );
        });
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

    bool showTopYear = index == 0 ||
        (data.pubdates != null &&
            list[index - 1].pubdates != null &&
            list[index - 1].pubdates[0].substring(0, list[index - 1].pubdates[0].indexOf("(")) !=
                data.pubdates[0].substring(0, data.pubdates[0].indexOf("(")));

    return _buildItemView(list, data, index, title, msgStr, imgSrc, showTopYear);
  }

  //构建 item 控件
  Widget _buildItemView(List<SubjectsModel> list, SubjectsModel data, int index, String title, String msgStr,
      String imgSrc, bool showTopYear) {
    List<Widget> childers = <Widget>[];
    //判断是否显示年份标题
    if (showTopYear) {
      childers.add(_buildItemTopYear(data));
    }
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
  Widget _buildItemTopYear(SubjectsModel data) {
    return Container(
      height: Density.instance.dp(60),
      width: double.infinity,
      color: ColorRes.WINDOW_BG,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: Density.instance.dp(25)),
        child: Text(
          data.pubdates[0].substring(0, data.pubdates[0].indexOf("(")),
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
