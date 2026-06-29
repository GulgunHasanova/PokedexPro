import 'package:flutter/material.dart';

class Region {
  final String name;
  final String nameAz;
  final int offset;
  final int limit;

  const Region({
    required this.name,
    required this.nameAz,
    required this.offset,
    required this.limit,
  });
}

const List<Region> regions = [
  Region(name: 'All', nameAz: 'Bütün Pokemonlar', offset: 0, limit: 1025),
  Region(name: 'Kanto', nameAz: 'Kanto (Gen 1)', offset: 0, limit: 151),
  Region(name: 'Johto', nameAz: 'Johto (Gen 2)', offset: 151, limit: 100),
  Region(name: 'Hoenn', nameAz: 'Hoenn (Gen 3)', offset: 251, limit: 135),
  Region(name: 'Sinnoh', nameAz: 'Sinnoh (Gen 4)', offset: 386, limit: 107),
  Region(name: 'Unova', nameAz: 'Unova (Gen 5)', offset: 493, limit: 156),
  Region(name: 'Kalos', nameAz: 'Kalos (Gen 6)', offset: 649, limit: 72),
  Region(name: 'Alola', nameAz: 'Alola (Gen 7)', offset: 721, limit: 88),
  Region(name: 'Galar', nameAz: 'Galar (Gen 8)', offset: 809, limit: 89),
  Region(name: 'Paldea', nameAz: 'Paldea (Gen 9)', offset: 898, limit: 127),
];

class TypeDetail {
  final String nameAz;
  final Color color;

  const TypeDetail({
    required this.nameAz,
    required this.color,
  });
}

final Map<String, TypeDetail> typeDetails = {
  'normal': const TypeDetail(nameAz: 'Normal', color: Colors.blueGrey),
  'fire': const TypeDetail(nameAz: 'Atəş', color: Colors.deepOrange),
  'water': const TypeDetail(nameAz: 'Su', color: Colors.blue),
  'electric': const TypeDetail(nameAz: 'Elektrik', color: Colors.amber),
  'grass': const TypeDetail(nameAz: 'Bitki', color: Colors.green),
  'ice': const TypeDetail(nameAz: 'Buz', color: Colors.cyan),
  'fighting': const TypeDetail(nameAz: 'Döyüş', color: Colors.red),
  'poison': const TypeDetail(nameAz: 'Zəhər', color: Colors.purple),
  'ground': const TypeDetail(nameAz: 'Torpaq', color: Colors.brown),
  'flying': const TypeDetail(nameAz: 'Uçan', color: Colors.indigo),
  'psychic': const TypeDetail(nameAz: 'Psixi', color: Colors.pink),
  'bug': const TypeDetail(nameAz: 'Həşərat', color: Colors.lightGreen),
  'rock': const TypeDetail(nameAz: 'Qaya', color: Colors.brown),
  'ghost': const TypeDetail(nameAz: 'Ruh', color: Colors.deepPurpleAccent),
  'dragon': const TypeDetail(nameAz: 'Əjdaha', color: Colors.indigoAccent),
  'steel': const TypeDetail(nameAz: 'Polad', color: Colors.blueGrey),
  'fairy': const TypeDetail(nameAz: 'Pəri', color: Colors.pinkAccent),
  'dark': const TypeDetail(nameAz: 'Qaranlıq', color: Colors.black87),
};

Color getTypeColor(String type) {
  return typeDetails[type.toLowerCase()]?.color ?? Colors.grey;
}

String getTypeNameAz(String type) {
  return typeDetails[type.toLowerCase()]?.nameAz ?? type.toUpperCase();
}

class StatDetail {
  final String nameAz;
  final String shortAz;
  final Color color;

  const StatDetail({
    required this.nameAz,
    required this.shortAz,
    required this.color,
  });
}

final Map<String, StatDetail> statDetails = {
  'hp': const StatDetail(nameAz: 'Sağlamlıq', shortAz: 'HP', color: Colors.green),
  'attack': const StatDetail(nameAz: 'Hücum', shortAz: 'ATK', color: Colors.red),
  'defense': const StatDetail(nameAz: 'Müdafiə', shortAz: 'DEF', color: Colors.blue),
  'special-attack': const StatDetail(nameAz: 'Xüsusi Hücum', shortAz: 'S.ATK', color: Colors.purple),
  'special-defense': const StatDetail(nameAz: 'Xüsusi Müdafiə', shortAz: 'S.DEF', color: Colors.indigo),
  'speed': const StatDetail(nameAz: 'Sürət', shortAz: 'SPD', color: Colors.amber),
};

class AppConstants {
  static const int maxTeamSize = 6;
}

class AppColors {
  static const Color surface = Color(0xFF0F172A);
  static const Color scaffoldBackground = Color(0xFF0B1121);
  static const Color primary = Colors.amber;
  static const Color secondary = Colors.redAccent;
}

class AppStrings {
  static const String appTitlePart1 = 'Pokedex';
  static const String appTitlePart2 = 'Pro';
  static const String teamFullMessage = 'Komandada artıq 6 Pokemon var!';
  static const String tabCatalog = 'Kataloq';
  static const String tabTeam = 'Komandam';
  static const String tabCompare = 'Müqayisə';
  static const String searchHint = 'Pokemon axtar (ad və ya ID)...';
  static const String filterFavorites = 'Favoritlər';
  static const String filterShiny = 'Shiny Mod';
  static const String loadingMessage = 'Pokedex Yüklənir...';
  static const String noResultsTitle = 'Nəticə Tapılmadı';
  static const String noResultsDesc = 'Daxil etdiyiniz kriteriyalara uyğun pokemon tapılmadı.';
  static const String vsText = 'VS';
  static const String teamTitle = 'Komandam';
  static const String teamSubtitle = 'Öz xəyalındakı komandanı qur (Maksimum 6 Pokemon)';
  static const String noTeamTitle = 'Komanda Boşdur';
  static const String noTeamDesc = 'Kataloqa gedərək komandanıza pokemon əlavə edin.';
  static const String selectPokemonToCompare = 'Müqayisə etmək üçün Pokemon seçin';
  static const String selectFirstPokemon = '1-ci Pokemonu Seçin';
  static const String selectSecondPokemon = '2-ci Pokemonu Seçin';
  static const String searchFirstPokemonHint = '1-ci pokemonu axtarın...';
  static const String searchSecondPokemonHint = '2-ci pokemonu axtarın...';
  static const String compareTitle = 'Pokemon Müqayisəsi';
  static const String compareSubtitle = 'İki pokemon seçin və onların güclərini müqayisə edin.';
  static const String compareNoPokemon = 'Müqayisə üçün pokemon yoxdur.';
  static const String pokemon1Label = 'Pokemon 1';
  static const String pokemon2Label = 'Pokemon 2';
}
