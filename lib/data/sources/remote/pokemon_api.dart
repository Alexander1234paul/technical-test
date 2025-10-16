import 'package:dio/dio.dart';
import '../../models/pokemon_dto.dart';

class PokemonApi {
  final Dio _dio;

  PokemonApi({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2'));

  Future<List<PokemonDto>> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/pokemon',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        final results = data['results'] as List<dynamic>;
        return results
            .map((e) => PokemonDto.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Response error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }
}
