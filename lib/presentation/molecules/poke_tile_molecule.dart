import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_radius.dart';
import '../../data/models/pokemon_dto.dart';
import '../atoms/poke_image_atom.dart';
import '../atoms/poke_text_atom.dart';

class PokeTileMolecule extends StatelessWidget {
  final PokemonDto poke;
  final String imageUrl;
  final VoidCallback onFavorite;
  final VoidCallback onTap;
  final bool isFavorite;

  const PokeTileMolecule({
    super.key,
    required this.poke,
    required this.imageUrl,
    required this.onFavorite,
    required this.onTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final isSmall = media.size.width < 380;
    final id = _extractPokemonId(poke.url);

    final double imageRadius = isSmall ? 22 : 26;
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
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        splashColor: theme.colorScheme.primary.withOpacity(0.08),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
            children: [
              PokeImageAtom(
                imageUrl: imageUrl,
                heroTag: 'poke_$id',
                radius: imageRadius,
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: PokeTextAtom(
                  text: poke.name,
                  fontSize: isSmall ? 14 : 16,
                  textAlign: TextAlign.left,
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite
                      ? theme.colorScheme.error
                      : theme.iconTheme.color?.withOpacity(0.8),
                ),
                onPressed: onFavorite,
                splashRadius: AppRadius.xl,
                tooltip: isFavorite
                    ? 'Quitar de favoritos'
                    : 'Agregar favorito',
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
