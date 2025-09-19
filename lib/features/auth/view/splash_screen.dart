import 'dart:async';

import 'package:flutter/material.dart';
import 'package:message_notifier/features/auth/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      // String? authToken = pref.getString('token');
      // bool isLoaggedIn = authToken != null && authToken.isNotEmpty;

      // if (isLoaggedIn) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => HomeScreen()),
      //   );
      // } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,

        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app_icon.jpg'),
          ),
        ),
      ),
    );
  }
}
