import 'package:flutter/material.dart';

enum ArrowPosition { left, top, right, bottom }

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    required this.child,
    super.key,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.white,
    this.borderRadius = 12.0,
    this.arrowWidth = 20.0,
    this.arrowHeight = 10.0,
    this.arrowPosition = ArrowPosition.bottom,
  });
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final double arrowWidth;
  final double arrowHeight;
  final ArrowPosition arrowPosition;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ChatBubblePainter(
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderRadius: borderRadius,
        arrowWidth: arrowWidth,
        arrowHeight: arrowHeight,
        arrowPosition: arrowPosition,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: arrowPosition == ArrowPosition.left ? arrowHeight + 8 : 8,
          top: arrowPosition == ArrowPosition.top ? arrowHeight + 8 : 8,
          right: arrowPosition == ArrowPosition.right ? arrowHeight + 8 : 8,
          bottom: arrowPosition == ArrowPosition.bottom ? arrowHeight + 8 : 8,
        ),
        child: child,
      ),
    );
  }
}

class ChatBubblePainter extends CustomPainter {
  ChatBubblePainter({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderRadius,
    required this.arrowWidth,
    required this.arrowHeight,
    required this.arrowPosition,
  });
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final double arrowWidth;
  final double arrowHeight;
  final ArrowPosition arrowPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();

    switch (arrowPosition) {
      case ArrowPosition.left:
        _drawLeftArrowBubble(size, path);
      case ArrowPosition.top:
        _drawTopArrowBubble(size, path);
      case ArrowPosition.right:
        _drawRightArrowBubble(size, path);
      case ArrowPosition.bottom:
        _drawBottomArrowBubble(size, path);
    }

    canvas
      ..drawPath(path, paint)
      ..drawPath(path, borderPaint);
  }

  void _drawLeftArrowBubble(Size size, Path path) {
    path
      ..moveTo(arrowHeight + borderRadius, 0)
      ..lineTo(size.width - borderRadius, 0)
      ..arcToPoint(
        Offset(size.width, borderRadius),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(size.width, size.height - borderRadius)
      ..arcToPoint(
        Offset(size.width - borderRadius, size.height),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(arrowHeight + borderRadius, size.height)
      ..arcToPoint(
        Offset(arrowHeight, size.height - borderRadius),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(arrowHeight, (size.height / 2) + (arrowWidth / 2))
      ..lineTo(0, size.height / 2)
      ..lineTo(arrowHeight, (size.height / 2) - (arrowWidth / 2))
      ..lineTo(arrowHeight, borderRadius)
      ..arcToPoint(
        Offset(arrowHeight + borderRadius, 0),
        radius: Radius.circular(borderRadius),
      );
  }

  void _drawTopArrowBubble(Size size, Path path) {
    path.moveTo(0, arrowHeight + borderRadius);
    path.lineTo(0, size.height - borderRadius);
    path.arcToPoint(
      Offset(borderRadius, size.height),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(size.width - borderRadius, size.height);
    path.arcToPoint(
      Offset(size.width, size.height - borderRadius),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(size.width, arrowHeight + borderRadius);
    path.arcToPoint(
      Offset(size.width - borderRadius, arrowHeight),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo((size.width / 2) + (arrowWidth / 2), arrowHeight);
    path.lineTo(size.width / 2, 0);
    path.lineTo((size.width / 2) - (arrowWidth / 2), arrowHeight);
    path.lineTo(borderRadius, arrowHeight);
    path.arcToPoint(
      Offset(0, arrowHeight + borderRadius),
      radius: Radius.circular(borderRadius),
    );
  }

  void _drawRightArrowBubble(Size size, Path path) {
    path.moveTo(borderRadius, 0);
    path.lineTo(size.width - arrowHeight - borderRadius, 0);
    path.arcToPoint(
      Offset(size.width - arrowHeight, borderRadius),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(size.width - arrowHeight, (size.height / 2) - (arrowWidth / 2));
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - arrowHeight, (size.height / 2) + (arrowWidth / 2));
    path.lineTo(size.width - arrowHeight, size.height - borderRadius);
    path.arcToPoint(
      Offset(size.width - arrowHeight - borderRadius, size.height),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(borderRadius, size.height);
    path.arcToPoint(
      Offset(0, size.height - borderRadius),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(0, borderRadius);
    path.arcToPoint(
      Offset(borderRadius, 0),
      radius: Radius.circular(borderRadius),
    );
  }

  void _drawBottomArrowBubble(Size size, Path path) {
    path.moveTo(borderRadius, 0);
    path.lineTo(size.width - borderRadius, 0);
    path.arcToPoint(
      Offset(size.width, borderRadius),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(size.width, size.height - arrowHeight - borderRadius);
    path.arcToPoint(
      Offset(size.width - borderRadius, size.height - arrowHeight),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo((size.width / 2) + (arrowWidth / 2), size.height - arrowHeight);
    path.lineTo(size.width / 2, size.height);
    path.lineTo((size.width / 2) - (arrowWidth / 2), size.height - arrowHeight);
    path.lineTo(borderRadius, size.height - arrowHeight);
    path.arcToPoint(
      Offset(0, size.height - arrowHeight - borderRadius),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(0, borderRadius);
    path.arcToPoint(
      Offset(borderRadius, 0),
      radius: Radius.circular(borderRadius),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
