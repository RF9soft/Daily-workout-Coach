import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ApiHeaders.dart';

class ApiService {
  static const String baseUrl = 'https://exercisedb.p.rapidapi.com';

  Future<List<Map<String, dynamic>>> fetchExercisesByPage(int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl/exercises?page=$page'),
      headers: ApiHeaders.getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
