import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///正在热播
class HotPlayPage extends StatelessWidget {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  HotPlayBloc _hotPlayBloc;

  void _refresh() {
    _hotPlayBloc.getHotPlayData();
  }

  @override
  Widget build(BuildContext context) {
    _hotPlayBloc = BlocProvider.of<HotPlayBloc>(context);
    if (_hotPlayBloc.hotPlayModel == null) {
      _hotPlayBloc.getHotPlayData();
    }

    return StreamBuilder(
        initialData: _hotPlayBloc.hotPlayModel == null ? LoadingState.loading : LoadingState.success,
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
                initialData: _hotPlayBloc.hotPlayModel,
                stream: _hotPlayBloc.hotPlayDataStream,
                builder: (BuildContext context, AsyncSnapshot<HotPlayModel> snapshot) {
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
                                    ? _buildItem(snapshot.data.subjects[index])
                                    : _buildFooter();
                              },
                            ),
                          )),
                    ),
                  );
                }),
            allRetryListener: () {
              _hotPlayBloc.setLoadingState(LoadingState.loading);
              _hotPlayBloc.getHotPlayData();
            },
          );
        });
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
              Container(
                width: Density.instance.dp(160),
                height: Density.instance.dp(230),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Density.instance.dp(8)),
                  child: Image.network(
                    imgSrc,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
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
                        style: TextStyle(
                            color: ColorRes.TEXT_HAVY, fontSize: Density.instance.sp(30), fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Density.instance.dp(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            StaticRatingBar(
                              rate: data.rating.average / 2,
                              size: Density.instance.dp(22),
                              colorDark: ColorRes.TEXT_GRAY,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: Density.instance.dp(10)),
                              child: Text(
                                "${data.rating.average}",
                                style: TextStyle(color: ColorRes.TEXT_GRAY, fontSize: Density.instance.sp(20)),
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
                          style: TextStyle(color: ColorRes.TEXT_GRAY, fontSize: Density.instance.sp(20)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: Density.instance.dp(230),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            width: Density.instance.dp(100),
                            height: Density.instance.dp(50),
                            decoration: BoxDecoration(
                                border: Border.all(width: Density.instance.dp(1), color: ColorRes.TEXT_RED),
                                borderRadius: BorderRadius.all(Radius.circular(Density.instance.dp(5)))),
                            child: Center(
                              child: Text(
                                "购票",
                                style: TextStyle(color: ColorRes.TEXT_RED),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: Density.instance.dp(10)),
                          child: Text(
                            "1.4万人看过",
                            style: TextStyle(color: ColorRes.LINE, fontSize: Density.instance.dp(18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
