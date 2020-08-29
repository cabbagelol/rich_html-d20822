import 'package:flutter/material.dart';

import 'rich-html.dart';
import 'rich-html-theme.dart';

enum RichHtmlToolbartype { KEYBOAR, BOX, TEXT, IMAGE, VIDEO, CLEAR }

class RichHtmlToolbar extends StatefulWidget {
  final List<RichHtmlTool> children;
  final RichHtmlController controller;

  RichHtmlToolbar(
    this.controller, {
    @required this.children,
  });

  @override
  StatefulElement createElement() {
    controller.richhtmltoolbarController = children;

    return super.createElement();
  }

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

abstract class RichHtmlEvents {
  SpecialText();

  @override
  String onTap() {
    this.onTap();
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
  RichHtmlToolbartype type = RichHtmlToolbartype.TEXT;

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
    this.disable = false,
  })  : onTap = onTap ?? null,
        flex = flex ?? 0;

  @override
  Widget build(BuildContext context) {
    return RichHtmlTool(
      child: IconButton(
        icon: this.child ??
            Icon(
              Icons.text_fields,
              color: color ?? controller.theme?.mainColor ?? Theme.of(context).splashColor,
            ),
        tooltip: tooltip ?? '文字',
        onPressed: () async {
          onTap?.call(type);

          if (disable) {
            return null;
          }

          if (controller.textSelection != null && controller.textSelection.baseOffset == controller.textSelection.extentOffset) {
            String text = await this.controller.insertText();
            controller
              ..html = controller.html.substring(0, controller.textSelection.baseOffset) +
                  text +
                  controller.html.substring(controller.textSelection.baseOffset, controller.html.length);

            controller.updateWidget(controller.html);
          }
          return () {};
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
  RichHtmlToolbartype type = RichHtmlToolbartype.IMAGE;

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
              color: color ?? controller.theme?.mainColor ?? Theme.of(context).splashColor,
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
  RichHtmlController controller;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// 多媒体
class RichHtmlToolVideo extends StatelessWidget implements RichHtmlTool {
  RichHtmlToolbartype type = RichHtmlToolbartype.VIDEO;

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
                color: color ?? controller.theme?.mainColor ?? Theme.of(context).primaryColor,
              ),
              tooltip: tooltip ?? null,
            ), //
      ),
      flex: flex,
      disable: disable,
    );
  }

  @override
  RichHtmlController controller;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// 清理文档内容
class RichEditToolClear extends StatelessWidget implements RichHtmlTool {
  RichHtmlToolbartype type = RichHtmlToolbartype.CLEAR;

  final Widget child;
  final Icons icon;
  final Color disabledColor;
  final Color color;
  final String tooltip;
  final Function onTap;
  final bool onClear;
  final int flex;
  final bool disable;

  double animatedOpacity = 1.0;

  RichEditToolClear({
    this.child,
    this.icon,
    this.disabledColor = Colors.red,
    this.color,
    this.tooltip,
    Function onTap,
    this.onClear,
    this.flex = 0,
    this.disable = false,
  })  : onTap = onTap ?? null,
        assert(
          child == null && icon == null,
          'child和icon不应当共存，当chile存有widget，icon会被完全覆盖.',
        );

  @override
  StatelessElement createElement() {
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    bool onClear() => this.onClear;

    return Row(
      children: [
        RichHtmlTool(
          child: child ??
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  controller.controller.addListener(() {
                    if (disable || controller.controller.text.length <= 0 || controller.controller.text == null) {
                      setState(() {
                        this.animatedOpacity = .3;
                      });
                    } else {
                      setState(() {
                        this.animatedOpacity = 1.0;
                      });
                    }
                  });

                  onPressed() {
                    if (disable) {
                      return null;
                    }

                    return () {
                      if (onClear()) {
                        onTap?.call(type);
                        if (controller.controller.text != null || controller.controller.text.length > 0) {
                          controller.clearAll();
                        }
                      }
                    };
                  }

                  return AnimatedOpacity(
                    opacity: this.animatedOpacity,
                    duration: Duration(milliseconds: 300),
                    child: IconButton(
                      color: color ?? controller.theme?.mainColor ?? Theme.of(context).primaryColor,
                      icon: Icon(
                        icon ?? Icons.delete,
                        color: color ?? controller.theme?.mainColor ?? Theme.of(context).primaryColor,
                      ),
                      onPressed: onPressed(),
                      tooltip: tooltip ?? null,
                    ),
                  );
                },
              ),
          flex: flex,
          disable: disable,
        ),
      ],
    );
  }

  @override
  RichHtmlController controller;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// 键盘开关
/// 操作虚拟键盘
class RichHtmlToolKeyboardSwitch extends StatelessWidget implements RichHtmlTool, WidgetsBindingObserver {
  RichHtmlToolbartype type = RichHtmlToolbartype.KEYBOAR;

  final BuildContext context;
  final Color color;
  final String tooltip;
  final int flex;
  final bool disable;

  Function upState;

  RichHtmlToolKeyboardSwitch(
    this.context, {
    this.color,
    this.tooltip,
    this.flex = 0,
    this.disable = false,
  });

  _getBtn1ClickListener() {
    if (!(controller.hasFocus ?? false)) {
      return null;
    }

    return () {
      controller.blur();
    };
  }

  @override
  Widget build(BuildContext contextT) {
    return RichHtmlTool(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          upState = () => {setState(() => null)};

          return AnimatedOpacity(
            opacity: (controller.hasFocus ?? false) ? 1.0 : .3,
            duration: Duration(microseconds: 300),
            child: IconButton(
              color: color ?? controller.theme?.mainColor ?? Theme.of(context).primaryColor,
              icon: Icon(
                (controller.hasFocus ?? false) ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                color: color ?? controller.theme?.mainColor ?? Theme.of(context).primaryColor,
              ),
              onPressed: _getBtn1ClickListener(),
              tooltip: tooltip ?? null,
            ),
          );
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

/// 占位
/// 设计用于占用空间，当然也可以同时填充内容；这类似于SizedBox控件
class RichHtmlToolSizedBox extends StatelessWidget implements RichHtmlTool {
  RichHtmlToolbartype type = RichHtmlToolbartype.BOX;

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
  RichHtmlController controller;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
