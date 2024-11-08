import 'package:flutter/material.dart';
import 'package:sqflite_project/models/task.dart';
import 'package:sqflite_project/pages/services/db_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _task;

  @override
  Widget build(BuildContext context) {
    final databaseServices = DbServices.instance;
    return Scaffold(
      floatingActionButton: _addTaskButton(databaseServices),
      body: _tasksList(databaseServices),
    );
  }

  Widget _addTaskButton(DbServices db) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Add Task"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _task = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Digite aqui...",
                  ),
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  child: const Text(
                    "Salvar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if (_task == null || _task == "") return;
                    db.addTask(_task!);
                    setState(() {
                      _task = null;
                    });

                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _tasksList(DbServices db) {
    return FutureBuilder(
      future: db.getTasks(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            Task task = snapshot.data![index];
            return ListTile(
              onLongPress: () {
                db.deleteTask(task.id);
                setState(() {});
              },
              title: Text(task.content),
              trailing: Checkbox(
                value: task.status == 1,
                onChanged: (value) {
                  db.updateTaskStatus(task.id, value == true ? 1 : 0);
                  setState(() {});
                },
              ),
            );
          },
        );
      },
    );
  }
}
