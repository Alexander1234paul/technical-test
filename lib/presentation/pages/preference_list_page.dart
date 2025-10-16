import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test/presentation/atoms/app_loader_atom.dart';

import '../../../logic/preference_cubit/preference_cubit.dart';
import '../../../logic/preference_cubit/preference_state.dart';
import '../organisms/preference_list_organism.dart';

class PreferenceListPage extends StatelessWidget {
  const PreferenceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Preferencias'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: BlocBuilder<PreferenceCubit, PreferenceState>(
          builder: (context, state) {
            return switch (state) {
              PreferenceLoading() => const AppLoaderAtom(
                message: 'Cargando tus preferencias...',
              ),

              PreferenceLoaded(:final preferences) => PreferenceListOrganism(
                key: const ValueKey('list'),
                preferences: preferences,
              ),

              //
              _ => const AppLoaderAtom(message: 'Preparando datos...'),
            };
          },
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_add_pref',
        onPressed: () => context.push('/api-list'),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 3,
      ),
    );
  }
}
