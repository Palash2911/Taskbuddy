import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/views/Login.dart';

import '../providers/auth_provider.dart';
import 'constants.dart';
import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadScreen();
  }

  Future loadScreen() async {
    var authProvider = Provider.of<Auth>(context, listen: false);
    Future.delayed(const Duration(seconds: 2), () async {
      await authProvider.autoLogin().then((_) async {
        if (authProvider.isAuth) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (ctx) => HomePage(),
          ));
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => LoginScreen()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: ksecondaryColor,
          body: Center(
            child: SizedBox(
              height: 350.0,
              child: Image.asset(
                'assets/gala.png',
                fit: BoxFit.contain,
              ),
            ),
          )),
    );
  }
}
