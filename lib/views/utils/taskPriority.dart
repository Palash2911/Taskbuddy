import 'package:flutter/material.dart';

enum eTaskPriority { low, medium, high }

class TaskPriority extends StatelessWidget {
  final eTaskPriority priority;

  TaskPriority({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color iconColor;

    switch (priority) {
      case eTaskPriority.high:
        iconColor = Colors.red;
        break;
      case eTaskPriority.medium:
        iconColor = Colors.yellow;
        break;
      case eTaskPriority.low:
      default:
        iconColor = Colors.green;
        break;
    }

    return CircleAvatar(
      radius: 8.0,
      backgroundColor: iconColor,
    );
  }
}
