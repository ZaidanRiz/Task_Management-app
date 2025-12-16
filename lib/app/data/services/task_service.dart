// lib/app/data/services/task_service.dart
import 'package:task_management_app/app/data/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('tasks');

  Stream<List<TaskModel>> streamTasks(String uid) {
    return _col(uid)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((d) {
              final data = d.data();
              return TaskModel.fromMap({
                ...data,
                'id': d.id,
              });
            }).toList());
  }

  Future<List<TaskModel>> fetchTasks(String uid) async {
    final qs = await _col(uid).orderBy('createdAt', descending: false).get();
    return qs.docs
        .map((d) => TaskModel.fromMap({
              ...d.data(),
              'id': d.id,
            }))
        .toList();
  }

  Future<void> addTask(String uid, TaskModel task) async {
    final data = task.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    if (task.id.isNotEmpty) {
      await _col(uid).doc(task.id).set(data, SetOptions(merge: true));
    } else {
      await _col(uid).add(data);
      // Jika TaskController mengandalkan id lokal, biarkan Firestore yang menentukan id
    }
  }

  Future<void> deleteTask(String uid, String id) async {
    await _col(uid).doc(id).delete();
  }

  Future<void> updateTask(String uid, TaskModel task) async {
    await _col(uid).doc(task.id).update(task.toMap());
  }
}
