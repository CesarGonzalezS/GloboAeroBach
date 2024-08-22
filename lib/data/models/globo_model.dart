class Globo {
  final int id;
  final String nombre;
  final String fabricante;
  final int alturaMaxima;
  final int capacidad;

  Globo({
    required this.id,
    required this.nombre,
    required this.fabricante,
    required this.alturaMaxima,
    required this.capacidad,
  });

  // Método para convertir un Map (como el de una consulta SQL) en un objeto Globo
  factory Globo.fromMap(Map<String, dynamic> map) {
    return Globo(
      id: map['id'],
      nombre: map['nombre'],
      fabricante: map['fabricante'],
      alturaMaxima: map['alturaMaxima'],
      capacidad: map['capacidad'],
    );
  }

  // Método para convertir un objeto Globo en un Map (por ejemplo, para insertarlo en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'fabricante': fabricante,
      'alturaMaxima': alturaMaxima,
      'capacidad': capacidad,
    };
  }
}
