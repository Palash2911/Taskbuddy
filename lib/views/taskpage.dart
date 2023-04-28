import 'package:flutter/material.dart';
import 'package:taskbuddy/views/createTaskScreen.dart';
import 'package:taskbuddy/views/utils/AppDrawer.dart';
import 'package:taskbuddy/views/utils/bottombar.dart';
import 'package:taskbuddy/views/utils/tasktile.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _emailController = TextEditingController();

  List<String> assigne = [
    "Dip",
    "Palash",
  ];

  String? selectedAssigne;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Buddy',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_add_alt_1_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Add People'),
                    content: TextField(
                      controller: _emailController,
                      decoration:
                          InputDecoration(hintText: 'diphire@mail.com'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      ElevatedButton(
                        child: Text('add'),
                        onPressed: () {
                          final enteredEmail = _emailController.text.trim();
                          Navigator.of(context).pop(enteredEmail);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
        centerTitle: true,
      ),
      drawer: Drawer(
        child: cAppDrawer(),
      ),
      floatingActionButton: FittedBox(
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateTaskScreen()));
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: DropdownButton<String>(
              hint: const Text('Select task assigne'),
              value: selectedAssigne,
              items: assigne.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedAssigne = newValue!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return TaskTile();
              },
            ),
          ),
        ],
      ),
    );
  }
}
