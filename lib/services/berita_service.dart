import 'dart:convert';
import 'package:http/http.dart' as http;

class BeritaService {
  static const String baseUrl =
      'https://fst.umsida.ac.id/wp-json/wp/v2/posts?_embed';

  Future<List<Map<String, String>>> fetchBerita() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode != 200) return [];

      final List data = json.decode(response.body);

      return data.map<Map<String, String>>((item) {
        return {
          'title': item['title']?['rendered'] ?? '',
          'date': item['date'] ?? '',
          'link': item['link'] ?? '',
          'image': item['_embedded']?['wp:featuredmedia']?[0]?['source_url'] ?? '',
        };
      }).toList();
    } catch (e) {
      print('Error fetchBerita: $e');
      return [];
    }
  }
}
