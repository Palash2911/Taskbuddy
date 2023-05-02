import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/models/assigne.dart';
import 'package:taskbuddy/views/constants.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import '../../models/task.dart';
import '../../providers/task_provider.dart';
import '../homepage.dart';

class EditTaskDialog extends StatefulWidget {
  final Tasks task;

  const EditTaskDialog({super.key, required this.task});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  String? selectedCategory;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _assigneeController = TextEditingController();

  String get driveTitle => _taskTitleController.text;
  String get description => _descriptionController.text;
  String get date => _dateController.text;
  String get assignee => _assigneeController.text;

  var isLoading = false;
  String ngoType = "";
  List<Type> type = [
    Type('High', false),
    Type('Medium', false),
    Type('Low', false),
  ];

  final List<String> options = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5'
  ];
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    setFields();
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void setFields() {
    _taskTitleController.text = widget.task.title;
    _descriptionController.text = widget.task.desc;
    _dateController.text = widget.task.dueDate;
    if (widget.task.priority == 0) {
      type[0].isSelected = true;
    } else if (widget.task.priority == 1) {
      type[1].isSelected = true;
    } else {
      type[2].isSelected = true;
    }
    setState(() {});
  }

  List<String> assigne = [
    "All",
    "Self",
  ];

  String? selectedAssigne;

  Future editTask() async {
    setState(() {
      isLoading = true;
    });
    var taskProvider = Provider.of<TaskProvider>(context, listen: false);
    await taskProvider
        .editTask(
      Tasks(
        createdTime: DateTime.now().toString(),
        id: widget.task.id,
        dueDate: date,
        title: driveTitle,
        desc: description,
        assignees: ["Self"],
        isCompleted: false,
        priority: type[0].isSelected
            ? 0
            : type[1].isSelected
                ? 1
                : 2,
      ),
    )
        .then((value) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Task Edited Successfully !",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (ctx) => const BottomAppBar()),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: AlertDialog(
        scrollable: true,
        title: const Text(
          'New Task',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.blue),
        ),
        content: SizedBox(
          height: height * 0.50,
          width: width,
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _taskTitleController,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      hintText: 'Task',
                      hintStyle: const TextStyle(fontSize: 14),
                      icon: const Icon(
                        CupertinoIcons.square_list,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      hintText: 'Description',
                      hintStyle: const TextStyle(fontSize: 14),
                      icon: const Icon(
                        CupertinoIcons.bubble_left_bubble_right,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _dateController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        hintText: 'Due Date',
                        hintStyle: const TextStyle(fontSize: 14),
                        icon: const Icon(
                          CupertinoIcons.calendar,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
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
                              DateFormat.yMMMMd('en_US').format(pickedDate);
                          setState(() {
                            _dateController.text = formattedDate;
                          });
                        } else {}
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Row(
                  //   children: <Widget>[
                  //     Icon(
                  //       CupertinoIcons.person_2,
                  //     ),
                  //     SizedBox(width: 15.0),
                  //     Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Container(
                  //         padding: const EdgeInsets.all(10),
                  //         height: 50.0,
                  //         decoration: kInputBox,
                  //         child: DropdownButton<String>(
                  //           underline: SizedBox(),
                  //           hint: const Text('Priority'),
                  //           // value: selectedAssigne,
                  //           items: assigne.map((category) {
                  //             return DropdownMenuItem<String>(
                  //               value: category,
                  //               child: Text(category),
                  //             );
                  //           }).toList(),
                  //           onChanged: (newValue) {
                  //             setState(() {
                  //               selectedAssigne = newValue!;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: <Widget>[
                      const Icon(
                        CupertinoIcons.timer,
                      ),
                      const SizedBox(width: 15.0),
                      SizedBox(
                        height: 50,
                        width: 180,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: type.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    type.forEach(
                                        (types) => types.isSelected = false);
                                    type[index].isSelected = true;
                                    ngoType = type[index].name;
                                  });
                                },
                                child: RawChip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  label: Text(
                                    type[index].name,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: !type[index].isSelected
                                            ? Colors.blue
                                            : Colors.white),
                                  ),
                                  backgroundColor: !type[index].isSelected
                                      ? Colors.white
                                      : Colors.blue,
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(
                        CupertinoIcons.person_2,
                      ),
                      SizedBox(width: 15.0),
                      Flexible(
                        child: Container(
                          decoration: kInputBox,
                          padding: EdgeInsets.all(2.0),
                          child: MultiSelectFormField(
                            hintWidget: const SizedBox(),
                            autovalidate: AutovalidateMode.disabled,
                            title: const Text('Assigne'),
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.grey,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              editTask();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => HomePage(),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class Type {
  String name;
  bool isSelected;

  Type(this.name, this.isSelected);
}
