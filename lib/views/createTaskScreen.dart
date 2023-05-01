import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/models/task.dart';
import 'package:taskbuddy/providers/task_provider.dart';
import 'package:taskbuddy/views/constants.dart';
import 'package:intl/intl.dart';
import 'package:taskbuddy/views/taskpage.dart';

class CreateTaskScreen extends StatefulWidget {
  final List<dynamic> assignee;
  CreateTaskScreen({super.key, required this.assignee});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final auth = FirebaseAuth.instance;
  var isInit = true;

  String? selectedAssigne;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String get taskTitle => _taskTitleController.text;
  String get description => _descriptionController.text;
  String get date => _dateController.text;

  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setFields();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void setFields() {
    _taskTitleController.text = "";
    _descriptionController.text = "";
    _dateController.text = "";
    selectedAssigne = widget.assignee.first;
  }

  Future addTask() async {
    setState(() {
      isLoading = true;
    });
    var taskProvider = Provider.of<TaskProvider>(context, listen: false);
    await taskProvider
        .createTask(
      Tasks(
        createdTime: DateTime.now().toString(),
        id: "",
        dueDate: date,
        title: taskTitle,
        desc: description,
        assignees: ["Self"],
        isCompleted: false,
      ),
    )
        .then((value) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Task Created Successfully !",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const BottomAppBar()),
      );
    });
  }

  final List<String> options = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5'
  ];
  List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Task')),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _taskTitleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Task Title';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Write the title of the Task',
                            alignLabelWithHint: true,
                            labelText: 'Task Title',
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          minLines: 1,
                          maxLines: 10,
                          controller: _descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Write short task description',
                            alignLabelWithHint: true,
                            labelText: 'Task description',
                          ),
                        ),
                        const SizedBox(height: 10.0),
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
                            items: widget.assignee.map((category) {
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
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _dateController,
                            decoration: InputDecoration(
                              hintText: "Due Date",
                              hintStyle: kTextPopR14,
                              icon: const Icon(Icons.calendar_today_rounded),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Date Not Set !';
                              }
                              return null;
                            },
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2024));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat.yMMMMd('en_US')
                                        .format(pickedDate);
                                setState(() {
                                  _dateController.text = formattedDate;
                                });
                              } else {}
                            },
                          ),
                        ),
                        MultiSelectFormField(
                          autovalidate: AutovalidateMode.disabled,
                          title: Text('Select Options'),
                          dataSource: options.map((String option) {
                            return {'display': option, 'value': option};
                          }).toList(),
                          textField: 'display',
                          valueField: 'value',
                          okButtonLabel: 'OK',
                          cancelButtonLabel: 'CANCEL',
                          initialValue: selectedOptions,
                          onSaved: (value) {
                            if (value == null) return;
                            setState(() {
                              selectedOptions = List<String>.from(value);
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: addTask,
                          child: Text(
                            'Add Task',
                            style: kTextPopB16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
