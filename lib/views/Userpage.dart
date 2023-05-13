import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/views/constants.dart';

import '../models/assigne.dart';
import '../providers/assignee_provider.dart';
import '../providers/auth_provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _editNameController = TextEditingController();
  final _editPhoneController = TextEditingController();
  final GlobalKey<FormState> _addformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _editformKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  CollectionReference assigneeRef =
      FirebaseFirestore.instance.collection('Users');
  var Init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!Init)
      {
        assigneeRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(auth.currentUser!.uid)
            .collection("Assignee");
        _nameController.text = "";
        _phoneController.text = "";
      }
    Init = true;
  }

  Future _editAssignee(String assigneId) async {
    var authProvider = Provider.of<Auth>(context, listen: false);
    var assigneProvider = Provider.of<AssigneeProvider>(context, listen: false);
    final isValid = _editformKey.currentState!.validate();
    _editformKey.currentState!.save();

    if (isValid) {
      var ai = await assigneProvider
          .editAssigne(
        Assigne(
          id: assigneId,
          name: _editNameController.text,
        ),
      )
          .then((value) {
        Fluttertoast.showToast(
          msg: "Assignee Edited Successfully !",
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
      });
    }

  }

  Future _addAssingee(BuildContext ctx) async {
    var authProvider = Provider.of<Auth>(ctx, listen: false);
    var assigneProvider = Provider.of<AssigneeProvider>(ctx, listen: false);
    final isValid = _addformKey.currentState!.validate();
    _addformKey.currentState!.save();

    if (isValid) {
      var ai = await assigneProvider
          .createAssigne(
        Assigne(
          id: "",
          name: _nameController.text,
        ),
      )
          .then((value) {
        setState(() {
          _nameController.text = "";
          _phoneController.text = "";
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
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _editNameController.dispose();
    _editPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            child: Form(
              key: _addformKey,
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        hintText: 'Elon Musk',
                        hintStyle: const TextStyle(fontSize: 14),
                        icon: const Icon(
                          CupertinoIcons.person,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      keyboardType: TextInputType.name,
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
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () {
              _addAssingee(context);
            },
          ),
          Divider(),
          Text(
            'All Assignees',
            style: kTextPopB16,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: assigneeRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 100.0),
                          Text(
                            "No Assignee Yet !",
                            style: kTextPopM16,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((document) {
                        return ListTile(
                          title: Text(document['Name'].toString()),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editNameController.text = document['Name'].toString();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    scrollable: true,
                                    title: const Text(
                                      'Edit Details',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.blue),
                                    ),
                                    content: SizedBox(
                                      height: height * 0.20,
                                      width: width,
                                      child: Form(
                                        key: _editformKey,
                                        child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: _editNameController,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 20,
                                                    vertical: 20,
                                                  ),
                                                  hintText: 'Elon Musk',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 14),
                                                  icon: const Icon(
                                                    CupertinoIcons.person,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please Enter a Name';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      ElevatedButton(
                                        child: const Text('Save'),
                                        onPressed: () {
                                          _editAssignee(document.id);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              // _editAssignee();
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
