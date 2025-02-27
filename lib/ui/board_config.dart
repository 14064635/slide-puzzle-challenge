import 'package:flutter/widgets.dart';

class BoardConfig extends InheritedWidget {
  /// The animation duration for a puzzle piece to move to its final position.
  final Duration slideDuration = const Duration(milliseconds: 300);

  /// The width and height of a 1x1 piece.
  final double unitSize;

  /// Colors used for the core piece.
  final Color corePieceColor1 = const Color(0xff359090);
  final Color corePieceColor2 = const Color(0xff1f7878);

  /// Colors used for other pieces.
  final Color pieceColor1 = const Color(0xff357070);
  final Color pieceColor2 = const Color(0xff1f5757);

  final Color pieceAttachmentColor = const Color(0xff0b4040);
  final Color pieceShadowColor = const Color(0xff0f2424);

  const BoardConfig({
    Key? key,
    required this.unitSize,
    required Widget child,
  }) : super(key: key, child: child);

  static BoardConfig of(BuildContext context) {
    final config = context.dependOnInheritedWidgetOfExactType<BoardConfig>();
    assert(
      config != null,
      'BoardConfig.of() called with a context '
      'that does not contain a BoardConfig.',
    );
    return config!;
  }

  @override
  bool updateShouldNotify(BoardConfig oldWidget) =>
      unitSize != oldWidget.unitSize;
}
