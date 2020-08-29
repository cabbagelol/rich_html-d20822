// Minimal padding from all edges of the selection toolbar to all edges of the
// viewport.
// Padding when positioning toolbar below selection.

import 'dart:math' as math;
import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const double _kHandleSize = 22.0;
const double _kToolbarScreenPadding = 8.0;
const double _kToolbarHeight = 44.0;
const double _kToolbarContentDistanceBelow = _kHandleSize - 2.0;
const double _kToolbarContentDistance = 8.0;

class RichHtmlTextSelectionControls extends ExtendedMaterialTextSelectionControls {
  final color;

  RichHtmlTextSelectionControls({
    this.color,
  });

  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ClipboardStatusNotifier clipboardStatus,
  ) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));

    // The toolbar should appear below the TextField when there is not enough
    // space above the TextField to show it.
    final TextSelectionPoint startTextSelectionPoint = endpoints[0];
    final TextSelectionPoint endTextSelectionPoint = endpoints.length > 1 ? endpoints[1] : endpoints[0];
    const double closedToolbarHeightNeeded = _kToolbarScreenPadding + _kToolbarHeight + _kToolbarContentDistance;
    final double paddingTop = MediaQuery.of(context).padding.top;
    final double availableHeight = globalEditableRegion.top + startTextSelectionPoint.point.dy - textLineHeight - paddingTop;
    final bool fitsAbove = closedToolbarHeightNeeded <= availableHeight;
    final Offset anchor = Offset(
      globalEditableRegion.left + selectionMidpoint.dx,
      fitsAbove
          ? globalEditableRegion.top + startTextSelectionPoint.point.dy - textLineHeight - _kToolbarContentDistance
          : globalEditableRegion.top + endTextSelectionPoint.point.dy + _kToolbarContentDistanceBelow,
    );

    return CustomSingleChildLayout(
      delegate: ExtendedMaterialTextSelectionToolbarLayout(
        anchor,
        _kToolbarScreenPadding + paddingTop,
        fitsAbove,
      ),
      child: _TextSelectionToolbar(
        handleCut: canCut(delegate) ? () => handleCut(delegate) : null,
        handleCopy: canCopy(delegate) ? () => handleCopy(delegate, clipboardStatus) : null,
        handlePaste: canPaste(delegate) ? () => handlePaste(delegate) : null,
        handleSelectAll: canSelectAll(delegate) ? () => handleSelectAll(delegate) : null,
//        handleLike: () {
//          delegate.hideToolbar();
//          delegate.textEditingValue = delegate.textEditingValue.copyWith(
//            selection: TextSelection.collapsed(
//              offset: delegate.textEditingValue.selection.end,
//            ),
//          );
//        },
      ),
    );
  }

  @override
  Widget buildHandle(BuildContext context, TextSelectionHandleType type, double textHeight) {
    final Widget handle = SizedBox(
      width: _kHandleSize,
      height: _kHandleSize,
      child: Container(
        color: Colors.red,
        width: 10,
        height: 10,
      ),
    );

    // [handle] is a circle, with a rectangle in the top left quadrant of that
    // circle (an onion pointing to 10:30). We rotate [handle] to point
    // straight up or up-right depending on the handle type.
    switch (type) {
      case TextSelectionHandleType.left: // points up-right
        return Transform.rotate(
          angle: math.pi / 4.0,
          child: handle,
        );
      case TextSelectionHandleType.right: // points up-left
        return Transform.rotate(
          angle: -math.pi / 4.0,
          child: handle,
        );
      case TextSelectionHandleType.collapsed: // points up
        return handle;
    }
    assert(type != null);
    return null;
  }
}

class TextSelectionToolbarButton extends StatelessWidget {
  final onPressed;
  final child;

  TextSelectionToolbarButton({this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      splashColor: Colors.black26,
      // 溅墨色（波纹色）
      highlightColor: Colors.transparent,
      // 点击时的背景色（高亮色）
      onPressed: () => onPressed,
      // 点击事件
      child: child,
    );
  }
}

/// Manages a copy/paste text selection toolbar.
class _TextSelectionToolbar extends StatelessWidget {
  const _TextSelectionToolbar({
    Key key,
    this.handleCopy,
    this.handleSelectAll,
    this.handleCut,
    this.handlePaste,
  }) : super(key: key);

  final VoidCallback handleCut;
  final VoidCallback handleCopy;
  final VoidCallback handlePaste;
  final VoidCallback handleSelectAll;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    if (handleCut != null) {
      items.add(
        TextSelectionToolbarButton(
          child: Text(localizations.cutButtonLabel),
          onPressed: handleCut,
        ),
      );
    }
    if (handleCopy != null) {
      items.add(
        TextSelectionToolbarButton(
          child: Text(localizations.copyButtonLabel),
          onPressed: handleCopy,
        ),
      );
    }
    if (handlePaste != null) {
      items.add(
        TextSelectionToolbarButton(
          child: Text(localizations.pasteButtonLabel),
          onPressed: handlePaste,
        ),
      );
    }
    if (handleSelectAll != null) {
      items.add(
        TextSelectionToolbarButton(
          child: Text(localizations.selectAllButtonLabel),
          onPressed: handleSelectAll,
        ),
      );
    }
    // If there is no option available, build an empty widget.
    if (items.isEmpty) {
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Wrap(
        runSpacing: 0,
        spacing: 0,
        children: items,
      ),
    );
  }
}
