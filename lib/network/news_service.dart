import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  static const String apiKey = '2e1da9e6071938978da28da2dea63acadd61669d';
  static const String baseUrl = 'https://google.serper.dev/news';

  Future<List<dynamic>> fetchNews(String query, int page) async {
    final url = Uri.parse(baseUrl);
    final headers = {
      'X-API-KEY': apiKey,
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      "q": query,
      "page": page,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['news']; // Assuming the API returns a 'news' key with the list of articles.
    } else {
      throw Exception('Failed to load news');
    }
  }
}
