import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../services/api_service.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});
  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  late Future<List<LearningTask>> _f = ApiService().fetchTasks();

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressProvider>();
    return FutureBuilder<List<LearningTask>>(
      future: _f,
      builder: (_, s) {
        if (s.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (s.hasError) {
          return Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('Could not load tasks. Check your connection.'),
              TextButton(
                onPressed: () =>
                    setState(() => _f = ApiService().fetchTasks()),
                child: const Text('Retry'),
              ),
            ]),
          );
        }
        final tasks = s.data!;
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, i) => CheckboxListTile(
            title: Text(tasks[i].title),
            value: p.doneTasks.contains(tasks[i].id),
            onChanged: (_) => p.toggleTask(tasks[i].id),
          ),
        );
      },
    );
  }
}
