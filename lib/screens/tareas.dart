import 'package:flutter/material.dart';

enum TaskStatus { pendiente, enCurso, completada }

class Task {
  final int id;
  final String title;
  final String owner;
  TaskStatus status;
  final String priority;
  final DateTime dueDate;
  Task({required this.id, required this.title, required this.owner, required this.status, required this.priority, required this.dueDate});
}

class TasksScreen extends StatefulWidget {
  static const routeName = '/tareas';
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String filter = 'Todas';
  final tasks = <Task>[
    Task(id: 1, title: 'Inspección frenos', owner: 'Ana', status: TaskStatus.pendiente, priority: 'Alta', dueDate: DateTime.now().add(const Duration(days: 1))),
    Task(id: 2, title: 'Cambio de aceite', owner: 'Luis', status: TaskStatus.enCurso, priority: 'Media', dueDate: DateTime.now().add(const Duration(days: 2))),
    Task(id: 3, title: 'Diagnóstico eléctrico', owner: 'María', status: TaskStatus.completada, priority: 'Baja', dueDate: DateTime.now().add(const Duration(days: 3))),
  ];

  @override
  Widget build(BuildContext context) {
    final statuses = ['Todas','Pendiente','En curso','Completada'];
    List<Task> filtered = tasks.where((t) {
      if (filter == 'Todas') return true;
      if (filter == 'Pendiente') return t.status == TaskStatus.pendiente;
      if (filter == 'En curso') return t.status == TaskStatus.enCurso;
      return t.status == TaskStatus.completada;
    }).toList();

    String statusLabel(TaskStatus s) {
      switch (s) {case TaskStatus.pendiente: return 'Pendiente'; case TaskStatus.enCurso: return 'En curso'; case TaskStatus.completada: return 'Completada';}
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tareas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(children: [
              const Text('Estado: '),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: filter,
                onChanged: (v) => setState(() => filter = v!),
                items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              ),
            ]),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final t = filtered[i];
                  return Card(
                    child: ListTile(
                      title: Text(t.title),
                      subtitle: Text('Resp: ${t.owner} · Prioridad: ${t.priority} · Vence: ${t.dueDate.day}/${t.dueDate.month}'),
                      trailing: DropdownButton<TaskStatus>(
                        value: t.status,
                        onChanged: (v) => setState(() => t.status = v!),
                        items: TaskStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(statusLabel(s)))).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
