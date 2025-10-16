import 'package:hive/hive.dart';
import '../../models/preference_model.dart';

class PreferenceLocalDatasource {
  static const String _boxName = 'preferences_box';

  Box<PreferenceModel> get _box => Hive.box<PreferenceModel>(_boxName);

  Future<void> addPreference(PreferenceModel preference) async {
    await _box.put(preference.id, preference);
  }

  List<PreferenceModel> getPreferences() {
    return _box.values.toList();
  }

  Future<void> deletePreference(String id) async {
    await _box.delete(id);
  }

  Future<void> clearPreferences() async {
    await _box.clear();
  }
}
