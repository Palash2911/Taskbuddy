import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:taskbuddy/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future deleteTask(String taskId) async {
    await db
        .collection("Users")
        .doc(auth.currentUser!.uid)
        .collection("Tasks")
        .doc(taskId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  Future editTask(Tasks task) async {
    try {
      var t = await db
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .collection("Tasks")
          .doc(task.id)
          .update({
        "Due_Date": task.dueDate,
        "Assignee": task.assignees,
        "Task_Desc": task.desc,
        "Task_Title": task.title,
        "IsCompleted": task.isCompleted,
      });
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future createTask(Tasks task) async {
    try {
      var t = await db
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .collection("Tasks")
          .add({
        "Due_Date": task.dueDate,
        "Assignee": task.assignees,
        "Task_Desc": task.desc,
        "Task_Title": task.title,
        "IsCompleted": task.isCompleted,
      });
      task.id = t.id;
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
