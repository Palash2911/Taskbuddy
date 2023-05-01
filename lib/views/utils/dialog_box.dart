import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskbuddy/views/constants.dart';

// class DialogBox extends StatefulWidget {
//   @override
//   State<DialogBox> createState() => _DialogBoxState();
// }

// class _DialogBoxState extends State<DialogBox> {
//   List<String> assigne = [
//     "Dip",
//     "Palash",
//   ];

//   String? selectedCategory;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _taskTitleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();

//   String get driveTitle => _taskTitleController.text;
//   String get description => _descriptionController.text;
//   String get date => _dateController.text;

//   var isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     setFields();
//   }

//   @override
//   void dispose() {
//     _taskTitleController.dispose();
//     _descriptionController.dispose();
//     _dateController.dispose();
//     super.dispose();
//   }

//   void setFields() {
//     _taskTitleController.text = "";
//     _descriptionController.text = "";
//     _dateController.text = "";

//     selectedCategory = assigne.first;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Add Task'),
//       content: Container(
//         height: double.infinity,
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 textInputAction: TextInputAction.next,
//                 controller: _taskTitleController,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a Task Title';
//                   }
//                   return null;
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Write the title of the Task',
//                   alignLabelWithHint: true,
//                   labelText: 'Task Title',
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               TextFormField(
//                 textInputAction: TextInputAction.next,
//                 minLines: 1,
//                 maxLines: 10,
//                 controller: _descriptionController,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter description';
//                   }
//                   return null;
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Write short task description',
//                   alignLabelWithHint: true,
//                   labelText: 'Task description',
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 width: double.infinity,
//                 height: 50.0,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: DropdownButton<String>(
//                   hint: const Text('Select task assigne'),
//                   value: selectedCategory,
//                   items: assigne.map((category) {
//                     return DropdownMenuItem<String>(
//                       value: category,
//                       child: Text(category),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       selectedCategory = newValue!;
//                     });
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               Padding(
//                 padding: const EdgeInsets.only(right: 10.0),
//                 child: TextFormField(
//                   textInputAction: TextInputAction.next,
//                   controller: _dateController,
//                   decoration: InputDecoration(
//                     hintText: "Due Date",
//                     hintStyle: kTextPopR14,
//                     icon: const Icon(Icons.calendar_today_rounded),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Date Not Set !';
//                     }
//                     return null;
//                   },
//                   readOnly: true,
//                   onTap: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(1950),
//                         lastDate: DateTime(2024));
//                     if (pickedDate != null) {
//                       String formattedDate =
//                           DateFormat.yMMMMd('en_US').format(pickedDate);
//                       setState(() {
//                         _dateController.text = formattedDate;
//                       });
//                     } else {}
//                   },
//                 ),
//               ),
//               SizedBox(height: 10.0),
//               ElevatedButton(
//                 onPressed: () {},
//                 child: Text(
//                   'Add Task',
//                   style: kTextPopB16,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class AddTaskAlertDialog extends StatefulWidget {
  const AddTaskAlertDialog({super.key});

  @override
  State<AddTaskAlertDialog> createState() => _AddTaskAlertDialogState();
}

class _AddTaskAlertDialogState extends State<AddTaskAlertDialog> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'New Task',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.brown),
      ),
      content: SizedBox(
        height: height * 0.35,
        width: width,
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  hintText: 'Task',
                  hintStyle: const TextStyle(fontSize: 14),
                  icon: const Icon(CupertinoIcons.square_list,
                      color: Colors.brown),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
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
                  icon: const Icon(CupertinoIcons.bubble_left_bubble_right,
                      color: Colors.brown),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: const <Widget>[
                  Icon(CupertinoIcons.tag, color: Colors.brown),
                  SizedBox(width: 15.0),
                
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Save'),
        ),
      ],
    );
  }
}
