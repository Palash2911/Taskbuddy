import 'package:flutter/material.dart';
import 'package:taskbuddy/views/utils/taskPriority.dart';
import 'package:taskbuddy/views/viewTaskScreen.dart';

import '../../models/task.dart';

class TaskTile extends StatefulWidget {
  final Tasks task;

  const TaskTile({
    super.key,
    required this.task,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {

  bool isCompleted = true;

  @override
  void didChangeDependencies() {
    isCompleted = widget.task.isCompleted;
    super.didChangeDependencies();
  }

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
          value: isCompleted,
          onChanged: (bool? value) {
            setState(() {
              isCompleted = value!;
            });
          },
        ),
        title: Row(
          children: [
            TaskPriority(priority: eTaskPriority.low),
            const SizedBox(width: 8.0),
            Flexible(child: Text(widget.task.title)),
          ],
        ),
        subtitle: Text(widget.task.dueDate),
        trailing: SizedBox(
          width: 150,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.task.assignees.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                  label: Text(widget.task.assignees[index]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
