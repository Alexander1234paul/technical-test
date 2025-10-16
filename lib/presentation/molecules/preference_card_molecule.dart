import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_radius.dart';
import '../../presentation/atoms/custom_dialog_atom.dart';
import '../../../logic/preference_cubit/preference_cubit.dart';

class PreferenceCardMolecule extends StatelessWidget {
  final String id;
  final String customName;
  final String apiName;
  final String apiUrl;

  const PreferenceCardMolecule({
    super.key,
    required this.id,
    required this.customName,
    required this.apiName,
    required this.apiUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final isSmall = media.size.width < 380;

    final pokemonId = _extractPokemonId(apiUrl);
    final heroTag = 'pref_${id}_$pokemonId';
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png';

    final double imageSize = isSmall ? 46 : 52;
    final double horizontalPadding = isSmall ? AppSpacing.sm : AppSpacing.md;
    final double verticalPadding = isSmall ? AppSpacing.xs : AppSpacing.sm;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      color: theme.cardColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        splashColor: theme.colorScheme.primary.withOpacity(0.08),
        onTap: () => context.push('/prefs/$id'),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
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
                        color: theme.colorScheme.surfaceVariant.withOpacity(
                          0.4,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        size: imageSize * 0.5,
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
                          width: imageSize * 0.4,
                          height: imageSize * 0.4,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmall ? 14 : 16,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Origen: $apiName',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: isSmall ? 12 : 13,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                tooltip: 'Opciones',
                onSelected: (value) {
                  if (value == 'delete') {
                    CustomDialogAtom.showConfirm(
                      context: context,
                      title: 'Eliminar preferencia',
                      message: '¿Deseas eliminar "$customName"?',
                      icon: Icons.warning_amber_rounded,
                      confirmColor: Colors.red.shade400.withOpacity(0.95),

                      onConfirm: () {
                        context.read<PreferenceCubit>().deletePreference(id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('"$customName" fue eliminado'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red.shade400.withOpacity(
                              0.95,
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  } else if (value == 'view') {
                    context.push('/prefs/$id');
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility_outlined, size: 20),
                        SizedBox(width: 8),
                        Text('Ver detalle'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _extractPokemonId(String url) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    final idSegment = segments.isNotEmpty ? segments[segments.length - 2] : '0';
    return int.tryParse(idSegment) ?? 0;
  }
}
