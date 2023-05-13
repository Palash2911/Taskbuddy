import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/views/Userpage.dart';
import 'package:taskbuddy/views/historyPage.dart';
import 'package:taskbuddy/views/homepage.dart';
import 'package:taskbuddy/views/taskpage.dart';

import '../../models/task.dart';
import '../../providers/task_provider.dart';

class MyNavigationBar extends StatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;

  final screens = [TaskPage(), HistoryPage(), UsersScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<List<Tasks>>(
            stream: TaskProvider.readTasks(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError) {
                    print(snapshot);
                    return const SizedBox(
                        height: 500,
                        width: 200,
                        child: Center(child: Text("")));
                  } else {
                    final tasks = snapshot.data;
                    provider.setTodos(tasks!);
                    return screens[_selectedIndex];
                  }
              }
            }),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_add_solid),
              label: 'Assignee',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
