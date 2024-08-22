import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/globo_model.dart';

class GloboRepository {
  final String apiUrl;

  GloboRepository({required this.apiUrl});

  Future<void> createGlobo(Globo globo) async {
    final response = await http.post(
      Uri.parse('$apiUrl/globos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(globo.toMap()..remove('id')),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create globo');
    }
  }

  Future<List<Globo>> getGlobos() async {
    final response = await http.get(Uri.parse('$apiUrl/globos'));

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<Globo>.from(l.map((model) => Globo.fromMap(model)));
    } else {
      throw Exception('Failed to load globos');
    }
  }

  Future<Globo> getGlobo(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/globos/$id'));

    if (response.statusCode == 200) {
      return Globo.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load globo');
    }
  }

  Future<void> updateGlobo(Globo globo) async {
    final response = await http.put(
      Uri.parse('$apiUrl/globos/${globo.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(globo.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update globo');
    }
  }

  Future<void> deleteGlobo(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/globos/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete globo');
    }
  }
}
