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
      name: json['name'] ?? 'Desconocido', // 🔥 Evita errores si el nombre es null
      imageUrl: json['sprites']?['other']?['official-artwork']?['front_default'] ??
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/0.png', // 🔥 Imagen por defecto si no hay imagen
      weight: (json['weight'] != null) ? json['weight'] / 10.0 : 0.0, // 🔥 Peso en kg (0.0 si es null)
      height: (json['height'] != null) ? json['height'] / 10.0 : 0.0, // 🔥 Altura en metros (0.0 si es null)
      types: (json['types'] as List?)
              ?.map((typeInfo) => typeInfo['type']?['name'] as String? ?? 'Desconocido')
              .toList() ??
          ['Desconocido'], // 🔥 Si no hay tipos, pone 'Desconocido'
      stats: {
        'HP': json['stats']?[0]?['base_stat'] ?? 0,
        'Ataque': json['stats']?[1]?['base_stat'] ?? 0,
        'Defensa': json['stats']?[2]?['base_stat'] ?? 0,
        'Velocidad': json['stats']?[5]?['base_stat'] ?? 0,
      },
    );
  }
}
