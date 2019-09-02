import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_sample/index/index.dart';

///找片中的电影
class FindMoviePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FindMovieBloc _findMovieBloc = BlocProvider.of<FindMovieBloc>(context);

    if (_findMovieBloc.movieModel == null) {
      Timer(Duration(milliseconds: 50), () {
        _findMovieBloc.getNewMovieListMovies();
      });
    }

    List<Widget> widgets = <Widget>[];

    //顶部类型
    widgets.add(SliverToBoxAdapter(
      child: FindTabWidget(
        isTv: false,
        onTabClick: (FIND_TYPE type) {
          Fluttertoast.showToast(msg: type.toString());
        },
      ),
    ));
    //底部列表
    widgets.add(SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          left: Density.instance.dp(30),
          top: Density.instance.dp(30),
        ),
        child: Text(
          "新片榜",
          style: TextStyle(color: ColorRes.TEXT_HAVY, fontSize: Density.instance.sp(36)),
        ),
      ),
    ));
    widgets.add(StreamBuilder(
        initialData: _findMovieBloc.movieModel,
        stream: _findMovieBloc.newMovieListStream,
        builder: (BuildContext context, AsyncSnapshot<MovieModel> snapshot) {
          MovieModel model = snapshot.data;
          List<SubjectsModel> subjects = (model == null || model.subjects == null) ? <SubjectsModel>[] : model.subjects;
          return _ButtomList(subjects);
        }));

    return StreamBuilder(
      initialData: LoadingState.success,
      stream: _findMovieBloc.loadingStream,
      builder: (BuildContext context, AsyncSnapshot<LoadingState> snapshot) {
        return LoadingView(
          state: snapshot.data,
          contentWidget: Container(
            color: Colors.white,
            child: CustomScrollView(
              slivers: widgets,
            ),
          ),
        );
      },
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
