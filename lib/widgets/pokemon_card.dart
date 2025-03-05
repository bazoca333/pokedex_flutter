import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  PokemonCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        leading: Image.network(pokemon.imageUrl, width: 50, height: 50),
        title: Text(pokemon.name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
