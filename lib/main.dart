import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/providers/assignee_provider.dart';
import 'package:taskbuddy/providers/auth_provider.dart';
import 'package:taskbuddy/providers/task_provider.dart';
import 'package:taskbuddy/views/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => TaskProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => AssigneeProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
