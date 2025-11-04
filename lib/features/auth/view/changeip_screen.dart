import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:message_notifier/config/api_constants.dart';
import 'package:message_notifier/core/services/shared_prefs_service.dart';

class ChangeipScreen extends StatefulWidget {
  const ChangeipScreen({super.key});

  @override
  State<ChangeipScreen> createState() => _ChangeipScreenState();
}

class _ChangeipScreenState extends State<ChangeipScreen> {
  final ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: ipController,
              // decoration: InputDecoration(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (ipController.text.isNotEmpty) {
                  await SharedPrefsService.storeIp(ipController.text);
                  exit(0);
                }
              },
              child: Text('Save'),
            ),

            SizedBox(height: 20),

            Text('Current : ${ApiConstants.baseUrl}'),
          ],
        ),
      ),
    );
  }
}
