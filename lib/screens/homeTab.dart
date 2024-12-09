import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/screens/addTask.dart';
import 'package:task_manager/storage/connectivity.dart';
import 'package:task_manager/storage/firebase.dart';
import 'package:task_manager/storage/local_database.dart';

class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<Map<String, String>> tasks = [];
  final LocalDatabase localDb = LocalDatabase();
  final ConnectivityService connectivityService = ConnectivityService();
  final SyncService syncService = SyncService();

  @override
  void initState() {
    super.initState();
    monitorConnectivity();
    loadTasks();
  }

  void monitorConnectivity() {
    connectivityService.connectivityStream.listen((result) {
      if (result != ConnectivityResult.none) {
        syncTasks();
      }
    });
  }

  Future<void> syncTasks() async {
    try {
      await syncService.syncTasks();
      print("Tasks synchronized successfully.");
    } catch (error) {
      print("Error syncing tasks: $error");
    }
  }

  Future<void> loadTasks() async {
    final List<Map<String, dynamic>> loadedTasks = await localDb.getTasks();
    setState(() {
      tasks.clear();
      tasks.addAll(
        loadedTasks.map((task) => task.cast<String, String>()),
      );
    });
  }

  void addTask(BuildContext context) async {
    final newTask = await showModalBottomSheet<Map<String, String>>(
      context: context,
      // isScrollControlled: true,
      builder: (BuildContext context) {
        return AddTask();
      },
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
      });

      await localDb.insertTask({
        'title': newTask['title']!,
        'description': newTask['description']!,
        'status': newTask['status'] ?? 'Pending',
        'isSynced': 0,
      });
    }
  }

  Future<void> editTask(
      BuildContext context, Map<String, String> taskToEdit, int index) async {
    final updatedTask = await showModalBottomSheet<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AddTask(taskToEdit: taskToEdit);
      },
    );

    if (updatedTask != null) {
      setState(() {
        tasks[index] = updatedTask;
      });

      await localDb.updateTask({
        'id': taskToEdit['id'],
        'title': updatedTask['title']!,
        'description': updatedTask['description']!,
        'status': updatedTask['status'] ?? 'Pending',
        'isSynced': 0,
      });
    }
  }

  Future<void> deleteTask(int index) async {
    final taskToDelete = tasks[index];

    setState(() {
      tasks.removeAt(index);
    });

    if (taskToDelete.containsKey('id')) {
      await localDb.deleteTask(int.parse(taskToDelete['id']!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          addTask(context);
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task['title']!),
                  subtitle: Text(task['description']!),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task['status']!,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      IconButton(
                        onPressed: () {
                          editTask(context, task, index);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      IconButton(
                        onPressed: () {
                          deleteTask(index);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
