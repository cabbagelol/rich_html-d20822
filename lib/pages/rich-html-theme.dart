// this theme

import 'package:flutter/material.dart';

class RichHtmlTheme {
  final Color mainColor;

  /// 视图
  final RichHtmlViewTheme viewTheme;

  /// 工具菜单
  final RichHtmlToolbarTheme toolbarTheme;

  RichHtmlTheme({
    this.viewTheme,
    this.toolbarTheme,
    this.mainColor = Colors.black,
  });
}

class RichHtmlViewTheme {
  /// 背景
  final Color color;

  RichHtmlViewTheme({
    this.color = const Color(0xfff2f2f2),
  });
}


class RichHtmlToolbarTheme {
  /// 背景
  final Color color;
  final double disabledToolOpacity;
  final double toolOpacity;
  final Color disabledToolIconColor;
  final Color toolIconColor;

  RichHtmlToolbarTheme({
    this.color = Colors.white,
    this.disabledToolOpacity = .3,
    this.toolOpacity = 1.0,
    this.disabledToolIconColor = Colors.black54,
    this.toolIconColor = Colors.black,
  });
}
