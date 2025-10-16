import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../data/models/pokemon_dto.dart';
import '../molecules/poke_tile_molecule.dart';

class PokeListOrganism extends StatelessWidget {
  final List<PokemonDto> pokemons;
  final ValueChanged<PokemonDto> onTap;
  final ValueChanged<PokemonDto> onFavorite;

  const PokeListOrganism({
    super.key,
    required this.pokemons,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isSmall = media.size.width < 380;

    if (pokemons.isEmpty) {
      return const Center(
        child: Text(
          'No hay Pokémon disponibles',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final double verticalPadding = isSmall ? AppSpacing.xs : AppSpacing.sm;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        final poke = pokemons[index];
        final id = _extractPokemonId(poke.url);
        final imageUrl =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

        return KeyedSubtree(
          key: ValueKey(poke.name),
          child: PokeTileMolecule(
            poke: poke,
            imageUrl: imageUrl,
            onTap: () => onTap(poke),
            onFavorite: () => onFavorite(poke),
          ),
        );
      },
    );
  }

  int _extractPokemonId(String url) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    final idSegment = segments.isNotEmpty ? segments[segments.length - 2] : '0';
    return int.tryParse(idSegment) ?? 0;
  }
}
