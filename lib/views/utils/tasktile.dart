import 'package:flutter/material.dart';
import 'package:taskbuddy/views/homepage.dart';
import 'package:taskbuddy/views/utils/taskPriority.dart';
import 'package:taskbuddy/views/viewTaskScreen.dart';

import '../../models/task.dart';

class TaskTile extends StatefulWidget {
  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewTask(
                  assignename: 'assignename',
                  dueDate: 'dueDate',
                  title: 'title',
                  desc: 'desc',
                  task: task),
            ));
      },
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? value) {
            setState(() {
              task.isCompleted = value!;
            });
          },
        ),
        title: Row(
          children: [
            TaskPriority(priority: eTaskPriority.low),
            SizedBox(width: 8.0),
            Text(task.title),
          ],
        ),
        subtitle: Text(task.dueDate),
        trailing: SizedBox(
          width: 150,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: task.assignees.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                    label: Text(task.assignees[index]),
                    avatar: CircleAvatar(
                      child: Text(task.assigneeProfilePictures[index][0]),
                    )),
              );
            },
          ),
        ),
      ),
    );
  }
}
