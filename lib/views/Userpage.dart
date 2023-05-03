import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/views/constants.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
              // _addAssingee(context);
            },
          ),
          Divider(),
          Text('Edit Users',style: kTextPopB16,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Elon musk'),
                    subtitle: Text('9876543210'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                      },
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
