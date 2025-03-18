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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteDetails();
  }

  // 🏎️ 🚀 Carga ultra rápida con llamadas en paralelo
  void _fetchFavoriteDetails() async {
    if (widget.favoritePokemons.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    try {
      // 🔥 Hacemos todas las llamadas en paralelo para máxima velocidad
      List<Future<Pokemon>> requests = widget.favoritePokemons.map((name) async {
        return ApiService.fetchPokemonByName(name);
      }).toList();

      List<Pokemon> fetchedFavorites = await Future.wait(requests); // 🚀 Cargamos TODO en paralelo

      if (!mounted) return;

      setState(() {
        favoritePokemonDetails = fetchedFavorites;
        isLoading = false;
      });
    } catch (e) {
      print("Error al cargar favoritos: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark; // 🌙 Detecta modo oscuro

    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon Favoritos'),
        backgroundColor: isDarkMode ? Colors.black87 : Colors.redAccent, // 🌓 Cambia el color de la AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.black87, Colors.black54] // 🌙 Fondo oscuro
                : [Colors.redAccent, Colors.orangeAccent, Colors.yellowAccent], // ☀️ Fondo claro
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // 🏎️ Indicador de carga rápida
            : favoritePokemonDetails.isEmpty
                ? Center(
                    child: Text(
                      "No tienes Pokémon favoritos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black, // 🌓 Texto visible en ambos temas
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: favoritePokemonDetails.length,
                    itemBuilder: (context, index) {
                      return PokemonCard(
                        pokemon: favoritePokemonDetails[index],
                        isFavorite: true,
                        onFavoriteToggle: () {},
                        onTap: () {},
                        isGrid: false, // 🔥 Asegura el formato de lista
                      );
                    },
                  ),
      ),
    );
  }
}
