import 'package:flutter/material.dart';
import 'package:taskbuddy/models/task.dart';
import 'package:taskbuddy/views/constants.dart';

class ViewTask extends StatefulWidget {
  final String assignename;
  final String dueDate;
  final String title;
  final String desc;
  final Task task;

  const ViewTask({
    super.key,
    required this.assignename,
    required this.dueDate,
    required this.title,
    required this.desc,
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
                      widget.title,
                      style: kTextPopM16,
                    ),
                    const SizedBox(height: 12.0),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today),
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
                                widget.dueDate,
                                style: kTextPopB14,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(widget.desc, style: kTextPopR16),
                    const SizedBox(width: 12.0),
                    const Divider(),
                    Column(
                      children: [
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.task),
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
                            widget.assignename,
                            style: kTextPopM16,
                          ),
                        ),
                        ListTile(
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CircleAvatar()),
                          title: Text(
                            widget.assignename,
                            style: kTextPopM16,
                          ),
                        ),
                        Divider(),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.task),
                            const SizedBox(width: 5),
                            Text('Task Assigned by', style: kTextPopB14),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ListTile(
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CircleAvatar()),
                          title: Text(
                            widget.assignename,
                            style: kTextPopM16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
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
