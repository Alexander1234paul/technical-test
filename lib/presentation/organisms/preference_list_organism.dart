import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../molecules/preference_card_molecule.dart';
import '../../../data/models/preference_model.dart';

class PreferenceListOrganism extends StatelessWidget {
  final List<PreferenceModel> preferences;

  const PreferenceListOrganism({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final isSmall = media.size.width < 380;

    final double horizontalPadding = isSmall ? AppSpacing.sm : AppSpacing.md;
    final double verticalPadding = isSmall ? AppSpacing.sm : AppSpacing.md;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: preferences.isEmpty
          ? _buildEmptyState(context, theme)
          : ListView.separated(
              key: const ValueKey('list'),
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              itemCount: preferences.length,
              separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final pref = preferences[index];
                return KeyedSubtree(
                  key: ValueKey(pref.id),
                  child: PreferenceCardMolecule(
                    id: pref.id,
                    customName: pref.customName,
                    apiName: pref.apiName,
                    apiUrl: pref.apiUrl,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    final media = MediaQuery.of(context);
    final isSmall = media.size.width < 380;

    return Center(
      key: const ValueKey('empty'),
      child: Padding(
        padding: EdgeInsets.all(isSmall ? AppSpacing.md : AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: isSmall ? 58 : 72,
              color: theme.colorScheme.primary.withOpacity(0.6),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'No tienes preferencias guardadas aún',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: isSmall ? 14 : 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Agrega tus Pokémon favoritos desde la lista principal.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: isSmall ? 12 : 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
