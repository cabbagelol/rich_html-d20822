import 'package:flutter/material.dart';

import 'rich-html.dart';
import 'rich-html-theme.dart';

class RichHtmlToolbar extends StatefulWidget {
  final List<RichHtmlTool> children;
  final RichHtmlController controller;

  RichHtmlToolbar(
    this.controller, {
    @required this.children,
  });

  @override
  _RichHtmlToolbarState createState() => _RichHtmlToolbarState();
}

class _RichHtmlToolbarState extends State<RichHtmlToolbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.children.forEach((RichHtmlTool e) {
      e.controller = widget.controller;
    });
    return Row(children: widget.children);
  }
}

class RichHtmlTool extends StatelessWidget {
  final Widget child;
  final int flex;
  final bool disable;

  RichHtmlTool({
    this.child,
    this.flex = 0,
    this.disable = false,
  });

  @override
  RichHtmlController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Opacity(
        opacity: disable ?? false ? 0.2 : 1,
        child: this.child,
      ),
    );
  }
}

/// 文字
class RichHtmlToolText extends StatelessWidget implements RichHtmlTool {
  final Widget child;
  final Color color;
  final String tooltip;
  final Function onTap;
  final int flex;
  final bool disable;

  RichHtmlToolText({
    this.child,
    this.color,
    this.tooltip,
    Function onTap,
    int flex = 0,
    this.disable,
  })  : onTap = onTap ?? null,
        flex = flex ?? 0;

  @override
  Widget build(BuildContext context) {
    return RichHtmlTool(
      child: IconButton(
        icon: this.child ??
            Icon(
              Icons.text_fields,
              color: color ?? controller.theme.mainColor,
            ),
        tooltip: tooltip ?? '文字',
        onPressed: () async {
          onTap();
          if (disable) {
            return null;
          } else {
            return () {};
          }
        },
      ),
      flex: flex,
      disable: disable,
    );
  }

  @override
  RichHtmlController controller;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// 图片
class RichHtmlToolImages extends StatelessWidget implements RichHtmlTool {
  final Widget child;
  final Color color;
  final String tooltip;
  final Function onTap;
  final int flex;
  final bool disable;

  RichHtmlToolImages({
    this.child,
    this.color,
    this.tooltip,
    Function onTap,
    this.flex,
    this.disable = false,
  }) : onTap = onTap ?? null;

  @override
  Widget build(BuildContext context) {
    return RichHtmlTool(
      child: this.child ??
          IconButton(
            icon: Icon(
              Icons.image,
              color: color ?? controller.theme.mainColor,
            ),
            tooltip: tooltip ?? "插入图片",
            onPressed: () async {
              if (disable) {
                return null;
              } else {
                if (controller.textSelection != null && controller.textSelection.baseOffset == controller.textSelection.extentOffset) {
                  String path = await this.controller.insertImage();
                  if (path != null) {
                    controller
                      ..html = controller.html.substring(
                        0,
                        controller.textSelection.baseOffset,
                      ) +
                          '<img src="$path" />' +
                          controller.html.substring(
                            controller.textSelection.baseOffset,
                            controller.html.length,
                          );

                    controller.updateWidget(controller.html);
                  }
                }
                return () {};
              }
            },
          ),
      flex: flex,
      disable: disable,
    );
  }

  @override
  var controller;
}

/// 多媒体
class RichHtmlToolVideo extends StatelessWidget implements RichHtmlTool {
  final Widget child;
  final Color color;
  final tooltip;
  final Function onTap;
  final int flex;
  final bool disable;

  RichHtmlToolVideo({
    this.child,
    this.color,
    this.tooltip,
    Function onTap,
    this.flex,
    this.disable,
  }) : onTap = onTap ?? null;

  @override
  Widget build(BuildContext context) {
    return RichHtmlTool(
      child: GestureDetector(
        onTap: () async {
          if (controller.textSelection != null && controller.textSelection.baseOffset == controller.textSelection.extentOffset) {
            String path = await this.controller.insertVideo();
            if (path != null) {
              controller
                ..html = controller.html.substring(
                      0,
                      controller.textSelection.baseOffset,
                    ) +
                    '<video src="$path" />' +
                    controller.html.substring(
                      controller.textSelection.baseOffset,
                      controller.html.length,
                    );

              controller.updateWidget(controller.html);
            }
          }
        },
        child: this.child ??
            IconButton(
              icon: Icon(
                Icons.videocam,
                color: color ?? controller.theme.mainColor,
              ),
              tooltip: tooltip ?? "插入视频",
            ), //
      ),
      flex: flex,
      disable: disable,
    );
  }

  @override
  var controller;
}

/// 清理文档内容
class RichEditToolClear extends StatelessWidget implements RichHtmlTool {
  final Color disabledColor;
  final Color color;
  final tooltip;
  final Function onTap;
  Future<bool> onClear;
  final int flex;
  final bool disable;

  RichEditToolClear({
    this.disabledColor,
    this.color,
    this.tooltip,
    Function onTap,
    this.onClear,
    this.flex = 0,
    this.disable,
  }) : onTap = onTap ?? null;

  VoidCallback _onClearTap() {
//    onTap();
    if (controller.text != null || controller.text.length > 0) {
      controller.clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> onClear () async {
      return this.onClear;
    };

    return Row(
      children: [
        RichHtmlTool(
          child: IconButton(
            disabledColor: disabledColor ?? Colors.black12,
            color: color ?? controller.theme.mainColor,
            icon: Icon(
              Icons.delete,
              color: color ?? controller.theme.mainColor,
            ),
            onPressed: () async {
              var _alert = await onClear();
              print("_alert $_alert");
              if (_alert) {
                _onClearTap();
              }
            },
            tooltip: tooltip ?? '清理',
          ),
          flex: flex,
          disable: disable,
        ),
      ],
    );
  }

  @override
  var controller;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// 键盘开关
class RichHtmlToolKeyboardSwitch extends StatelessWidget implements RichHtmlTool, WidgetsBindingObserver {
  final BuildContext context;
  final Color disabledColor;
  final Color color;
  final tooltip;
  final int flex;
  final bool disable;

  bool stitc = false;

  RichHtmlToolKeyboardSwitch(
    this.context, {
    this.disabledColor,
    this.color,
    this.tooltip,
    this.flex = 0,
    this.disable,
  });

  _getBtn1ClickListener() {
    if (!stitc) {
      return () {
//        FocusScope.of(context).requestFocus(FocusNode());
      };
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext contextT) {
//    stitc = MediaQuery.of(context).viewInsets.bottom == 0;

    return RichHtmlTool(
      child: IconButton(
        disabledColor: disabledColor ?? Colors.black12,
        color: color ?? RichHtmlTheme().mainColor,
        icon: Icon(
          !stitc ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
          color: color ?? controller.theme.mainColor,
        ),
        onPressed: _getBtn1ClickListener(),
        tooltip: tooltip ?? "键盘",
      ),
      flex: flex,
      disable: disable,
    );
  }

  @override
  var controller;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// SizedBox
class RichHtmlToolSizedBox extends StatelessWidget implements RichHtmlTool {
  final num width;
  final int flex;
  final Widget child;
  final bool disable;

  RichHtmlToolSizedBox({
    this.width,
    this.child,
    this.flex,
    this.disable,
  });

  @override
  Widget build(BuildContext context) {
    return RichHtmlTool(
      child: SizedBox(
        width: width,
        child: child,
      ),
      flex: flex,
      disable: disable,
    );
  }

  @override
  var controller;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
