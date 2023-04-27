import 'package:flutter/material.dart';


class cAppdrawer extends StatefulWidget {
  const cAppdrawer({super.key});

  @override
  State<cAppdrawer> createState() => _cAppdrawerState();
}

class _cAppdrawerState extends State<cAppdrawer> {
  var pp = "";
  var name = "";
  var authToken = "";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xfff1BB273),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: pp.isNotEmpty
                      ? Image.network(pp).image
                      : const AssetImage('assets/images/user.png'),
                ),
                Text(
                  name,
                 
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(' My Profile '),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CircleAvatar()
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('help and support'),
            onTap:(){}
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () {
              
            },
          ),
        ],
      ),
    );
  }
}

