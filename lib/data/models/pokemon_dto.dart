class PokemonDto {
  final String name;
  final String url;

  PokemonDto({required this.name, required this.url});

  factory PokemonDto.fromJson(Map<String, dynamic> json) {
    return PokemonDto(name: json['name'] as String, url: json['url'] as String);
  }
}
