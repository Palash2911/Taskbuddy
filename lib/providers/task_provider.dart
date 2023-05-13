import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  List<Tasks> _tasks = [];

  List<Tasks> get tasksCompleted =>
      _tasks.where((todo) => todo.isCompleted == true).toList();

  List<Tasks> tasksFilter(String priority, String Assignee) {
    if (priority == "All Priority") {
      if (Assignee == "All") {
        return _tasks.where((todo) => todo.isCompleted == false).toList();
      } else {
        return _tasks
            .where((todo) =>
                todo.isCompleted == false && todo.assignees.contains(Assignee))
            .toList();
      }
    } else {
      if (Assignee == "All") {
        if (priority == "High") {
          return _tasks
              .where((todo) => todo.isCompleted == false && todo.priority == 0)
              .toList();
        } else if (priority == "Medium") {
          return _tasks
              .where((todo) => todo.isCompleted == false && todo.priority == 1)
              .toList();
        } else {
          return _tasks
              .where((todo) => todo.isCompleted == false && todo.priority == 2)
              .toList();
        }
      } else {
        if (priority == "High") {
          return _tasks
              .where((todo) =>
                  todo.isCompleted == false &&
                  todo.priority == 0 &&
                  todo.assignees.contains(Assignee))
              .toList();
        } else if (priority == "Medium") {
          return _tasks
              .where((todo) =>
                  todo.isCompleted == false &&
                  todo.priority == 1 &&
                  todo.assignees.contains(Assignee))
              .toList();
        } else {
          return _tasks
              .where((todo) =>
                  todo.isCompleted == false &&
                  todo.priority == 2 &&
                  todo.assignees.contains(Assignee))
              .toList();
        }
      }
    }
  }

  Future editTask(Tasks task) async {
    try {
      await db
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
        "CreatedTime": task.createdTime,
        "Priority": task.priority,
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
        "CreatedTime": task.createdTime,
        "Priority": task.priority,
      });
      task.id = t.id;
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future deleteTask(String taskid) async {
    _tasks.removeWhere((todo) => taskid == todo.id);

    await db
        .collection("Users")
        .doc(auth.currentUser!.uid)
        .collection("Tasks")
        .doc(taskid)
        .delete();
  }

  static var authUser = FirebaseAuth.instance;

  static Stream<List<Tasks>> readTasks() => FirebaseFirestore.instance
          .collection("Users")
          .doc(authUser.currentUser!.uid)
          .collection("Tasks")
          .snapshots()
          .map((querySnapshot) {
        List<Tasks> taskslist = [];
        querySnapshot.docs.forEach((element) {
          taskslist.add(
            Tasks(
              createdTime: element['CreatedTime'],
              id: element.id,
              dueDate: element['Due_Date'],
              title: element['Task_Title'],
              desc: element['Task_Desc'],
              assignees: element['Assignee'],
              isCompleted: element['IsCompleted'],
              priority: element['Priority'],
            ),
          );
        });
        return taskslist;
      });

  // TASKS UPDATE

  void setTodos(List<Tasks> tasks) =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tasks = tasks;
        notifyListeners();
      });

  void addTodo(Tasks task) => createTask(task);

  bool toggleTodoStatus(Tasks task) {
    task.isCompleted = !task.isCompleted;
    print(task.isCompleted);
    editTask(task);
    return task.isCompleted;
  }

  void removeTodo(String taskid) => deleteTask(taskid);
}
