import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';

///类型
enum FIND_TYPE {
  //找电影
  FIND_MOVIE,
  //豆瓣榜单
  MOVIE_LIST,
  //豆瓣猜
  GUSS,
  //豆瓣片单
  MOVIE_SHEET,
  //播出时间表
  PLAY_TIME
}

///找片中的顶部类型控件
class FindTabWidget extends StatelessWidget {
  final ValueChanged<FIND_TYPE> onTabClick;
  final bool isTv;

  FindTabWidget({this.onTabClick, this.isTv});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    widgets.add(_buildItem(FIND_TYPE.FIND_MOVIE, "ic_find_movie", Color.fromARGB(255, 116, 148, 233)));
    widgets.add(_buildItem(FIND_TYPE.MOVIE_LIST, "ic_movie_list", Color.fromARGB(255, 243, 183, 89)));
    widgets.add(_buildItem(FIND_TYPE.GUSS, "ic_guess", Color.fromARGB(255, 126, 198, 105)));
    if (isTv) {
      widgets.add(_buildItem(FIND_TYPE.PLAY_TIME, "ic_play_time", Color.fromARGB(255, 115, 196, 168)));
    } else {
      widgets.add(_buildItem(FIND_TYPE.MOVIE_SHEET, "ic_movie_sheet", Color.fromARGB(255, 131, 112, 209)));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widgets,
    );
  }

  Widget _buildItem(FIND_TYPE type, String icName, Color bgColor) {
    String msg;
    switch (type) {
      case FIND_TYPE.FIND_MOVIE:
        msg = "找电影";
        break;
      case FIND_TYPE.MOVIE_LIST:
        msg = "豆瓣榜单";
        break;
      case FIND_TYPE.GUSS:
        msg = "豆瓣猜";
        break;
      case FIND_TYPE.MOVIE_SHEET:
        msg = "豆瓣片单";
        break;
      case FIND_TYPE.PLAY_TIME:
        msg = "播出时间表";
        break;
    }

    return GestureDetector(
      onTap: () {
        onTabClick(type);
      },
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: Density.instance.dp(30)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Density.instance.dp(80)),
              child: Container(
                width: Density.instance.dp(80),
                height: Density.instance.dp(80),
                color: bgColor,
                child: Center(
                  child: Container(
                    width: Density.instance.dp(40),
                    height: Density.instance.dp(40),
                    child: Image.asset(ImageUtil.getImagePath(icName)),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Density.instance.dp(10)),
            child: Text(
              msg,
              style: TextStyle(color: ColorRes.TEXT_GRAY, fontSize: Density.instance.sp(26)),
            ),
          ),
        ],
      ),
    );
  }
}
