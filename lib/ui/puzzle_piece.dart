import 'package:flutter/material.dart';

import '../game_state.dart';
import 'board_config.dart';
import 'shiny_text.dart';

/// A UI representation of the [Piece] data object on the screen.
///
/// Each piece also comes with a "shadow" piece called [PuzzlePieceShadow] and
/// a few "attachments" called [PuzzlePieceAttachment] on the side, to make it
/// look more realistic when interacting with other pieces.
class PuzzlePiece extends StatefulWidget {
  final Piece piece;
  final GameState gameState;
  final VoidCallback? onMove;

  const PuzzlePiece({
    Key? key,
    required this.piece,
    required this.gameState,
    this.onMove,
  }) : super(key: key);

  @override
  State<PuzzlePiece> createState() => _PuzzlePieceState();
}

class _PuzzlePieceState extends State<PuzzlePiece> {
  bool _dispatched = false;

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;
    final child = Container(
      width: unitSize * 0.99 + (widget.piece.width - 1) * unitSize,
      height: unitSize * 0.99 + (widget.piece.height - 1) * unitSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.piece.id == 0
              ? [
                  BoardConfig.of(context).corePieceColor1,
                  BoardConfig.of(context).corePieceColor2,
                ]
              : [
                  BoardConfig.of(context).pieceColor1,
                  BoardConfig.of(context).pieceColor2,
                ],
        ),
        borderRadius: BorderRadius.circular(unitSize * 0.04),
      ),
      child: Center(child: ShinyText(label: widget.piece.label)),
    );

    return GestureDetector(
      onPanStart: (_) {
        _dispatched = false;
      },
      onPanUpdate: (DragUpdateDetails details) {
        if (_dispatched) return;
        final direction = _getDirection(details);
        // Check if the user input is a legal move
        if (widget.gameState.canMove(widget.piece, direction.x, direction.y)) {
          // move the piece (this triggers a value notifier)
          widget.piece.move(direction.x, direction.y);
          // increment step counter
          widget.gameState.stepCounter.value += 1;
          // fire the callback
          widget.onMove?.call();
          // do not dispatch the same move again
          _dispatched = true;
        }
      },
      child: child,
    );
  }

  Coordinates _getDirection(DragUpdateDetails details) {
    final delta = details.delta;
    if (delta.dx.abs() > delta.dy.abs()) {
      return Coordinates(delta.dx < 0 ? -1 : 1, 0); // left or right
    } else {
      return Coordinates(0, delta.dy < 0 ? -1 : 1); // up or down
    }
  }
}

class PuzzlePieceAttachment extends StatelessWidget {
  final Piece piece;

  const PuzzlePieceAttachment({
    Key? key,
    required this.piece,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;

    final decoration = DecoratedBox(
      decoration: BoxDecoration(
        color: BoardConfig.of(context).pieceAttachmentColor,
        borderRadius: BorderRadius.circular(unitSize * 0.04),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: piece.width * unitSize * 0.99,
          height: piece.height * unitSize * 0.99,
        ),
        Positioned(
          top: unitSize * -0.1,
          right: unitSize * 0.1,
          child: SizedBox(
            width: piece.width * unitSize * 0.8,
            height: piece.height * unitSize * 0.2,
            child: decoration,
          ),
        ),
        Positioned(
          top: unitSize * 0.1,
          right: unitSize * -0.1,
          child: SizedBox(
            width: piece.width * unitSize * 0.2,
            height: piece.height * unitSize * 0.8,
            child: decoration,
          ),
        ),
      ],
    );
  }
}

class PuzzlePieceShadow extends StatelessWidget {
  final Piece piece;

  const PuzzlePieceShadow({
    Key? key,
    required this.piece,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;
    return Container(
      width: piece.width * unitSize * 0.99,
      height: unitSize * 1.05 + (piece.height - 1) * unitSize,
      decoration: BoxDecoration(
        color: BoardConfig.of(context).pieceShadowColor,
        borderRadius: BorderRadius.circular(unitSize * 0.04),
      ),
    );
  }
}
