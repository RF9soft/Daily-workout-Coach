import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  static const String apiKey = '55a1ee85939150c20bef947efebb82d488d7e1f4';
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
