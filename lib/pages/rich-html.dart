import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter_rich_html/main.dart';

import '../label/special_textspan_builder.dart';
import '../label/textselection_controls.dart';
import '../pages/rich-html-cursor.dart';
import '../pages/rich-html-theme.dart';
import '../pages/rich-html-toolbar.dart';
import '../label/AsperctRaioImage.dart';

enum RichHtmlLabelType { IMAGE, VIDEO, P, TEXT, AT, EMOJI, EMAIL, DOLLAR, BLOCKQUOTE, B, LINK }

class RichHtmlData {
  RichHtmlLabelType type;
  dynamic data;

  RichHtmlData(
    RichHtmlLabelType type, {
    this.data,
  }) : super();
}

class RichHtmlDataImage {
  String src;
  var element;

  RichHtmlDataImage({this.src, this.element});
}

abstract class RichHtmlController {
  RichHtmlController({this.theme});

  String _html;
  RichHtmlUtil _util = RichHtmlUtil();
  RichHtmlTheme theme;

  String get text => _util.remStringHtml(this._html);

  String get html => this._html;
  TextSelection textSelection;
  TextEditingController controller = TextEditingController();
  Function updateWidget;
  Function clearAll;
  Function blur;
  Function focus;
  bool hasFocus;
  List<Widget> richhtmltoolbarController;

  set text(String value) {
    _html = _util.remStringHtml(value);
  }

  set html(String value) {
    _html = value ?? '';
  }

  Future<String> insertImage();

  Future<String> insertVideo();

  Future<String> insertText() async {
    return '\n输入内容';
  }

  Widget generateImageView(String url, dynamic img) {
    double width = .0;
    double height = .0;
    bool autoWidth = true;
    bool autoheight = true;

    return AsperctRaioImage.network(url, builder: (context, snapshot, url) {
      if (img.attributes.containsKey('width')) {
        autoWidth = false;
        width = double.tryParse(img.attributes['width']);
      }
      if (img.attributes.containsKey('height')) {
        autoheight = false;
        height = double.tryParse(img.attributes['height']);
      }

      return Container(
        margin: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Image.network(
          url,
          width: autoWidth ? snapshot.data.width.toDouble() : width,
          height: autoheight ? snapshot.data.height.toDouble() : height,
          fit: BoxFit.fill,
        ),
      );
    });
  }

  Widget generateVideoView(String url, video) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      color: Colors.black12,
      child: Center(
        child: Text("请构建[generateVideoView]"),
      ),
    );
  }
}

class RichHtmlUtil {
  String remStringHtml(String text) {
    RegExp reg = new RegExp("<[^>]*>");
    Iterable<RegExpMatch> matches = reg.allMatches(text);
    String value;
    matches.forEach((m) {
      value = m.input.toString().replaceAll(reg, "") ?? '';
    });
    return value;
  }
}

class RichHtml extends StatefulWidget {
  final RichHtmlController richhtmlController;

  // richhtml所支持的标签类型，具体支持详情请看[RichHtmlLabelType]
  final List<RichHtmlLabelType> richhtmlSupportLabel;
  final scrollPadding;
  final scrollPhysics;
  final toolbarOptions;
  final autofocus;
  final TextSelectionControls textSelectionControls;
  final textDirection;
  final textAlignVertical;
  final RichHtmlCursor richHtmlCursorStyle;
  final String placeholder;
  final Function onChanged;
  final Function onSubmitted;
  final Function onTap;
  final Function onEditingComplete;

  RichHtml(
    this.richhtmlController, {
    Key key,
    this.richhtmlSupportLabel = const <RichHtmlLabelType>[
      RichHtmlLabelType.IMAGE,
      RichHtmlLabelType.VIDEO,
      RichHtmlLabelType.P,
      RichHtmlLabelType.B,
      RichHtmlLabelType.TEXT,
    ],
    this.scrollPadding,
    this.scrollPhysics,
    this.toolbarOptions,
    this.autofocus,
    this.textSelectionControls,
    this.textDirection,
    this.textAlignVertical,
    // 光标样式
    // 对应Input的 [cursorWidth]和[cursorColor]和[cursorRadius]
    RichHtmlCursor richHtmlCursorStyle,
    // 规定帮助用户填写输入字段的提示。
    this.placeholder = '填写内容',
    Function onChanged,
    this.onSubmitted,
    Function onTap,
    Function onEditingComplete,
  })  : onEditingComplete = onEditingComplete ?? null,
        onTap = onTap ?? null,
        onChanged = onChanged ?? null,
        richHtmlCursorStyle = richHtmlCursorStyle ?? RichHtmlCursor();

  @override
  _RichHtmlState createState() => _RichHtmlState();
}

class _RichHtmlState extends State<RichHtml> {
  ScrollController _scrollController = ScrollController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    RichHtmlController _rhc = widget.richhtmlController;

    _rhc.updateWidget = _onUpdateWidget;
    _rhc.clearAll = _onClear;
    _rhc.blur = _onBlur;
    _rhc.focus = _onFocus;

    _rhc.controller.text = _rhc._html;
    _rhc.controller.addListener(() {
      _rhc.textSelection = _rhc.controller.selection;
    });

    _rhc.controller.addListener(() {
      _rhc.hasFocus = _focusNode.hasFocus;

      widget.richhtmlController.richhtmltoolbarController.forEach((element) {
        switch (element.runtimeType) {
          case RichHtmlToolKeyboardSwitch:
            RichHtmlToolKeyboardSwitch _e = element;
            _e.upState();
            break;
        }
      });
    });

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<bool> _onClear() async {
    await widget.richhtmlController.controller.clear();
    return true;
  }

  Future<String> _onUpdateWidget(String text) async {
    setState(() {
      widget.richhtmlController.controller.text = text;
    });
    return text;
  }

  Function _onBlur() {
    FocusScopeNode _focusScope = FocusScope.of(super.context);
    if (_focusScope.hasFocus) {
      _focusScope.requestFocus(FocusNode());
    }
  }

  Function _onFocus() {
    FocusScopeNode _focusScope = FocusScope.of(super.context);
    if (!_focusScope.hasFocus) {
      _focusScope.requestFocus(_focusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      cacheExtent: 2,
      children: [
        Container(
          color: widget.richhtmlController.theme?.viewTheme?.color ?? Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ExtendedTextField(
            controller: widget.richhtmlController.controller,
            minLines: 1,
            maxLines: null,
            focusNode: _focusNode,
            style: TextStyle(
              fontSize: 16,
            ),
            strutStyle: StrutStyle(
              fontSize: 16,
            ),
            specialTextSpanBuilder: MySpecialTextSpanBuilder(
              context,
              widget.richhtmlController.controller,
              richhtmlSupportLabel: widget.richhtmlSupportLabel,
              videoView: widget.richhtmlController.generateVideoView,
              imageView: widget.richhtmlController.generateImageView,
            ),
            scrollController: _scrollController,
            scrollPadding: widget.scrollPadding ?? EdgeInsets.zero,
            scrollPhysics: widget.scrollPhysics ?? ScrollPhysics(),
            textCapitalization: TextCapitalization.words,
            textSelectionControls: widget.textSelectionControls ?? null,
            textDirection: widget.textDirection ?? TextDirection.ltr,
            textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.top,
            toolbarOptions: widget.toolbarOptions ??
                ToolbarOptions(
                  selectAll: true,
                  copy: true,
                  paste: true,
                  cut: true,
                ),
            cursorWidth: widget.richHtmlCursorStyle.cursorWidth,
            cursorColor: widget.richHtmlCursorStyle.cursorColor,
            cursorRadius: widget.richHtmlCursorStyle.cursorRadius,
            autofocus: widget.autofocus ?? false,
            decoration: InputDecoration(
              hintText: widget.placeholder ?? '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            keyboardType: TextInputType.multiline,
            onChanged: (String value) {
              setState(() {
                widget.richhtmlController._html = value;
              });
              widget.onChanged(value);
            },
            onSubmitted: (String value) {
              widget.onSubmitted?.call(value);
            },
            onTap: () {
              widget.onTap?.call();
            },
            onEditingComplete: () {
              widget.onEditingComplete?.call();
            },
          ),
        ),
      ],
    );
  }
}
