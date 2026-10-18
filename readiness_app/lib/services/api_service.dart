import 'dart:convert';
import 'package:http/http.dart' as http;

class LearningTask {
  final int id;
  final String title;
  LearningTask(this.id, this.title);
}

/// Fetches practice tasks from a public REST API (JSONPlaceholder).
class ApiService {
  static const _url = 'https://jsonplaceholder.typicode.com/todos?_limit=15';

  Future<List<LearningTask>> fetchTasks() async {
    final res = await http
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('Server error ${res.statusCode}');
    }
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => LearningTask(e['id'] as int, e['title'] as String))
        .toList();
  }
}
