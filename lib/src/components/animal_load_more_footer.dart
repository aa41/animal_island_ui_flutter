import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../utils/animal_island_assets.dart';
import 'animal_badge.dart';
import 'animal_button.dart';

class AnimalLoadMoreFooter extends StatelessWidget {
  const AnimalLoadMoreFooter({
    super.key,
    this.state = AnimalLoadMoreState.idle,
    this.onLoadMore,
    this.idleText = 'Walk to the pier for more',
    this.loadingText = 'Kapp’n is bringing more stories...',
    this.noMoreText = 'That is all for today',
    this.errorText = 'The bottle message drifted away',
    this.retryText = 'Try again',
  });

  final AnimalLoadMoreState state;
  final Future<void> Function()? onLoadMore;
  final String idleText;
  final String loadingText;
  final String noMoreText;
  final String errorText;
  final String retryText;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;

    final label = switch (state) {
      AnimalLoadMoreState.loading => loadingText,
      AnimalLoadMoreState.noMore => noMoreText,
      AnimalLoadMoreState.error => errorText,
      AnimalLoadMoreState.idle => idleText,
    };

    final badgeLabel = switch (state) {
      AnimalLoadMoreState.loading => 'Sailing',
      AnimalLoadMoreState.noMore => 'Finished',
      AnimalLoadMoreState.error => 'Oops',
      AnimalLoadMoreState.idle => 'More',
    };

    final badgeColor = switch (state) {
      AnimalLoadMoreState.loading => theme.primary,
      AnimalLoadMoreState.noMore => theme.surfaceSoft,
      AnimalLoadMoreState.error => theme.error,
      AnimalLoadMoreState.idle => theme.focusYellow,
    };

    final badgeForeground = switch (state) {
      AnimalLoadMoreState.loading || AnimalLoadMoreState.error => Colors.white,
      _ => theme.textBody,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.borderLight, width: 2),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.surfaceRaised,
              shape: BoxShape.circle,
              border: Border.all(color: theme.borderLight, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              AnimalIslandAssets.iconLeaf,
              package: AnimalIslandAssets.package,
              width: 18,
              height: 18,
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: theme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (state == AnimalLoadMoreState.loading)
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                backgroundColor: theme.primarySoft,
              ),
            )
          else
            AnimalBadge(
              label: badgeLabel,
              backgroundColor: badgeColor,
              foregroundColor: badgeForeground,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          if (state == AnimalLoadMoreState.idle && onLoadMore != null)
            AnimalButton(
              type: AnimalButtonType.defaultType,
              size: AnimalButtonSize.small,
              onPressed: () => onLoadMore!.call(),
              child: const Text('Load More'),
            ),
          if (state == AnimalLoadMoreState.error && onLoadMore != null)
            AnimalButton(
              type: AnimalButtonType.primary,
              size: AnimalButtonSize.small,
              onPressed: () => onLoadMore!.call(),
              child: Text(retryText),
            ),
        ],
      ),
    );
  }
}
