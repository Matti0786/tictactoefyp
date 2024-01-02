import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<bool> checkSignin() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? signin = prefs.getBool('signin');
    return signin != null ? signin : false;
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool? signin = prefs.getBool('signin');
      if (signin == true)
        Navigator.popAndPushNamed(context, '/mainMenu');
      else
        Navigator.popAndPushNamed(context, '/signin');
      // Navigator.pushReplacementNamed(context, '/signin');

      // Navigator.popAndPushNamed(context, '/signin');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('images/logo.png'),
    );
  }
}
