import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/preference_cubit/preference_cubit.dart';
import '../../../logic/preference_cubit/preference_state.dart';
import '../../../data/models/preference_model.dart';
import '../molecules/preference_detail_molecule.dart';

class PreferenceDetailPage extends StatelessWidget {
  final String preferenceId;

  const PreferenceDetailPage({super.key, required this.preferenceId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Preferencia'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: BlocSelector<PreferenceCubit, PreferenceState, PreferenceModel?>(
        selector: (state) {
          if (state is PreferenceLoaded) {
            try {
              return state.preferences.firstWhere((p) => p.id == preferenceId);
            } catch (_) {
              return null;
            }
          }
          return null;
        },
        builder: (context, pref) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: _buildContent(context, pref),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PreferenceModel? pref) {
    final theme = Theme.of(context);

    if (pref == null) {
      final state = context.read<PreferenceCubit>().state;

      if (state is PreferenceLoading) {
        return const Center(
          key: ValueKey('loading'),
          child: CircularProgressIndicator(),
        );
      }

      return Center(
        key: const ValueKey('not_found'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 60,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
            const SizedBox(height: 12),
            Text(
              'Preferencia no encontrada',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver'),
            ),
          ],
        ),
      );
    }

    return PreferenceDetailMolecule(key: ValueKey(pref.id), preference: pref);
  }
}
