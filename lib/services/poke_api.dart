import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokeApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemonList({int limit = 151, int offset = 0}) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      
      // Fetch details in chunks to avoid overwhelming the server when loading "All"
      List<Pokemon> pokemonList = [];
      const int chunkSize = 50;
      for (int i = 0; i < results.length; i += chunkSize) {
        int end = (i + chunkSize < results.length) ? i + chunkSize : results.length;
        var chunk = results.sublist(i, end);
        
        List<Future<Pokemon>> chunkFutures = chunk.map((e) async {
          final detailRes = await http.get(Uri.parse(e['url']));
          if (detailRes.statusCode == 200) {
            return Pokemon.fromJson(json.decode(detailRes.body));
          } else {
            throw Exception('Failed to load detail for ${e['name']}');
          }
        }).toList();
        
        pokemonList.addAll(await Future.wait(chunkFutures));
      }

      return pokemonList;
    } else {
      throw Exception('Failed to load Pokemon list');
    }
  }

  Future<Pokemon> fetchPokemonDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$id'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Pokemon.fromJson(data);
    } else {
      throw Exception('Failed to load Pokemon details');
    }
  }
}
