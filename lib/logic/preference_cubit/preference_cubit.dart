import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/preference_model.dart';
import '../../data/repositories/preference_repository.dart';
import 'preference_state.dart';
import 'package:uuid/uuid.dart';

class PreferenceCubit extends Cubit<PreferenceState> {
  final PreferenceRepository repository;

  PreferenceCubit(this.repository) : super(PreferenceInitial());

  Future<void> loadPreferences() async {
    emit(PreferenceLoading());
    try {
      final preferences = await repository.getPreferences();
      emit(PreferenceLoaded(preferences));
    } catch (e) {
      emit(PreferenceError('Error al cargar preferencias: $e'));
    }
  }

  Future<void> addPreference({
    required String customName,
    required String apiName,
    required String apiUrl,
  }) async {
    try {
      // Obtiene la lista actual (para evitar reload innecesario)
      final currentState = state;
      List<PreferenceModel> currentPrefs = [];

      if (currentState is PreferenceLoaded) {
        currentPrefs = List.from(currentState.preferences);
      } else {
        currentPrefs = await repository.getPreferences();
      }

      final alreadyExists = currentPrefs.any(
        (p) => p.apiName == apiName || p.apiUrl == apiUrl,
      );

      if (alreadyExists) {
        emit(PreferenceError('Este Pokémon ya está en tus preferencias.'));
        emit(PreferenceLoaded(currentPrefs)); // restaura lista
        return;
      }

      final newPref = PreferenceModel(
        id: const Uuid().v4(),
        customName: customName,
        apiName: apiName,
        apiUrl: apiUrl,
      );

      await repository.savePreference(newPref);

      final updatedPrefs = List<PreferenceModel>.from(currentPrefs)
        ..add(newPref);
      emit(PreferenceLoaded(updatedPrefs));
    } catch (e) {
      emit(PreferenceError('Error al guardar preferencia: $e'));
    }
  }

  Future<void> deletePreference(String id) async {
    try {
      final currentState = state;
      if (currentState is! PreferenceLoaded) return;

      await repository.deletePreference(id);

      final updatedPrefs = currentState.preferences
          .where((p) => p.id != id)
          .toList();

      emit(PreferenceLoaded(updatedPrefs));
    } catch (e) {
      emit(PreferenceError('Error al eliminar preferencia: $e'));
    }
  }
}
