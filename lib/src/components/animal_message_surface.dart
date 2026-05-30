import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import 'guofeng_components.dart';
import 'nes_pixel_frame.dart';

class AnimalMessageSurface extends StatelessWidget {
  const AnimalMessageSurface({
    super.key,
    required this.type,
    required this.child,
    this.title,
    this.action,
    this.leading,
    this.onClose,
    this.compact = false,
    this.snackbar = false,
  });

  final AnimalMessageType type;
  final Widget child;
  final Widget? title;
  final Widget? action;
  final Widget? leading;
  final VoidCallback? onClose;
  final bool compact;
  final bool snackbar;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final colors = _AnimalMessageColors.resolve(theme, type);
    final body = _AnimalMessageBody(
      colors: colors,
      title: title,
      action: action,
      leading: leading ?? _MessageGlyph(type: type, colors: colors),
      onClose: onClose,
      compact: compact,
      snackbar: snackbar,
      child: child,
    );

    if (theme.isNes) {
      return NesPixelFrame(
        palette: NesPixelFramePalette(
          background: colors.background,
          border: colors.border,
          shadow: colors.shadow,
          highlight: Colors.white,
          lowlight: colors.lowlight,
          accent: colors.accent,
        ),
        texture: type == AnimalMessageType.info,
        pixel: compact ? 3 : 4,
        compact: true,
        reserveShadowSpace: false,
        shadowOffset: Offset(compact ? 3 : 5, compact ? 3 : 5),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 14,
          vertical: compact ? 8 : 10,
        ),
        child: body,
      );
    }

    if (theme.isWestworld) {
      return CustomPaint(
        painter: _WestworldMessagePainter(
          line: colors.border,
          accent: colors.accent,
        ),
        child: DecoratedBox(
          decoration: theme.westworldPanelDecoration(
            color: colors.background,
            emphasized: type != AnimalMessageType.info,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 14 : 18,
              vertical: compact ? 10 : 13,
            ),
            child: body,
          ),
        ),
      );
    }

    if (theme.isGuofengDoodle) {
      return CustomPaint(
        painter: GuofengPaperTexturePainter(
          theme: theme,
          seed: type.index + 91,
        ),
        foregroundPainter: GuofengInkOutlinePainter(
          color: colors.border,
          radius: theme.radiusBase,
          strokeWidth: 2,
          seed: type.index + 91,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(theme.radiusBase),
            boxShadow: [
              BoxShadow(
                color: theme.inputShadow.withValues(alpha: 0.24),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 14 : 18,
              vertical: compact ? 10 : 13,
            ),
            child: body,
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(theme.radiusLg),
        border: Border.all(color: colors.border, width: 2),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.32),
            blurRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 14 : 18,
          vertical: compact ? 10 : 13,
        ),
        child: body,
      ),
    );
  }
}

class _AnimalMessageBody extends StatelessWidget {
  const _AnimalMessageBody({
    required this.colors,
    required this.child,
    required this.compact,
    required this.snackbar,
    this.title,
    this.action,
    this.leading,
    this.onClose,
  });

  final _AnimalMessageColors colors;
  final Widget child;
  final Widget? title;
  final Widget? action;
  final Widget? leading;
  final VoidCallback? onClose;
  final bool compact;
  final bool snackbar;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final titleStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
      color: colors.foreground,
      fontSize: compact
          ? AnimalIslandTokens.fontCaption
          : AnimalIslandTokens.fontLabel,
      fontWeight: FontWeight.w800,
      letterSpacing: theme.isWestworld ? 0.8 : 0,
      height: 1.2,
    );
    final bodyStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: colors.foreground.withValues(
        alpha: theme.isWestworld ? 0.78 : 0.9,
      ),
      fontSize: compact
          ? AnimalIslandTokens.fontBodySm
          : AnimalIslandTokens.fontBody,
      fontWeight: theme.isNes ? FontWeight.w700 : FontWeight.w500,
      height: theme.isNes ? 1.35 : 1.45,
      letterSpacing: theme.isWestworld ? 0.48 : 0,
    );

    final textColumn = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          DefaultTextStyle(style: titleStyle, child: title!),
          SizedBox(height: compact ? 2 : 4),
        ],
        DefaultTextStyle(style: bodyStyle, child: child),
      ],
    );

    return IconTheme(
      data: IconThemeData(color: colors.accent, size: compact ? 16 : 18),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: title == null
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            Padding(
              padding: EdgeInsets.only(top: title == null ? 0 : 1),
              child: leading!,
            ),
            SizedBox(width: compact ? 8 : 10),
          ],
          Flexible(child: textColumn),
          if (action != null) ...[
            SizedBox(width: snackbar ? 14 : 10),
            DefaultTextStyle(style: titleStyle, child: action!),
          ],
          if (onClose != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: Text(
                '×',
                style: titleStyle.copyWith(
                  color: colors.foreground.withValues(alpha: 0.72),
                  fontSize: compact ? 15 : 17,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageGlyph extends StatelessWidget {
  const _MessageGlyph({required this.type, required this.colors});

  final AnimalMessageType type;
  final _AnimalMessageColors colors;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    if (theme.isNes) {
      final text = switch (type) {
        AnimalMessageType.info => '!',
        AnimalMessageType.success => '✓',
        AnimalMessageType.warning => '?',
        AnimalMessageType.error => '×',
      };
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colors.accent,
          border: Border.all(color: colors.border, width: 2),
        ),
        child: SizedBox.square(
          dimension: 18,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colors.onAccent,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
        ),
      );
    }

    final icon = switch (type) {
      AnimalMessageType.info => Icons.info_outline_rounded,
      AnimalMessageType.success => Icons.check_circle_outline_rounded,
      AnimalMessageType.warning => Icons.warning_amber_rounded,
      AnimalMessageType.error => Icons.error_outline_rounded,
    };
    return Icon(icon);
  }
}

@immutable
class _AnimalMessageColors {
  const _AnimalMessageColors({
    required this.background,
    required this.foreground,
    required this.border,
    required this.shadow,
    required this.accent,
    required this.lowlight,
    required this.onAccent,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final Color shadow;
  final Color accent;
  final Color lowlight;
  final Color onAccent;

  static _AnimalMessageColors resolve(
    AnimalIslandThemeData theme,
    AnimalMessageType type,
  ) {
    final accent = switch (type) {
      AnimalMessageType.info => theme.primary,
      AnimalMessageType.success => theme.success,
      AnimalMessageType.warning => theme.warning,
      AnimalMessageType.error => theme.error,
    };
    final active = switch (type) {
      AnimalMessageType.info => theme.primaryActive,
      AnimalMessageType.success => theme.successActive,
      AnimalMessageType.warning => theme.warningActive,
      AnimalMessageType.error => theme.errorActive,
    };

    if (theme.isNes) {
      return _AnimalMessageColors(
        background: type == AnimalMessageType.info
            ? theme.surfaceRaised
            : Color.lerp(theme.surfaceRaised, accent, 0.16)!,
        foreground: theme.textPrimary,
        border: theme.border,
        shadow: theme.buttonShadow,
        accent: accent,
        lowlight: active,
        onAccent: type == AnimalMessageType.warning
            ? theme.textPrimary
            : Colors.white,
      );
    }

    if (theme.isWestworld) {
      return _AnimalMessageColors(
        background: theme.surfaceRaised.withValues(alpha: 0.84),
        foreground: theme.textPrimary,
        border: type == AnimalMessageType.info
            ? theme.panelLineColor(emphasized: true)
            : accent.withValues(alpha: 0.78),
        shadow: Colors.transparent,
        accent: accent,
        lowlight: theme.borderLight,
        onAccent: theme.pageBackground,
      );
    }

    if (theme.isGuofengDoodle) {
      return _AnimalMessageColors(
        background: Color.lerp(theme.surface, accent, 0.08)!,
        foreground: theme.textBody,
        border: type == AnimalMessageType.info ? theme.border : accent,
        shadow: theme.inputShadow,
        accent: accent,
        lowlight: active,
        onAccent: Colors.white,
      );
    }

    return _AnimalMessageColors(
      background: Color.lerp(theme.surfaceRaised, accent, 0.12)!,
      foreground: theme.textPrimary,
      border: Color.lerp(theme.borderLight, accent, 0.34)!,
      shadow: theme.buttonShadow,
      accent: accent,
      lowlight: active,
      onAccent: Colors.white,
    );
  }
}

class _WestworldMessagePainter extends CustomPainter {
  const _WestworldMessagePainter({required this.line, required this.accent});

  final Color line;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final paint = Paint()
      ..color = line.withValues(alpha: 0.72)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(10, 0), paint);
    canvas.drawLine(Offset.zero, const Offset(0, 10), paint);
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - 10, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - 10),
      paint,
    );
    canvas.drawCircle(
      Offset(size.width - 9, 9),
      2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = accent.withValues(alpha: 0.72),
    );
  }

  @override
  bool shouldRepaint(covariant _WestworldMessagePainter oldDelegate) {
    return oldDelegate.line != line || oldDelegate.accent != accent;
  }
}
