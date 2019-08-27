import 'package:flutter/material.dart';
import 'package:movie_sample/index/widget_index.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MYAppBar(
        "我的",
        showBack: false,
      ),
      backgroundColor: Colors.white,
      body: LoadingView(
        contentWidget: Text("account"),
        state: LoadingState.success,
      ),
    );
  }
}
