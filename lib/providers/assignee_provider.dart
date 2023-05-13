import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/assigne.dart';

class AssigneeProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  // List<Assigne> _assignee = [];
  //
  // List<Assigne> get assignees => _assignee.toList();

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
          .collection("Assignee")
          .doc(assigne.id)
          .update({
        "Name": assigne.name,
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
          .collection("Assignee")
          .add({
        "Name": assigne.name,
      });
      assigne.id = asi.id;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static var authUser = FirebaseAuth.instance;

  static Stream<List<Assigne>> readAssignee() => FirebaseFirestore.instance
          .collection("Users")
          .doc(authUser.currentUser!.uid)
          .collection("Assignee")
          .snapshots()
          .map((querySnapshot) {
        List<Assigne> assignelist = [];
        querySnapshot.docs.forEach((element) {
          assignelist.add(
            Assigne(
              id: '',
              name: '',
            ),
          );
        });
        return assignelist;
      });

  // void setAssignee(List<Assigne> assignee) =>
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _assignee = assignee;
  //       notifyListeners();
  //     });
  //
  // void addAssignee(Assigne assigne) => createAssigne(assigne);
  //
  // void updateAssignee(Assigne assigne) => updateAssignee(assigne);
}
