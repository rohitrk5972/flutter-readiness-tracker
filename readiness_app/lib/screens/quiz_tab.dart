import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';

class Q {
  final String q;
  final List<String> o;
  final int a;
  const Q(this.q, this.o, this.a);
}

const questions = <Q>[
  Q('Which widget rebuilds when its state changes?', ['StatelessWidget', 'StatefulWidget', 'Container', 'Text'], 1),
  Q('Which symbol marks a type as nullable in Dart?', ['?', '!', 'late', 'var'], 0),
  Q('Which package is commonly used for ChangeNotifier-based state management?', ['http', 'provider', 'crypto', 'intl'], 1),
  Q('What does async/await help with?', ['Styling', 'Asynchronous code', 'Routing', 'Testing only'], 1),
  Q('Which call reads a value saved with SharedPreferences?', ['prefs.getString', 'prefs.fetch', 'prefs.open', 'prefs.load'], 0),
  Q('Which widget builds a long list lazily?', ['Column', 'ListView.builder', 'Row', 'Stack'], 1),
  Q('HTTP status 200 means?', ['Not found', 'Server error', 'OK', 'Unauthorized'], 2),
  Q('What does Navigator.push do?', ['Closes the app', 'Opens a new route', 'Clears storage', 'Starts a timer'], 1),
];

class QuizTab extends StatefulWidget {
  const QuizTab({super.key});
  @override
  State<QuizTab> createState() => _QuizTabState();
}

class _QuizTabState extends State<QuizTab> {
  final Map<int, int> _ans = {};
  bool _done = false;

  void _submit() {
    var s = 0;
    _ans.forEach((i, v) {
      if (questions[i].a == v) s++;
    });
    context.read<ProgressProvider>().setQuiz(s, questions.length);
    setState(() => _done = true);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressProvider>();
    return ListView(padding: const EdgeInsets.all(16), children: [
      if (p.quizTotal > 0)
        Card(
          child: ListTile(
            leading: const Icon(Icons.emoji_events),
            title: Text('Last score: ${p.quizScore}/${p.quizTotal}'),
          ),
        ),
      for (var i = 0; i < questions.length; i++) ...[
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text('${i + 1}. ${questions[i].q}',
              style: Theme.of(context).textTheme.titleSmall),
        ),
        for (var j = 0; j < questions[i].o.length; j++)
          ListTile(
            dense: true,
            leading: Icon(_ans[i] == j
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked),
            title: Text(questions[i].o[j]),
            subtitle: _done && questions[i].a == j
                ? const Text('Correct answer')
                : null,
            onTap: () => setState(() => _ans[i] = j),
          ),
      ],
      const SizedBox(height: 12),
      FilledButton(
        onPressed: _ans.length == questions.length ? _submit : null,
        child: const Text('Submit quiz'),
      ),
    ]);
  }
}
