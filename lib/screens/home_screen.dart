import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';
import '../widgets/pokemon_card.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

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

  FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  final Map<String, String> typeTranslations = {
    'Todos': 'Todos',
    'fire': 'Fuego',
    'water': 'Agua',
    'grass': 'Planta',
    'electric': 'Eléctrico',
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

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
    _loadFavorites();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    notificationsPlugin.initialize(settings);
  }

  void _showNotification(String pokemonName) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'favoritos_channel',
      'Favoritos',
      importance: Importance.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await Future.delayed(Duration(seconds: 3));
    await notificationsPlugin.show(0, "Pokédex", "¡$pokemonName ahora es tu favorito!", details);
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
        _showNotification(pokemonName);
      }
      prefs.setStringList('favorites', favoritePokemons.toList());
    });
  }

  void _fetchPokemons() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      List<Pokemon> pokemons = await ApiService.fetchPokemons(50, offset);
      setState(() {
        allPokemons.addAll(pokemons);
        offset += 50;
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

  void _showRandomPokemon() {
    final random = Random();
    final randomPokemon = displayedPokemons[random.nextInt(displayedPokemons.length)];
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(pokemon: randomPokemon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokédex'),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FavoritesScreen(favoritePokemons: favoritePokemons.toList())),
              );
            },
          ),
          IconButton(icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode), onPressed: widget.toggleTheme),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(labelText: 'Buscar Pokémon', prefixIcon: Icon(Icons.search)),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterPokemons();
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: DropdownButton<String>(
              value: selectedType,
              isExpanded: true,
              items: typeTranslations.values.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
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
            child: NotificationListener<ScrollEndNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  _fetchPokemons();
                }
                return false;
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isGrid ? 2 : 1),
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
