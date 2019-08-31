import 'package:flutter/material.dart';

class PreferredSizeContainer extends Container implements PreferredSizeWidget {
  final double height;

  PreferredSizeContainer({this.height, Widget child}) : super(child: child);

  @override
  Size get preferredSize => Size.fromHeight(height);
}
