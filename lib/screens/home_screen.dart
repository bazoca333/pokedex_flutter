import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';
import '../widgets/pokemon_card.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  HomeScreen({required this.toggleTheme});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pokemon> allPokemons = [];
  List<Pokemon> displayedPokemons = [];
  Set<String> favoritePokemons = {};
  String searchQuery = "";
  String selectedType = "Todos";
  bool isGrid = false;
  bool isSorted = false;
  int offset = 0;
  bool isLoading = false;

  final List<String> pokemonTypes = [
    "Todos", "Fire", "Water", "Grass", "Electric", "Ice", "Fighting",
    "Poison", "Ground", "Flying", "Psychic", "Bug", "Rock",
    "Ghost", "Dragon", "Dark", "Steel", "Fairy"
  ];

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
    _loadFavorites();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoritePokemons = prefs.getStringList('favorites')?.toSet() ?? {};
    });
  }

  void _toggleFavorite(String pokemonName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoritePokemons.contains(pokemonName)) {
        favoritePokemons.remove(pokemonName);
      } else {
        favoritePokemons.add(pokemonName);
      }
      prefs.setStringList('favorites', favoritePokemons.toList());
    });
  }

  void _fetchPokemons() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      List<Pokemon> pokemons = await ApiService.fetchPokemons(100, offset);
      setState(() {
        allPokemons.addAll(pokemons);
        offset += 100;
        _filterPokemons();
      });
    } catch (e) {
      print("Error al cargar Pokémon: $e");
    }

    setState(() => isLoading = false);
  }

  void _filterPokemons() {
    setState(() {
      displayedPokemons = allPokemons
          .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .where((p) => selectedType == "Todos" || p.types.contains(selectedType.toLowerCase()))
          .toList();
    });
  }

  void _sortPokemons() {
    setState(() {
      isSorted = !isSorted;
      displayedPokemons.sort((a, b) => isSorted ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    });
  }

  void _goToRandomPokemon() {
    if (displayedPokemons.isNotEmpty) {
      final random = Random();
      int randomIndex = random.nextInt(displayedPokemons.length);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(pokemon: displayedPokemons[randomIndex])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark; // 🌙 Detecta si el modo oscuro está activado

    return Scaffold(
      appBar: AppBar(
        title: Text('Pokédex'),
        actions: [
          IconButton(icon: Icon(Icons.shuffle), onPressed: _goToRandomPokemon), // 🔥 Botón de Pokémon Aleatorio
          IconButton(icon: Icon(Icons.star), onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoritesScreen(favoritePokemons: favoritePokemons.toList())),
            );
          }),
          IconButton(icon: Icon(Icons.grid_on), onPressed: () {
            setState(() {
              isGrid = !isGrid;
            });
          }),
          IconButton(icon: Icon(Icons.sort_by_alpha), onPressed: _sortPokemons),
          IconButton(icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode), onPressed: widget.toggleTheme),
        ],
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Buscar Pokémon',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  fillColor: isDarkMode ? Colors.grey[900] : Colors.white, // 🌙 Color del input según el tema
                  filled: true,
                ),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // 🌓 Texto legible en ambos modos
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    _filterPokemons();
                  });
                },
              ),
            ),
            
            // 🔥 Dropdown de filtro por tipo de Pokémon
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[900] : Colors.white, // 🌓 Fondo dinámico para el filtro
                ),
                value: selectedType,
                items: pokemonTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)), // 🌙 Texto legible
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                    _filterPokemons();
                  });
                },
              ),
            ),

            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isGrid ? 2 : 1,
                        childAspectRatio: isGrid ? 1 : 3.5,
                      ),
                      itemCount: displayedPokemons.length,
                      itemBuilder: (context, index) {
                        return PokemonCard(
                          pokemon: displayedPokemons[index],
                          isFavorite: favoritePokemons.contains(displayedPokemons[index].name),
                          onFavoriteToggle: () => _toggleFavorite(displayedPokemons[index].name),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => DetailScreen(pokemon: displayedPokemons[index])),
                            );
                          },
                          isGrid: isGrid,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
