import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../pages/rich-html.dart' show RichHtmlLabelType, RichHtmlController;

import 'image_text.dart';
import 'at_text.dart';
import 'dollar_text.dart';
import 'emoji_text.dart';
import 'video_text.dart';
import 'blockquote_text.dart';
import 'p_text.dart';
import 'b_text.dart';
import 'a_text.dart';

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  BuildContext context;
  TextEditingController richhtmlController;

  MySpecialTextSpanBuilder(
    this.context,
    this.richhtmlController, {
    this.showAtBackground = false,
    this.richhtmlSupportLabel,
    this.videoView,
    this.imageView,
  });

  final List<RichHtmlLabelType> richhtmlSupportLabel;

  /// whether show background for @somebody
  final bool showAtBackground;
  final videoView;
  final imageView;

  @override
  TextSpan build(String data, {TextStyle textStyle, SpecialTextGestureTapCallback onTap}) {
    if (kIsWeb) {
      return TextSpan(text: data, style: textStyle);
    }
    return super.build(data, textStyle: textStyle, onTap: onTap);
  }

  @override
  SpecialText createSpecialText(String flag, {TextStyle textStyle, SpecialTextGestureTapCallback onTap, int index}) {
    if (flag == null || flag == '') {
      return null;
    }

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (richhtmlSupportLabel.contains(RichHtmlLabelType.EMOJI) && isStart(flag, EmojiText.flag)) {
      return EmojiText(
        textStyle,
        start: index - (EmojiText.flag.length - 1),
      );
    } else if (richhtmlSupportLabel.contains(RichHtmlLabelType.IMAGE) && isStart(flag, ImageText.flag)) {
      return ImageText(
        textStyle,
        start: index - (ImageText.flag.length - 1),
        onTap: onTap,
        imageView: imageView,
        context: context,
      );
    } else if (richhtmlSupportLabel.contains(RichHtmlLabelType.VIDEO) && isStart(flag, VideoText.flag)) {
      return VideoText(
        textStyle,
        start: index - (VideoText.flag.length - 1),
        onTap: onTap,
        videoView: videoView,
      );
    } else if (richhtmlSupportLabel.contains(RichHtmlLabelType.P) && isStart(flag, pText.flag)) {
      return pText(
        textStyle,
        onTap,
        start: index - (pText.flag.length - 1),
        showAtBackground: showAtBackground,
      );
    }
    else if (richhtmlSupportLabel.contains(RichHtmlLabelType.B) && isStart(flag, bText.flag)) {
      return bText(
        textStyle,
        onTap,
        start: index - (bText.flag.length - 1),
        context: context,
        controller: richhtmlController,
      );
    }
    else if (richhtmlSupportLabel.contains(RichHtmlLabelType.LINK) && isStart(flag, aText.flag)) {
      return aText(
        textStyle,
        onTap,
        start: index - (aText.flag.length - 1),
        context: context,
        controller: richhtmlController,
      );
    }

//    else if (isStart(flag, BlockquoteText.flag)) {
//
//      return BlockquoteText(
//        textStyle,
//        onTap,
//        start: index - (AtText.flag.length - 1),
//        showAtBackground: showAtBackground,
//      );
//
//    }
    else if (richhtmlSupportLabel.contains(RichHtmlLabelType.AT) && isStart(flag, AtText.flag)) {
      return AtText(
        textStyle,
        onTap,
        start: index - (AtText.flag.length - 1),
        showAtBackground: showAtBackground,
      );
    } else if (richhtmlSupportLabel.contains(RichHtmlLabelType.EMOJI) && isStart(flag, EmojiText.flag)) {
      return EmojiText(
        textStyle,
        start: index - (EmojiText.flag.length - 1),
      );
    } else if (richhtmlSupportLabel.contains(RichHtmlLabelType.DOLLAR) && isStart(flag, DollarText.flag)) {
      return DollarText(
        textStyle,
        onTap,
        start: index - (DollarText.flag.length - 1),
      );
    }

    return null;
  }
}
