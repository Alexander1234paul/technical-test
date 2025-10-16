import 'package:hive/hive.dart';

part 'preference_model.g.dart';

@HiveType(typeId: 0)
class PreferenceModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String customName;

  @HiveField(2)
  final String apiName;

  @HiveField(3)
  final String apiUrl;

  PreferenceModel({
    required this.id,
    required this.customName,
    required this.apiName,
    required this.apiUrl,
  });
}
