import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_sample/index/index.dart';

class FindTvPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FindTvBloc _findMovieBloc = BlocProvider.of<FindTvBloc>(context);

    return StreamBuilder(
      initialData: LoadingState.success,
      stream: _findMovieBloc.loadingStream,
      builder: (BuildContext context, AsyncSnapshot<LoadingState> snapshot) {
        return LoadingView(
          state: snapshot.data,
          contentWidget: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                FindTabWidget(
                  isTv: true,
                  onTabClick: (FIND_TYPE type) {
                    Fluttertoast.showToast(msg: type.toString());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
