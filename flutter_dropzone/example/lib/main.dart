import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String message1 = 'Drop something here';
  int? firstNumber;

  @override
  Widget build(BuildContext context) {
    final currentNumber = Random().nextInt(1000000);
    print("number:$currentNumber");
    firstNumber ??= currentNumber;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("title"),
        ),
        body: Column(
          children: [
            OutlinedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text("Rebuild")),
            Expanded(
              child: Stack(
                children: [
                  DropzoneView(
                    onDropFiles: (files) {
                      print(
                          'Zone 1:$currentNumber:$firstNumber drop multiple: $files');
                    },
                  ),
                  Center(child: Text(message1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}