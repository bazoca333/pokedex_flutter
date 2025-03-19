import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  // 🔥 Obtiene la lista completa de Pokémon y carga más al hacer scroll
  static Future<List<Pokemon>> fetchAllPokemons() async {
    List<Pokemon> allPokemons = [];
    int offset = 0;
    int limit = 100;

    while (true) {
      final response = await http.get(Uri.parse('$baseUrl?limit=$limit&offset=$offset'));

      if (response.statusCode != 200) {
        throw Exception('Error al obtener los Pokémon');
      }

      final data = json.decode(response.body);
      List<dynamic> results = data['results'];

      if (results.isEmpty) break; // Si no hay más Pokémon, salir del bucle

      // 🔥 Cargar los detalles en paralelo
      List<Future<Pokemon>> requests = results.map((item) async {
        final pokemonResponse = await http.get(Uri.parse(item['url']));
        if (pokemonResponse.statusCode == 200) {
          final pokemonData = json.decode(pokemonResponse.body);
          return Pokemon.fromJson(pokemonData);
        }
        throw Exception('Error al obtener detalles de Pokémon');
      }).toList();

      List<Pokemon> fetchedPokemons = await Future.wait(requests);

      List<Pokemon> processedPokemons = await compute(_processPokemons, fetchedPokemons);
      allPokemons.addAll(processedPokemons);

      offset += limit;
    }

    return allPokemons;
  }

  static List<Pokemon> _processPokemons(List<Pokemon> pokemons) {
    return pokemons.map((p) {
      return Pokemon(
        name: p.name,
        imageUrl: p.imageUrl,
        weight: p.weight,
        height: p.height,
        types: p.types,
        stats: p.stats,
      );
    }).toList();
  }

    static Future<Pokemon> fetchPokemonByName(String name) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$name'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Pokemon.fromJson(data);
      } else {
        throw Exception('Error al obtener los datos de $name (Código: ${response.statusCode})');
      }
    } catch (e) {
      print('❌ Error en fetchPokemonByName: $e');
      throw Exception('No se pudo cargar el Pokémon $name');
    }
    }
}
