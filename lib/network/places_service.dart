import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesService {
  static const String apiUrl = 'https://google.serper.dev/places';
  static const Map<String, String> headers = {
    'X-API-KEY': '55a1ee85939150c20bef947efebb82d488d7e1f4',
    'Content-Type': 'application/json'
  };

  static Future<List<dynamic>> fetchNearbyGyms(String query, int page) async {
    var request = http.Request('POST', Uri.parse(apiUrl));
    request.body = json.encode({
      "q": query,
      "gl": "us",
      "hl": "en",
      "autocorrect": true,
      "page": page
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      return jsonResponse['places'];
    } else {
      throw Exception('Failed to load gyms');
    }
  }
}