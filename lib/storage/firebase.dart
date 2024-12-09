import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/storage/local_database.dart';

class SyncService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> syncTasks() async {
    final unsyncedTasks = await LocalDatabase().getUnsyncedTasks();

    for (var task in unsyncedTasks) {
      final docRef = firestore.collection('tasks').doc(task['id'].toString());

      await docRef.set({
        'title': task['title'],
        'description': task['description'],
        'status': task['status'],
      });

      await LocalDatabase().updateTask({
        ...task,
        'isSynced': 1,
      });
    }
  }
}
