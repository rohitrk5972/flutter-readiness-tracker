import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../services/auth_service.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressProvider>();
    final user = context.read<AuthService>().currentUser ?? '';
    final cs = Theme.of(context).colorScheme;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('Hi, $user', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 16),
      Center(
        child: SizedBox(
          width: 160,
          height: 160,
          child: Stack(alignment: Alignment.center, children: [
            SizedBox.expand(
              child: CircularProgressIndicator(
                  value: p.readiness / 100, strokeWidth: 12),
            ),
            Text('${p.readiness}%',
                style: Theme.of(context).textTheme.displaySmall),
          ]),
        ),
      ),
      const SizedBox(height: 16),
      Center(
          child: Chip(
              backgroundColor: cs.primaryContainer, label: Text(p.verdict))),
      const SizedBox(height: 16),
      _row('Skills checklist (50%)', p.skillPct),
      _row('Quiz score (30%)', p.quizPct),
      _row('Resume keyword match (20%)', p.keywordMatch / 100),
    ]);
  }

  Widget _row(String t, double v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: v, minHeight: 8),
        ]),
      );
}
