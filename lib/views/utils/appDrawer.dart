import 'package:flutter/material.dart';

class cAppDrawer extends StatelessWidget {
  const cAppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue), //BoxDecoration
          child: UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            accountName: Text(
              "Dip Hire",
              style: TextStyle(fontSize: 18),
            ),
            accountEmail: Text("diphire111@gmail.com"),
            currentAccountPictureSize: Size.square(50),
            currentAccountPicture: CircleAvatar(
              child: Text(
                "D",
              ), //Text
            ), //circleAvatar
          ), //UserAccountDrawerHeader
        ), //DrawerHeader
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text(' My Profile '),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('LogOut'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
