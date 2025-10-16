import 'package:equatable/equatable.dart';
import '../../data/models/pokemon_dto.dart';

abstract class ApiState extends Equatable {
  const ApiState();

  @override
  List<Object?> get props => [];
}

class ApiInitial extends ApiState {}

class ApiLoading extends ApiState {}

class ApiSuccess extends ApiState {
  final List<PokemonDto> pokemons;
  const ApiSuccess(this.pokemons);

  @override
  List<Object?> get props => [pokemons];
}

class ApiError extends ApiState {
  final String message;
  const ApiError(this.message);

  @override
  List<Object?> get props => [message];
}
