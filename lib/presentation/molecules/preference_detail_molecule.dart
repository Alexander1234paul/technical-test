import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../../data/models/preference_model.dart';

class PreferenceDetailMolecule extends StatelessWidget {
  final PreferenceModel preference;

  const PreferenceDetailMolecule({super.key, required this.preference});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final isSmall = media.size.width < 380;

    final id = _extractPokemonId(preference.apiUrl);
    final heroTag = 'pref_${preference.id}_$id';
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

    final double imageSize = isSmall ? 110 : 140;
    final double fontSizeTitle = isSmall ? 18 : 22;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: heroTag,
                  child: ClipOval(
                    child: Image.network(
                      imageUrl,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: imageSize,
                        height: imageSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: imageSize * 0.3,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          width: imageSize,
                          height: imageSize,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant.withOpacity(
                              0.3,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox(
                            width: imageSize * 0.2,
                            height: imageSize * 0.2,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                Text(
                  preference.customName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeTitle,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Nombre API: ${preference.apiName}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                Divider(height: AppSpacing.lg, color: theme.dividerColor),
                SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
    );
  }

  int _extractPokemonId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return 0;
    final segments = uri.pathSegments;
    final idSegment = segments.isNotEmpty ? segments[segments.length - 2] : '0';
    return int.tryParse(idSegment) ?? 0;
  }
}
