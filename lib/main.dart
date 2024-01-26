import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class Task {
  String description;
  bool completed;

  Task({required this.description, this.completed = false});
}

class TaskList {
  List<Task> tasks = [];
}

class TaskDialog extends StatefulWidget {
  final Function(String) onAdd;

  TaskDialog({required this.onAdd});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Tarea'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(labelText: 'Descripción'),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onAdd(_controller.text);
            Navigator.of(context).pop();
          },
          child: Text('Agregar'),
        ),
      ],
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(bool?)? onToggle;

  TaskItem({required this.task, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.description,
        style: TextStyle(
          decoration: task.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Checkbox(
        value: task.completed,
        onChanged: onToggle,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TaskList taskList = TaskList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
      ),
      body: ListView.builder(
        itemCount: taskList.tasks.length,
        itemBuilder: (context, index) {
          return TaskItem(
            task: taskList.tasks[index],
            onToggle: (completed) {
              setState(() {
                taskList.tasks[index].completed = completed!;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return TaskDialog(
          onAdd: (description) {
            setState(() {
              taskList.tasks.add(Task(description: description));
            });
          },
        );
      },
    );
  }
}
