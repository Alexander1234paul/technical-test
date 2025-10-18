import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/logic/api_cubit/api_cubit.dart';
import 'package:test/logic/api_cubit/api_state.dart';
import 'package:test/data/sources/remote/pokemon_api.dart';
import 'package:test/data/models/pokemon_dto.dart';

class ApiFalsa extends Mock implements PokemonApi {}

void main() {
  late ApiFalsa api;
  late ApiCubit cubit;

  setUp(() {
    api = ApiFalsa();
    cubit = ApiCubit(api);
  });

  tearDown(() => cubit.close());

  test(
    'debe emitir Cargando y luego Exitoso cuando la api responde bien',
    () async {
      when(() => api.getPokemonList()).thenAnswer(
        (_) async => [
          PokemonDto(
            name: 'bulbasaur',
            url: 'https://pokeapi.co/api/v2/pokemon/1/',
          ),
        ],
      );

      expectLater(
        cubit.stream,
        emitsInOrder([isA<ApiLoading>(), isA<ApiSuccess>()]),
      );

      await cubit.fetchPokemons();
    },
  );

  test('debe emitir Cargando y luego Error cuando la api falla', () async {
    when(() => api.getPokemonList()).thenThrow(Exception('error de conexión'));

    expectLater(
      cubit.stream,
      emitsInOrder([isA<ApiLoading>(), isA<ApiError>()]),
    );

    await cubit.fetchPokemons();
  });
}
