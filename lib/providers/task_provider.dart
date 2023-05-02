import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  List<Tasks> _tasks = [];

  // List<Tasks> get tasks =>
  //     _tasks.where((todo) => todo.isCompleted == false).toList();

  List<Tasks> get tasksCompleted =>
      _tasks.where((todo) => todo.isCompleted == true).toList();

  // List<Tasks> get taskslow =>
  //     _tasks.where((todo) => todo.priority == 2).toList();
  //
  // List<Tasks> get taskshigh =>
  //     _tasks.where((todo) => todo.priority == 0).toList();
  //
  // List<Tasks> get tasksmed =>
  //     _tasks.where((todo) => todo.priority == 1).toList();

  List<Tasks> tasksFilter(int priority, String Assignee) {
    if(priority == 3)
      {
          if(Assignee == "All") {
            return _tasks.where((todo) => todo.isCompleted == false).toList();
          }
          else {
            return _tasks.where((todo) => todo.isCompleted == false && todo.assignees.contains(Assignee)).toList();
          }
      }
    else {
      if(Assignee == "All") {
        return _tasks.where((todo) => todo.isCompleted == false && todo.priority == priority).toList();
      }
    }
    return _tasks.where((todo) => todo.isCompleted == false && todo.priority == priority && todo.assignees.contains(Assignee)).toList();
  }

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

  void removeTodo(Tasks task) => deleteTask(task.id);

  bool toggleTodoStatus(Tasks task) {
    task.isCompleted = !task.isCompleted;
    print(task.isCompleted);
    editTask(task);
    return task.isCompleted;
  }
}
