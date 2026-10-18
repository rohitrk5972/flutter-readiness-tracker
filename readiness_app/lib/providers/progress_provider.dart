import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkillDef {
  final String name;
  final int weight;
  const SkillDef(this.name, this.weight);
}

const skillCatalog = <SkillDef>[
  SkillDef('Dart fundamentals (null safety, async/await)', 3),
  SkillDef('Widgets, layouts and navigation', 3),
  SkillDef('State management (Provider / Riverpod / Bloc)', 3),
  SkillDef('REST API integration (http / dio, JSON)', 3),
  SkillDef('Local storage (SharedPreferences / SQLite / Hive)', 2),
  SkillDef('Firebase (Auth, Firestore)', 2),
  SkillDef('Push notifications (FCM)', 1),
  SkillDef('Git & GitHub workflow', 2),
  SkillDef('Testing and debugging (DevTools)', 2),
  SkillDef('Responsive UI and theming', 1),
];

class ProgressProvider extends ChangeNotifier {
  String? _user;
  final Set<int> checkedSkills = {};
  final Set<int> doneTasks = {};
  int quizScore = 0;
  int quizTotal = 0;
  int keywordMatch = 0;

  String get _key => 'progress_${_user ?? "guest"}';

  void bindUser(String? user) {
    if (user == _user) return;
    _user = user;
    checkedSkills.clear();
    doneTasks.clear();
    quizScore = quizTotal = keywordMatch = 0;
    if (user != null) _load();
    notifyListeners();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_key);
    if (raw == null) return;
    final m = jsonDecode(raw) as Map<String, dynamic>;
    checkedSkills.addAll(List<int>.from(m['skills'] ?? []));
    doneTasks.addAll(List<int>.from(m['tasks'] ?? []));
    quizScore = m['quizScore'] ?? 0;
    quizTotal = m['quizTotal'] ?? 0;
    keywordMatch = m['keywordMatch'] ?? 0;
    notifyListeners();
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(
      _key,
      jsonEncode({
        'skills': checkedSkills.toList(),
        'tasks': doneTasks.toList(),
        'quizScore': quizScore,
        'quizTotal': quizTotal,
        'keywordMatch': keywordMatch,
      }),
    );
  }

  void toggleSkill(int i) {
    checkedSkills.contains(i) ? checkedSkills.remove(i) : checkedSkills.add(i);
    _save();
    notifyListeners();
  }

  void toggleTask(int id) {
    doneTasks.contains(id) ? doneTasks.remove(id) : doneTasks.add(id);
    _save();
    notifyListeners();
  }

  void setQuiz(int score, int total) {
    quizScore = score;
    quizTotal = total;
    _save();
    notifyListeners();
  }

  void setKeywordMatch(int pct) {
    keywordMatch = pct;
    _save();
    notifyListeners();
  }

  double get skillPct {
    final total = skillCatalog.fold<int>(0, (s, e) => s + e.weight);
    var got = 0;
    for (final i in checkedSkills) {
      got += skillCatalog[i].weight;
    }
    return got / total;
  }

  double get quizPct => quizTotal == 0 ? 0 : quizScore / quizTotal;

  /// 50% self-assessed skills, 30% quiz, 20% resume keyword coverage.
  int get readiness =>
      ((skillPct * 0.5 + quizPct * 0.3 + (keywordMatch / 100) * 0.2) * 100)
          .round();

  String get verdict {
    final r = readiness;
    if (r >= 75) return 'Internship ready';
    if (r >= 50) return 'Almost there - strengthen weak areas';
    return 'Keep building - focus on the basics';
  }
}
