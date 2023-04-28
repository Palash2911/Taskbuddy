import 'package:flutter/material.dart';
import 'package:taskbuddy/models/task.dart';
import 'package:taskbuddy/views/utils/AppDrawer.dart';
import 'package:taskbuddy/views/utils/bottombar.dart';
import 'package:taskbuddy/views/utils/dialog_box.dart';
import 'package:taskbuddy/views/utils/tasktile.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Buddy',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: cAppDrawer(),
      ),
      floatingActionButton: FittedBox(
        child: FloatingActionButton.extended(
          onPressed: () {
            _showAddTaskDialog(context);
          },
          icon: const Icon(
            Icons.add,
            size: 30,
          ),
          label: Text(
            "Add Task",
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          bool _isChecked = false;
          List<String> assignees = [
            "Palash",
            "Dip",
            "Hire",
          ];
          return TaskTile();
        },
      ),
    );
  }

  final assigneeNameController = TextEditingController();
  final dueDateController = TextEditingController();
  final titleController = TextEditingController();
  final descController = TextEditingController();

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogBox();
      },
    );
  }
}
