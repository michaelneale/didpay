import 'dart:async';
import 'package:http/http.dart' as http;

class RequestCachingService {
  final _cache = <String, dynamic>{};
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get dataStream => _controller.stream;

  Future<void> fetchData(String url) async {
    if (_cache.containsKey(url)) {
      _controller.add({url: _cache[url]});
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      _cache[url] = response.body;
      _controller.add({url: response.body});
    } else {
      throw Exception('Failed to load data from $url');
    }
  }
}