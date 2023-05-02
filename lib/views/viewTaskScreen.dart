import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:taskbuddy/models/task.dart';
import 'package:taskbuddy/views/constants.dart';
import 'package:taskbuddy/views/utils/edittaskdialog.dart';
import 'package:taskbuddy/views/utils/taskPriority.dart';

class ViewTask extends StatefulWidget {
  final Tasks task;

  const ViewTask({
    super.key,
    required this.task,
  });

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.title,
                      style: kTextPopM16,
                    ),
                    const SizedBox(height: 12.0),
                    Text(widget.task.desc, style: kTextPopR16),
                    const SizedBox(width: 12.0),
                    const Divider(),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.calendar,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Due Date',
                                  style: kTextPopB14,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 2),
                                Text(
                                  widget.task.dueDate,
                                  style: kTextPopR14,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.timer,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Task Priority',
                                  style: kTextPopB14,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 2),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TaskPriority(
                                        priority: widget.task.priority == 0
                                            ? eTaskPriority.high
                                            : widget.task.priority == 1
                                                ? eTaskPriority.medium
                                                : eTaskPriority.low),
                                    SizedBox(width: 5.0),
                                    Text(
                                      widget.task.priority == 0
                                          ? "High"
                                          : widget.task.priority == 1
                                              ? "Medium"
                                              : "Low",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.person_2,
                            ),
                            const SizedBox(width: 5),
                            Text('Task Assigned', style: kTextPopB14),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ListTile(
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CircleAvatar()),
                          title: Text(
                            widget.task.assignees.toString(),
                            style: kTextPopR14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditTaskDialog(
                                task: Tasks(
                                  createdTime: widget.task.createdTime,
                                  id: widget.task.id,
                                  dueDate: widget.task.dueDate,
                                  title: widget.task.title,
                                  desc: widget.task.desc,
                                  assignees: [],
                                  isCompleted: widget.task.isCompleted,
                                  priority: widget.task.priority,
                                ),
                              ),
                            );
                          },
                          child: const Text("Edit Task")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
