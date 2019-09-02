import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';
import 'package:fluttertoast/fluttertoast.dart';

///搜索控件
class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Fluttertoast.showToast(msg: "搜索页面正在开发中");
      },
      child: SizedBox.expand(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Density.instance.dp(8)),
          child: Container(
            color: ColorRes.WINDOW_BG,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: Density.instance.dp(28),
                  height: Density.instance.dp(28),
                  child: Image.asset(ImageUtil.getImagePath("ic_seach"), fit: BoxFit.fill),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Density.instance.dp(10)),
                  child: Text(
                    "电影/电视剧/影人",
                    style: TextStyle(color: ColorRes.TEXT_GRAY, fontSize: Density.instance.sp(26)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
