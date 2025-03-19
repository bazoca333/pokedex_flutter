import 'dart:math';
import 'package:flutter/foundation.dart';
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
  bool isLoading = false;
  bool hasMore = true; 
  ScrollController _scrollController = ScrollController();

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
    _scrollController.addListener(_onScroll);
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
    if (isLoading || !hasMore) return;
    setState(() => isLoading = true);

    try {
      List<Pokemon> pokemons = await ApiService.fetchAllPokemons();

      if (!mounted) return;

      setState(() {
        allPokemons = pokemons;
        _filterPokemons();
        hasMore = false;
      });
    } catch (e) {
      print("Error al cargar Pokémon: $e");
    }

    setState(() => isLoading = false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _fetchPokemons(); 
    }
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pokédex'),
        actions: [
          IconButton(icon: Icon(Icons.shuffle), onPressed: _goToRandomPokemon),
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
            colors: isDarkMode ? [Colors.black87, Colors.black54] : [Colors.white70, Colors.white54],
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
                  fillColor: isDarkMode ? Colors.grey[900] : Colors.white,
                  filled: true,
                ),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    _filterPokemons();
                  });
                },
              ),
            ),
            Expanded(
              child: isLoading && allPokemons.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!isLoading && scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                          _fetchPokemons();
                        }
                        return false;
                      },
                      child: isGrid
                          ? GridView.builder(
                              controller: _scrollController,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.9, 
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
                            )
                          : ListView.builder(
                              controller: _scrollController,
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
            ),
          ],
        ),
      ),
    );
  }
}
