import '../models/preference_model.dart';
import '../sources/local/preference_local_datasource.dart';

class PreferenceRepository {
  final PreferenceLocalDatasource local;

  PreferenceRepository(this.local);

  /// Obtiene todas las preferencias guardadas
  Future<List<PreferenceModel>> getPreferences() async {
    return local.getPreferences();
  }

  /// Guarda una nueva preferencia
  Future<void> savePreference(PreferenceModel model) async {
    await local.addPreference(model);
  }

  /// Elimina una preferencia por ID
  Future<void> deletePreference(String id) async {
    await local.deletePreference(id);
  }
}
