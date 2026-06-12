// https://github.com/flutter/gallery/blob/master/lib/studies/rally/app.dart
import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const bottomNavbarHeight = 48.0;

class RallyColors {
  static const Color gray = Color(0xFFD8D8D8);
  static const Color primaryBackground = Color(0xFF33333D);
  static const Color focusColor = Color(0xCCFFFFFF);
  static const Color cardBackground = Color(0x03FEFEFE);
  static const Color buttonColor = Color(0xFF045D56);
  static const Color primaryColor = Color(0xFF1EB980);
}

ThemeData buildTheme() {
  final base = ThemeData.dark();
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFD32F2F),
    brightness: Brightness.dark,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    appBarTheme: const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark, elevation: 0),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: colorScheme.surface),
    textTheme: _buildTextTheme(base.textTheme),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: SharedAxisPageTransitionsBuilder(
        fillColor: RallyColors.primaryBackground,
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      TargetPlatform.windows: ZoomPageTransitionsBuilder(),
    }),
    scaffoldBackgroundColor: colorScheme.surface,
    primaryColor: colorScheme.primary,
    focusColor: RallyColors.focusColor,
    chipTheme: ChipThemeData(
      backgroundColor: colorScheme.primary,
    ),
    cardTheme: const CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0.0,
    ),
    buttonTheme: const ButtonThemeData(
      height: bottomNavbarHeight,
    ),
    highlightColor: colorScheme.primary,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.onSurface,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
      ),
    ),
    canvasColor: colorScheme.surface,
    dialogTheme: DialogThemeData(
      elevation: 36.0,
      backgroundColor: colorScheme.surface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        fontWeight: FontWeight.w300,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary),
      ),
      contentPadding: const EdgeInsets.all(4.0),
    ),
    visualDensity: VisualDensity.standard,
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        bodyLarge: GoogleFonts.eczar(
          fontSize: 40,
          fontWeight: FontWeight.w400,
          letterSpacing: letterSpacingOrNone(1.4),
        ),
        bodyMedium: GoogleFonts.robotoCondensed(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: letterSpacingOrNone(0.5),
        ),
        labelLarge: GoogleFonts.robotoCondensed(
          fontWeight: FontWeight.w700,
          letterSpacing: letterSpacingOrNone(2.8),
        ),
        headlineSmall: GoogleFonts.eczar(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          letterSpacing: letterSpacingOrNone(1.4),
        ),
      )
      .apply(
        displayColor: Colors.white,
        bodyColor: Colors.white,
      );
}

/// Using letter spacing in Flutter for Web can cause a performance drop,
/// see https://github.com/flutter/flutter/issues/51234.
double letterSpacingOrNone(double letterSpacing) => kIsWeb ? 0.0 : letterSpacing;

/// [left] is for buttons on the left side of bottom appbar
enum CustomShapeSide {
  left,
  right,
}

/// Custom shape to accomodate the buttons in button bar in the notched appbar
class CustomShape extends ShapeBorder {
  final CustomShapeSide side;

  const CustomShape({this.side = CustomShapeSide.right});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => _getPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _getPath(rect);

  Path _getPath(Rect rect) {
    var baseX = 0.0, baseY = 0.0;
    if (side == CustomShapeSide.left) {
      baseX = rect.width;
    }

    // extra radius to the notch circle
    const margin = 9.0;
    // get the radius info of the circular notch (cn)
    final rCn = rect.height / 2 + margin;
    final radCn = Radius.circular(rCn);
    final rectNotchCn = Rect.fromCircle(center: Offset.zero, radius: rCn);

    // as we're using a ContinuousRectangleBorder with border radius of 72 (defined in theme),
    // there'd be a circular curve on the topleft/topright corners.

    // the top-right / top-left curve info (trc)
    const rTrc = 20.0;
    const radTrc = Radius.circular(rTrc);
    final rectNotchTrc = Rect.fromCircle(center: Offset.zero, radius: rTrc);

    var p = Path()
      ..moveTo(baseX, baseY)
      ..relativeMoveTo(0, rCn)
      ..relativeArcToPoint(
        // arc to create notch
        side == CustomShapeSide.right ? rectNotchCn.topRight : rectNotchCn.topLeft,
        clockwise: side == CustomShapeSide.right ? false : true,
        radius: radCn,
      )
      // move to the starting curve point
      ..lineTo(((rect.width - baseX) - rTrc).abs(), 0)
      ..relativeArcToPoint(
        side == CustomShapeSide.right ? rectNotchTrc.bottomRight : rectNotchTrc.bottomLeft,
        clockwise: side == CustomShapeSide.right ? true : false,
        radius: radTrc,
      ); // arc down

    if (side == CustomShapeSide.right) {
      p.lineTo(rect.bottomRight.dx, rect.bottomRight.dy);
      p.lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy);
    } else {
      p.lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy);
      p.lineTo(rect.bottomRight.dx, rect.bottomRight.dy);
    }
    return p..lineTo(baseX, baseY);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => const CustomShape();
}
