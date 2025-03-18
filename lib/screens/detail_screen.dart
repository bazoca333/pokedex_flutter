import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class DetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  DetailScreen({required this.pokemon});

  // Mapeo de traducción de tipos de inglés a español
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

  // Colores asociados a cada tipo
  final Map<String, Color> typeColors = {
    'fire': Colors.red,
    'water': Colors.blue,
    'grass': Colors.green,
    'electric': Colors.amber,
    'rock': Colors.brown,
    'psychic': Colors.purple,
    'ground': Colors.orange,
    'poison': Colors.deepPurple,
    'bug': Colors.lightGreen,
    'flying': Colors.indigo,
    'normal': Colors.grey,
    'ice': Colors.cyan,
    'fighting': Colors.redAccent,
    'ghost': Colors.deepPurpleAccent,
    'dragon': Colors.deepOrange,
    'dark': Colors.black54,
    'steel': Colors.blueGrey,
    'fairy': Colors.pinkAccent,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: typeColors[pokemon.types.first] ?? Colors.grey[200],
      appBar: AppBar(
        title: Text(pokemon.name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: typeColors[pokemon.types.first] ?? Colors.grey[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: pokemon.name,
              child: Image.network(
                pokemon.imageUrl,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 10),

            // Tarjeta con información
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    pokemon.name.toUpperCase(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      Column(
                        children: [
                          Text('Peso', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('${pokemon.weight} kg', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Altura', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('${pokemon.height} m', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Estadísticas base
                  Text('Estadísticas Base', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _buildStatBar('HP', pokemon.stats['HP'] ?? 0, Colors.red),
                  _buildStatBar('Ataque', pokemon.stats['Ataque'] ?? 0, Colors.orange),
                  _buildStatBar('Defensa', pokemon.stats['Defensa'] ?? 0, Colors.blue),
                  _buildStatBar('Velocidad', pokemon.stats['Velocidad'] ?? 0, Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para barra de estadísticas
  Widget _buildStatBar(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: $value', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(height: 5),
          Stack(
            children: [
              Container(
                width: 250,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
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
