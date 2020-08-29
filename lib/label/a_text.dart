import 'dart:ui' as ui;
import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../pages/rich-html.dart' show RichHtmlUtil;

class aText extends SpecialText {
  aText(
    TextStyle textStyle,
    SpecialTextGestureTapCallback onTap, {
    this.start,
    this.context,
    this.controller,
  }) : super(
          flag,
          '</$domname>',
          textStyle,
          onTap: onTap,
        );

  static const String domname = 'a';
  static const String flag = '<$domname';
  final BuildContext context;
  final TextEditingController controller;
  final int start;

  String text;
  TextEditingController textEditingController;
  TextEditingController attrEditingController;

  void _onBack() {
    Navigator.pop(context);
  }

  void _onDeleAText() {
    controller.value = controller.value.copyWith(
      text: controller.text.replaceRange(start, start + text.length, ''),
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: start,
        ),
      ),
    );
    _onBack();
  }

  void _onSup() {
    textEditingController.text = '<$domname${attrEditingController != null ? ' href="${attrEditingController.text}"' : ''}>' +
        textEditingController.text +
        '</$domname>';

    controller.value = controller.value.copyWith(
      text: controller.text.replaceRange(start, start + text.length, textEditingController.text + ' '),
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: start + (textEditingController.text + ' ').length,
        ),
      ),
    );
    _onBack();
  }

  @override
  InlineSpan finishText() {
    text = flag + getContent() + '>';

    return ExtendedWidgetSpan(
      actualText: text,
      start: start,
      alignment: ui.PlaceholderAlignment.middle,
      child: GestureDetector(
        child: RichText(
          strutStyle: StrutStyle(
            forceStrutHeight: true,
          ),
          text: TextSpan(
            text: RichHtmlUtil().remStringHtml(text).trim(),
            style: textStyle?.copyWith(
              color: Theme.of(context).primaryColor ?? Colors.blue.shade500,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.solid,
              decorationColor: Theme.of(context).primaryColor ?? Colors.blue.shade500,
            ),
          ),
        ),
        onTap: () {
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext c) {
              RegExp attrHref = RegExp("href=\"(.*)\"");
              RegExpMatch res = attrHref.firstMatch(text);

              textEditingController = TextEditingController()..text = RichHtmlUtil().remStringHtml(text);
              attrEditingController = TextEditingController()
                ..text = res.input.substring(res.start, res.end - 1).replaceAll("href=\"", "") ?? '';

              return Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.white,

                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          AInput(
                            controller: attrEditingController,
                            hintText: "链接地址",
                          ),
                          AInput(
                            controller: textEditingController,
                            hintText: "输入内容",
                            minLines: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _onDeleAText(),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FlatButton(
                                      child: Text('取消'),
                                      textColor: Colors.black,
                                      onPressed: () => _onBack(),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    FlatButton(
                                      child: Text('确定'),
                                      onPressed: () => _onSup(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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

class AInput extends StatelessWidget {
  final controller;
  final hintText;
  final minLines;

  AInput({
    this.controller,
    this.hintText,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        border: InputBorder.none,
      ),
      minLines: 1,
    );
  }
}
