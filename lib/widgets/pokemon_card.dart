import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool isFavorite;
  final Function onFavoriteToggle;
  final Function onTap;

  PokemonCard({required this.pokemon, required this.isFavorite, required this.onFavoriteToggle, required this.onTap});

  final Map<String, Color> typeColors = {
    'fire': Colors.red,
    'water': Colors.blue,
    'grass': Colors.green,
    'electric': Colors.amber,
    'ice': Colors.cyan,
    'fighting': Colors.orange,
    'poison': Colors.deepPurple,
    'ground': Colors.brown,
    'flying': Colors.indigo,
    'psychic': Colors.purple,
    'bug': Colors.lightGreen,
    'rock': Colors.brown[600]!,
    'ghost': Colors.deepPurpleAccent,
    'dragon': Colors.deepOrange,
    'dark': Colors.black54,
    'steel': Colors.blueGrey,
    'fairy': Colors.pinkAccent,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        color: typeColors[pokemon.types.first] ?? Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: pokemon.name,
              child: Image.network(pokemon.imageUrl, height: 100, fit: BoxFit.contain),
            ),
            SizedBox(height: 10),
            Text(pokemon.name.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.white),
              onPressed: () => onFavoriteToggle(),
            ),
          ],
        ),
      ),
    );
  }
}
