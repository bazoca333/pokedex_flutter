import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool isFavorite;
  final Function onFavoriteToggle;
  final Function onTap;
  final bool isGrid;

  PokemonCard({
    required this.pokemon,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
    required this.isGrid,
  });

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
        shadowColor: typeColors[pokemon.types.first] ?? Colors.grey,
        color: typeColors[pokemon.types.first]?.withOpacity(0.7) ?? Colors.white, // 🔥 Color de la card según el tipo
        child: isGrid
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(pokemon.imageUrl, height: 100, fit: BoxFit.contain),
                  Text(pokemon.name.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey), onPressed: () => onFavoriteToggle()),
                ],
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 10), // 🔹 Espaciado vertical
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // 🔥 Centrar verticalmente
                  children: [
                    SizedBox(width: 10),
                    Image.network(pokemon.imageUrl, width: 80, height: 80),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        pokemon.name.toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    IconButton(
                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey),
                      onPressed: () => onFavoriteToggle(),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
      ),
    );
  }
}
