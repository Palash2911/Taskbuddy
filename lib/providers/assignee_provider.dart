import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/assigne.dart';

class AssigneeProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future deleteAssigne(String assigneId) async {
    try {
      await db
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .collection("Assignee")
          .doc(assigneId)
          .delete();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future editAssigne(Assigne assigne) async {
    try {
      await db
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .collection("Assignee").doc(assigne.id).update({
        "Name":assigne.name,
        "Contact": assigne.number,
        "TaskId": assigne.taskId,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future createAssigne(Assigne assigne) async {
    try {
      var asi = await db
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .collection("Assignee").add({
        "Name":assigne.name,
        "Contact": assigne.number,
        "TaskId": assigne.taskId,
      });
      assigne.id = asi.id;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
