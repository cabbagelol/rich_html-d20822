import 'dart:ui' as ui show PlaceholderAlignment;
import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../pages/rich-html.dart' show RichHtmlUtil;

//class BlockquoteText extends SpecialText {
//  BlockquoteText(
//    TextStyle textStyle,
//    SpecialTextGestureTapCallback onTap, {
//    this.showAtBackground = false,
//    this.start,
//  }) : super(
//          BlockquoteText.flag,
//          '</blockquote>',
//          textStyle,
//          onTap: onTap,
//        );
//
//  static const String flag = '<blockquote';
//  final int start;
//
//  /// whether show background for @somebody
//  final bool showAtBackground;
//
//  @override
//  InlineSpan finishText() {
//    final TextStyle textStyle = this.textStyle?.copyWith(color: Colors.blue, fontSize: 16.0);
//
//    final String atText = toString();
//    final String text = getContent();
//
//    return SpecialTextSpan(
//      text: atText,
//      actualText: atText,
//      start: start,
//      style: textStyle,
//      recognizer: (TapGestureRecognizer()
//        ..onTap = () {
//          if (onTap != null) {
//            onTap(atText);
//          }
//        }),
//    );
//  }
//}


class BlockquoteText extends SpecialText {
  BlockquoteText(
      TextStyle textStyle,
      SpecialTextGestureTapCallback onTap, {
        this.start,
        this.context,
        this.controller,
      }) : super(
    flag,
    '</b>',
    textStyle,
    onTap: onTap,
  );

  static const String flag = '<b';
  final BuildContext context;
  final TextEditingController controller;
  final int start;

  _onBack () {
    Navigator.pop(context);
  }

  @override
  InlineSpan finishText() {
    final String text = flag + getContent() + '>';

    return ExtendedWidgetSpan(
      actualText: RichHtmlUtil().remStringHtml(text),
      start: start,
      alignment: ui.PlaceholderAlignment.middle,
      child: GestureDetector(
        child: Container(
          child: RichText(
            strutStyle: StrutStyle(
              fontSize: textStyle.fontSize + 1,
              forceStrutHeight: true,
            ),
            text: TextSpan(
              text: RichHtmlUtil().remStringHtml(text).trim(),
              style: textStyle.copyWith(color: Colors.blue.shade500),
            ),
          ),
        ),
        onTap: () {

          /// 编辑窗口
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext c) {
              final TextEditingController textEditingController = TextEditingController()..text = text.trim();
              return Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            child: const Text('确定'),
                            onPressed: () {
                              controller.value = controller.value.copyWith(
                                text: controller.text.replaceRange(start, start + text.length, textEditingController.text + ' '),
                                selection: TextSelection.fromPosition(
                                  TextPosition(
                                    offset: start + (textEditingController.text + ' ').length,
                                  ),
                                ),
                              );
                              _onBack();
                            },
                          )
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.white,
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: "输入内容",
                              border: InputBorder.none,
                            ),
                            minLines: 1,
                            maxLines: null,
                          ),
                        ),
                      ),
                      FlatButton(
                        child: const Icon(
                          Icons.close,
                          size: 28.0,
                        ),
                        onPressed: () {
                          controller.value = controller.value.copyWith(
                            text: controller.text.replaceRange(start, start + text.length, ''),
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                offset: start,
                              ),
                            ),
                          );

                          _onBack();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      deleteAll: true,
    );
  }
}
