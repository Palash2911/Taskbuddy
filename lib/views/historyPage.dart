import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/views/utils/tasktile.dart';

import '../providers/task_provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final taskList = provider.tasksCompleted;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Gala Task',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          taskList.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Text(
                      "No Task Completed !",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  height: 500,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    separatorBuilder: (context, index) => Container(height: 8),
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      final task = taskList[index];
                      return TaskTile(task: task);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  final assigneeNameController = TextEditingController();
  final dueDateController = TextEditingController();
  final titleController = TextEditingController();
  final descController = TextEditingController();
}
