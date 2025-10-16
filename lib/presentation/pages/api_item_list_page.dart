import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/pokemon_dto.dart';
import '../../data/sources/remote/pokemon_api.dart';
import '../../logic/api_cubit/api_cubit.dart';
import '../../logic/api_cubit/api_state.dart';
import '../../logic/preference_cubit/preference_cubit.dart';
import '../../core/utils/dialog_utils.dart';

import '../atoms/app_input_atom.dart';
import '../atoms/custom_dialog_atom.dart';
import '../atoms/app_loader_atom.dart';
import '../atoms/app_error_atom.dart';
import '../organisms/poke_list_organism.dart';

class ApiItemListPage extends StatelessWidget {
  const ApiItemListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => ApiCubit(PokemonApi())..fetchPokemons(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista pokemones'),
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onSurface,
        ),
        body: BlocBuilder<ApiCubit, ApiState>(
          builder: (context, state) {
            return switch (state) {
              ApiLoading() => const AppLoaderAtom(),

              ApiError(:final message) => AppErrorAtom(
                message: message,
                onRetry: () => context.read<ApiCubit>().fetchPokemons(),
              ),

              ApiSuccess(:final pokemons) => PokeListOrganism(
                pokemons: pokemons,
                onTap: (poke) => _showPokemonDetail(context, poke),
                onFavorite: (poke) => _showAddPreferenceModal(context, poke),
              ),

              _ => const AppLoaderAtom(message: 'Preparando datos...'),
            };
          },
        ),
      ),
    );
  }

  void _showPokemonDetail(BuildContext context, PokemonDto poke) {
    // Navegación al detalle (opcional)
  }

  Future<void> _showAddPreferenceModal(
    BuildContext context,
    PokemonDto poke,
  ) async {
    final controller = TextEditingController();
    final id = _extractPokemonId(poke.url);
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
    final theme = Theme.of(context);

    await CustomDialogAtom.show(
      context: context,
      title: 'Agregar ${poke.name.toUpperCase()}',
      icon: Icons.add_circle_outline,
      confirmText: 'Guardar',
      cancelText: 'Cancelar',
      confirmColor: theme.colorScheme.primary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.colorScheme.surfaceVariant,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 18),
          AppInputAtom(
            controller: controller,
            label: 'Nombre personalizado',
            hint: 'Ejemplo: Pikachu Favorito',
          ),
        ],
      ),
      onConfirm: () {
        final name = controller.text.trim();

        if (!DialogUtils.validatePreferenceName(context, name)) return;

        if (DialogUtils.isDuplicatePreference(context, poke.url, poke.name)) {
          Navigator.pop(context);
          return;
        }

        context.read<PreferenceCubit>().addPreference(
          customName: name,
          apiName: poke.name,
          apiUrl: poke.url,
        );

        Navigator.pop(context);

        DialogUtils.safeSnack(
          context,
          'Preferencia guardada',
          color: Colors.green.shade400.withOpacity(0.95),
        );
      },
    );

    // Cierre seguro y liberación del controlador
    await Future.delayed(const Duration(milliseconds: 120));
    controller.dispose();
  }

  int _extractPokemonId(String url) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    final idSegment = segments.isNotEmpty ? segments[segments.length - 2] : '0';
    return int.tryParse(idSegment) ?? 0;
  }
}
