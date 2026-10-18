import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';

const flutterKeywords = <String>[
  'flutter', 'dart', 'provider', 'riverpod', 'bloc', 'rest', 'api', 'firebase',
  'firestore', 'json', 'state management', 'widgets', 'git', 'github',
  'push notifications', 'sqlite', 'shared preferences', 'testing', 'null safety',
  'async', 'responsive', 'material',
];

class MatcherTab extends StatefulWidget {
  const MatcherTab({super.key});
  @override
  State<MatcherTab> createState() => _MatcherTabState();
}

class _MatcherTabState extends State<MatcherTab> {
  final _c = TextEditingController();
  List<String> _hit = [];
  List<String> _miss = [];
  bool _ran = false;

  void _run() {
    final t = _c.text.toLowerCase();
    final hit = flutterKeywords.where(t.contains).toList();
    final miss = flutterKeywords.where((k) => !t.contains(k)).toList();
    context
        .read<ProgressProvider>()
        .setKeywordMatch((hit.length * 100 / flutterKeywords.length).round());
    setState(() {
      _hit = hit;
      _miss = miss;
      _ran = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Paste your resume text to check Flutter keyword coverage.'),
      const SizedBox(height: 8),
      TextField(
        controller: _c,
        maxLines: 8,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      const SizedBox(height: 8),
      FilledButton(onPressed: _run, child: const Text('Analyze')),
      if (_ran) ...[
        const SizedBox(height: 16),
        Text('Matched (${_hit.length})',
            style: Theme.of(context).textTheme.titleSmall),
        Wrap(spacing: 6, children: [
          for (final k in _hit) Chip(label: Text(k)),
        ]),
        const SizedBox(height: 12),
        Text('Missing (${_miss.length})',
            style: Theme.of(context).textTheme.titleSmall),
        Wrap(spacing: 6, children: [
          for (final k in _miss) Chip(label: Text(k)),
        ]),
      ],
    ]);
  }
}
