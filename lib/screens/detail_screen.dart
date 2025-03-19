import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class DetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  DetailScreen({required this.pokemon});

  // Traducción de tipos de inglés a español
  final Map<String, String> typeTranslations = {
    'normal': 'Normal',
    'fire': 'Fuego',
    'water': 'Agua',
    'electric': 'Eléctrico',
    'grass': 'Planta',
    'ice': 'Hielo',
    'fighting': 'Lucha',
    'poison': 'Veneno',
    'ground': 'Tierra',
    'flying': 'Volador',
    'psychic': 'Psíquico',
    'bug': 'Bicho',
    'rock': 'Roca',
    'ghost': 'Fantasma',
    'dragon': 'Dragón',
    'dark': 'Siniestro',
    'steel': 'Acero',
    'fairy': 'Hada',
  };

  // Colores de tipo
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark; // Detectar modo oscuro
    Color backgroundColor = typeColors[pokemon.types.first] ?? (isDarkMode ? Colors.black87 : Colors.grey[200]!);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          pokemon.name.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: typeColors[pokemon.types.first] ?? Colors.grey[700],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: pokemon.name,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black54 : Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(
                  pokemon.imageUrl,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Tarjeta con información
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black54 : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    pokemon.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Tipos de Pokémon con chips de colores
                  Wrap(
                    spacing: 8,
                    children: pokemon.types.map((type) {
                      return Chip(
                        label: Text(
                          typeTranslations[type] ?? type,
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: typeColors[type] ?? Colors.grey,
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 20),

                  // Información sobre peso y altura
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoCard("Peso", "${pokemon.weight} kg", isDarkMode),
                      _buildInfoCard("Altura", "${pokemon.height} m", isDarkMode),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Estadísticas base
                  Text(
                    'Estadísticas Base',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildStatBar('HP', pokemon.stats['HP'] ?? 0, Colors.red, isDarkMode),
                  _buildStatBar('Ataque', pokemon.stats['Ataque'] ?? 0, Colors.orange, isDarkMode),
                  _buildStatBar('Defensa', pokemon.stats['Defensa'] ?? 0, Colors.blue, isDarkMode),
                  _buildStatBar('Velocidad', pokemon.stats['Velocidad'] ?? 0, Colors.green, isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para la información de peso y altura
  Widget _buildInfoCard(String title, String value, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black38 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Widget para barra de estadísticas
  Widget _buildStatBar(String label, int value, Color color, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Stack(
            children: [
              Container(
                width: 250,
                height: 10,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                width: (value / 150) * 250, // Normalizando la barra a 250 px
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
