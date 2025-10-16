import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'app.dart';
import 'data/models/preference_model.dart';
import 'data/repositories/preference_repository.dart';
import 'data/sources/local/preference_local_datasource.dart';
import 'logic/preference_cubit/preference_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(PreferenceModelAdapter());
  }
  await Hive.openBox<PreferenceModel>('preferences_box');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              PreferenceCubit(PreferenceRepository(PreferenceLocalDatasource()))
                ..loadPreferences(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
