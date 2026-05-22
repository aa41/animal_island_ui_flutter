import 'package:flutter/material.dart';

abstract final class AnimalIslandTokens {
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 24;
  static const double spacingXxl = 32;

  static const double radiusSm = 12;
  static const double radiusBase = 18;
  static const double radiusLg = 24;
  static const double radiusPill = 50;

  static const double pixelRadiusSm = 0;
  static const double pixelRadiusBase = 2;
  static const double pixelRadiusLg = 4;

  static const double borderWidth = 2;
  static const double inputBorderWidth = 2.5;
  static const double pixelBorderWidth = 3;

  static const double heightSm = 32;
  static const double heightBase = 40;
  static const double heightMdButton = 45;
  static const double heightLg = 48;

  static const double fontMicro = 10;
  static const double fontCaption = 11;
  static const double fontBodySm = 12;
  static const double fontLabel = 13;
  static const double fontBody = 14;
  static const double fontBodyLg = 15;
  static const double fontTitleSm = 16;
  static const double fontTitle = 18;
  static const double fontHeadlineSm = 20;
  static const double fontHeadline = 24;
  static const double fontDisplaySm = 30;
  static const double fontDisplay = 36;

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration pixelStep = Duration(milliseconds: 90);

  static const Curve motionCurve = Cubic(0.4, 0.0, 0.2, 1.0);
  static const Curve softCurve = Curves.easeInOut;
  static const Curve pixelCurve = Curves.linear;
}

abstract final class AnimalIslandShadows {
  static const Shadow warmText = Shadow(
    color: Color.fromRGBO(0, 0, 0, 0.16),
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  static List<BoxShadow> panel(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.1),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> button(Color color, {double depth = 5}) => [
    BoxShadow(color: color, blurRadius: 0, offset: Offset(0, depth)),
  ];

  static List<BoxShadow> hover(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.18),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
