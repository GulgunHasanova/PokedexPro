class PokemonStat {
  final int baseStat;
  final String statName;

  PokemonStat({required this.baseStat, required this.statName});

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      baseStat: json['base_stat'],
      statName: json['stat']['name'],
    );
  }
}

class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<String> types;
  final List<PokemonStat> stats;
  final String imageUrl;
  final String shinyImageUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.stats,
    required this.imageUrl,
    required this.shinyImageUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<String> parsedTypes = [];
    if (json['types'] != null) {
      for (var typeData in json['types']) {
        parsedTypes.add(typeData['type']['name']);
      }
    }

    List<PokemonStat> parsedStats = [];
    if (json['stats'] != null) {
      for (var statData in json['stats']) {
        parsedStats.add(PokemonStat.fromJson(statData));
      }
    }

    int id = json['id'];

    String defaultImageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
    String shinyUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/$id.png';

    // Some pokemon might not have an artwork in standard json, so we use the URL directly
    // based on ID, which is reliable for PokeAPI.
    if (json['sprites'] != null && json['sprites']['other'] != null && json['sprites']['other']['official-artwork'] != null) {
      defaultImageUrl = json['sprites']['other']['official-artwork']['front_default'] ?? defaultImageUrl;
      shinyUrl = json['sprites']['other']['official-artwork']['front_shiny'] ?? shinyUrl;
    }

    return Pokemon(
      id: id,
      name: json['name'],
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      types: parsedTypes,
      stats: parsedStats,
      imageUrl: defaultImageUrl,
      shinyImageUrl: shinyUrl,
    );
  }
}
