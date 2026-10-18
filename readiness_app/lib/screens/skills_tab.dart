import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';

class SkillsTab extends StatelessWidget {
  const SkillsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressProvider>();
    return ListView.builder(
      itemCount: skillCatalog.length,
      itemBuilder: (_, i) => CheckboxListTile(
        title: Text(skillCatalog[i].name),
        subtitle: Text('Weight ${skillCatalog[i].weight}'),
        value: p.checkedSkills.contains(i),
        onChanged: (_) => p.toggleSkill(i),
      ),
    );
  }
}
