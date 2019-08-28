import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';

class SoonPlayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoadingView(
      contentWidget: Text("即将上映"),
      state: LoadingState.loading,
    );
  }
}
