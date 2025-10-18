import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/logic/preference_cubit/preference_cubit.dart';
import 'package:test/logic/preference_cubit/preference_state.dart';
import 'package:test/data/models/preference_model.dart';
import 'package:test/data/repositories/preference_repository.dart';

class MockPreferenceRepository extends Mock implements PreferenceRepository {}

class FakePreferenceModel extends Fake implements PreferenceModel {}

void main() {
  late PreferenceCubit cubit;
  late MockPreferenceRepository repo;

  setUpAll(() {
    registerFallbackValue(FakePreferenceModel());
  });

  setUp(() {
    repo = MockPreferenceRepository();
    cubit = PreferenceCubit(repo);
  });

  tearDown(() => cubit.close());

  group('PreferenceCubit', () {
    test('emite Loading y luego Loaded cuando carga bien', () async {
      final prefs = [
        PreferenceModel(
          id: '1',
          customName: 'Pikachu Favorito',
          apiName: 'pikachu',
          apiUrl: 'https://pokeapi.co/api/v2/pokemon/25/',
        ),
      ];

      when(() => repo.getPreferences()).thenAnswer((_) async => prefs);

      expectLater(
        cubit.stream,
        emitsInOrder([isA<PreferenceLoading>(), isA<PreferenceLoaded>()]),
      );

      await cubit.loadPreferences();
    });

    test('emite Loading y luego Error si hay excepción', () async {
      when(() => repo.getPreferences()).thenThrow(Exception('error'));

      expectLater(
        cubit.stream,
        emitsInOrder([isA<PreferenceLoading>(), isA<PreferenceError>()]),
      );

      await cubit.loadPreferences();
    });

    test('agrega una preferencia nueva', () async {
      when(() => repo.getPreferences()).thenAnswer((_) async => []);
      when(() => repo.savePreference(any())).thenAnswer((_) async {});

      await cubit.addPreference(
        customName: 'Mi Pikachu',
        apiName: 'pikachu',
        apiUrl: 'https://pokeapi.co/api/v2/pokemon/25/',
      );

      final state = cubit.state;
      expect(state, isA<PreferenceLoaded>());
      final list = (state as PreferenceLoaded).preferences;
      expect(list.length, 1);
      expect(list.first.apiName, 'pikachu');
    });

    test('emite Error si ya existe el mismo', () async {
      final pref = PreferenceModel(
        id: '1',
        customName: 'Charmander',
        apiName: 'charmander',
        apiUrl: 'https://pokeapi.co/api/v2/pokemon/4/',
      );

      when(() => repo.getPreferences()).thenAnswer((_) async => [pref]);

      expectLater(
        cubit.stream,
        emitsInOrder([isA<PreferenceError>(), isA<PreferenceLoaded>()]),
      );

      await cubit.addPreference(
        customName: 'Charmander',
        apiName: 'charmander',
        apiUrl: 'https://pokeapi.co/api/v2/pokemon/4/',
      );
    });

    test('elimina una preferencia', () async {
      final pref = PreferenceModel(
        id: '1',
        customName: 'Bulbasaur',
        apiName: 'bulbasaur',
        apiUrl: 'https://pokeapi.co/api/v2/pokemon/1/',
      );

      when(() => repo.deletePreference(any())).thenAnswer((_) async {});

      cubit.emit(PreferenceLoaded([pref]));
      await cubit.deletePreference(pref.id);

      final state = cubit.state;
      expect(state, isA<PreferenceLoaded>());
      expect((state as PreferenceLoaded).preferences, isEmpty);
    });
  });
}
