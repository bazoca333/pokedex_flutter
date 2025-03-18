import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  static Future<List<Pokemon>> fetchPokemons(int limit, int offset) async {
    final response = await http.get(Uri.parse('$baseUrl?limit=$limit&offset=$offset'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> results = data['results'];

      List<Pokemon> pokemons = [];
      for (var item in results) {
        final pokemonResponse = await http.get(Uri.parse(item['url']));
        if (pokemonResponse.statusCode == 200) {
          final pokemonData = json.decode(pokemonResponse.body);
          pokemons.add(Pokemon.fromJson(pokemonData));
        }
      }
      return pokemons;
    } else {
      throw Exception('Error al obtener los Pokémon');
    }
  }
}
