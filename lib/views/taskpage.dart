import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/models/assigne.dart';
import 'package:taskbuddy/providers/assignee_provider.dart';
import 'package:taskbuddy/providers/task_provider.dart';
import 'package:taskbuddy/views/utils/AppDrawer.dart';
import 'package:taskbuddy/views/utils/dialog_box.dart';
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
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
                      scrollable: true,
                      title: const Text(
                        'Add People',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                      content: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox(
                              height: height * 0.35,
                              width: width,
                              child: Form(
                                key: _formKey,
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 20,
                                          ),
                                          hintText: 'Elon Musk',
                                          hintStyle:
                                              const TextStyle(fontSize: 14),
                                          icon: const Icon(
                                            CupertinoIcons.person,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter a Name';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextFormField(
                                        controller: _phoneController,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 20,
                                          ),
                                          hintText: '+91 98XXXXXXXX',
                                          hintStyle:
                                              const TextStyle(fontSize: 14),
                                          icon: const Icon(
                                            CupertinoIcons.phone,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
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
              showDialog(
                  context: context, builder: (context) => AddTaskAlertDialog());
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 50.0,
                    decoration: kInputBox,
                    child: DropdownButton<String>(
                      underline: SizedBox(),
                      hint: const Text('Assignee'),
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 50.0,
                    decoration: kInputBox,
                    child: DropdownButton<String>(
                      underline: const SizedBox(),
                      hint: const Text('Priority'),
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
                ),
              ],
            ),
            taskList.isEmpty
                ? const Padding(
                  padding:  EdgeInsets.only(top: 50.0),
                  child: Center(
                      child: Text(
                        "No Current Task Created !",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                )
                : SizedBox(
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
      ),
    );
  }
}
