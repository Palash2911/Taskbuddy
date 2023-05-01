import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/models/assigne.dart';
import 'package:taskbuddy/models/task.dart';
import 'package:taskbuddy/providers/assignee_provider.dart';
import 'package:taskbuddy/providers/task_provider.dart';
import 'package:taskbuddy/views/createTaskScreen.dart';
import 'package:taskbuddy/views/utils/AppDrawer.dart';
import 'package:taskbuddy/views/utils/bottombar.dart';
import 'package:taskbuddy/views/utils/tasktile.dart';

import '../providers/auth_provider.dart';
import 'constants.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> assigne = [
    "All",
    "Self",
  ];

  var isLoading = false;
  String? selectedAssigne;
  final auth = FirebaseAuth.instance;
  var isInit = true;
  CollectionReference? assigneeRef;
  CollectionReference taskRef = FirebaseFirestore.instance.collection("Users");

  @override
  void initState() {
    _nameController.text = "";
    _phoneController.text = "";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      getAssignee();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  Future getAssignee() async {
    assigneeRef = await FirebaseFirestore.instance
        .collection("Users")
        .doc(auth.currentUser!.uid)
        .collection('Assignee')
        .get()
        .then((value) {
      if (value.size > 0) {
        value.docs.forEach((element) {
          assigne.add(element["Name"]);
        });
      }
      return null;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future _addAssingee(BuildContext ctx) async {
    var authProvider = Provider.of<Auth>(ctx, listen: false);
    var assigneProvider = Provider.of<AssigneeProvider>(ctx, listen: false);
    final isValid = _formKey.currentState!.validate();
    setState(() {
      isLoading = true;
    });
    _formKey.currentState!.save();

    if (isValid) {
      var ai = await assigneProvider
          .createAssigne(
        Assigne(
          id: "",
          name: _nameController.text,
          number: _phoneController.text,
          taskId: [],
        ),
      )
          .then((value) {
        setState(() {
          _nameController.text = "";
          _phoneController.text = "";
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "Assignee Added Successfully !",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      setState(() {
        Fluttertoast.showToast(
          msg: "Please Fill Details !",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final taskList = provider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Buddy',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person_add_alt_1_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Add People'),
                    content: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Form(
                            key: _formKey,
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                        hintText: 'John Delta'),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter a Name';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: _phoneController,
                                    decoration: const InputDecoration(
                                        hintText: '+911234567890'),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter a Number';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      ElevatedButton(
                        child: const Text('Add'),
                        onPressed: () {
                          _addAssingee(context);
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
      drawer: const Drawer(
        child: cAppDrawer(),
      ),
      floatingActionButton: FittedBox(
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTaskScreen(
                  assignee: assigne,
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.add,
            size: 30,
          ),
          label: const Text(
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
              hint: const Text('Select Task Assignee'),
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
          taskList.isEmpty
              ? const Center(
                  child: Text(
                    "No Current Task Created ",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: 400,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
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
}
