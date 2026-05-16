import 'package:flutter/material.dart';

import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';

class AnimalBadge extends StatelessWidget {
  const AnimalBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.surfaceSoft,
        borderRadius: BorderRadius.circular(AnimalIslandTokens.radiusPill),
      ),
      child: Padding(
        padding: padding,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: foregroundColor ?? theme.textSecondary,
          ),
        ),
      ),
    );
  }
}
