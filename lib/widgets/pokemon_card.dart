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
    'ghost': const Color.fromARGB(255, 72, 1, 119),
    'dragon': const Color.fromARGB(255, 119, 17, 253),
    'dark': Color(0xFF444444),
    'steel': Colors.blueGrey,
    'fairy': Colors.pinkAccent,
  };

  @override
  Widget build(BuildContext context) {
    // 🔥 Obtiene los colores de los tipos
    List<Color> colors = pokemon.types
        .map((type) => typeColors[type] ?? Colors.grey)
        .toList();

    // 🔥 Si hay un solo tipo, usamos solo ese color, si hay dos, creamos degradado
    Color startColor = colors.isNotEmpty ? colors.first : Colors.grey;
    Color endColor = colors.length > 1 ? colors[1] : startColor;

    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        shadowColor: startColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [startColor.withOpacity(0.8), endColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: isGrid
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 100),
                      child: Image.network(
                        pokemon.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 80, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        pokemon.name.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () => onFavoriteToggle(),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Row(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 80, maxHeight: 80),
                        child: Image.network(
                          pokemon.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 60, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          pokemon.name.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: () => onFavoriteToggle(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
