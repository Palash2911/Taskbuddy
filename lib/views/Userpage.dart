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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  CollectionReference assigneeRef = FirebaseFirestore.instance.collection('Users');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assigneeRef = FirebaseFirestore.instance.collection('Users').doc(auth.currentUser!.uid).collection("Assignee");
  }

  Future _editAssignee() async {
    var authProvider = Provider.of<Auth>(context, listen: false);
    var assigneProvider = Provider.of<AssigneeProvider>(context, listen: false);
  }

  Future _addAssingee(BuildContext ctx) async {
    var authProvider = Provider.of<Auth>(ctx, listen: false);
    var assigneProvider = Provider.of<AssigneeProvider>(ctx, listen: false);
    final isValid = _formKey.currentState!.validate();
    _formKey.currentState!.save();

    if (isValid) {
      var ai = await assigneProvider
          .createAssigne(
        Assigne(
          id: "",
          name: _nameController.text,
          number: _phoneController.text,
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
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            child: Form(
              key: _formKey,
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        hintText: '+91 98XXXXXXXX',
                        hintStyle: const TextStyle(fontSize: 14),
                        icon: const Icon(
                          CupertinoIcons.phone,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
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
                          SizedBox(
                            height: 300.0,
                            child: Image.asset(
                              'assets/images/noPost.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 20.0),
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
                          subtitle: Text(document['Contact'].toString()),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editAssignee();
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
