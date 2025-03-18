import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../widgets/pokemon_card.dart';
import '../services/api_service.dart';

class FavoritesScreen extends StatefulWidget {
  final List<String> favoritePokemons;

  FavoritesScreen({required this.favoritePokemons});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Pokemon> favoritePokemonDetails = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteDetails();
  }

  void _fetchFavoriteDetails() async {
    List<Pokemon> allPokemons = await ApiService.fetchPokemons(100, 0);
    setState(() {
      favoritePokemonDetails = allPokemons.where((p) => widget.favoritePokemons.contains(p.name)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokémon Favoritos')),
      body: ListView.builder(
        itemCount: favoritePokemonDetails.length,
        itemBuilder: (context, index) {
          return PokemonCard(
            pokemon: favoritePokemonDetails[index],
            isFavorite: true,
            onFavoriteToggle: () {},
            onTap: () {},
          );
        },
      ),
    );
  }
}
