  class Pokemon {
    final String name;
    final String imageUrl;
    final double weight;
    final double height;
    final List<String> types;
    final Map<String, int> stats;

    Pokemon({
      required this.name,
      required this.imageUrl,
      required this.weight,
      required this.height,
      required this.types,
      required this.stats,
    });

    factory Pokemon.fromJson(Map<String, dynamic> json) {
      return Pokemon(
        name: json['name'],
        imageUrl: json['sprites']['other']['official-artwork']['front_default'],
        weight: (json['weight'] / 10), // Conversión a kg
        height: (json['height'] / 10), // Conversión a metros
        types: (json['types'] as List)
            .map((typeInfo) => typeInfo['type']['name'] as String)
            .toList(),
        stats: {
          'HP': json['stats'][0]['base_stat'],
          'Ataque': json['stats'][1]['base_stat'],
          'Defensa': json['stats'][2]['base_stat'],
          'Velocidad': json['stats'][5]['base_stat'],
        },
      );
    }
  }
