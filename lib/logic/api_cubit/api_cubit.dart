import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/sources/remote/pokemon_api.dart';
import 'api_state.dart';

class ApiCubit extends Cubit<ApiState> {
  final PokemonApi api;

  ApiCubit(this.api) : super(ApiInitial());

  Future<void> fetchPokemons() async {
    emit(ApiLoading());
    try {
      final list = await api.getPokemonList();
      emit(ApiSuccess(list));
    } catch (e) {
      emit(ApiError(e.toString()));
    }
  }
}
