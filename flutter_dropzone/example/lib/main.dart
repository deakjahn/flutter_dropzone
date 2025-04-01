// ignore_for_file: avoid_print

import 'dart:async' show Completer;
import 'dart:math' show min;
import 'dart:typed_data' show Uint8List, BytesBuilder;

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DropzoneViewController controller1;
  late DropzoneViewController controller2;
  String message1 = 'Drop something here';
  String message2 = 'Drop something here';
  bool highlighted1 = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Dropzone example')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: highlighted1 ? Colors.red : Colors.transparent,
              child: Stack(
                children: [buildZone1(context), Center(child: Text(message1))],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [buildZone2(context), Center(child: Text(message2))],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              print(
                await controller1.pickFiles(mime: ['image/jpeg', 'image/png']),
              );
            },
            child: const Text('Pick file'),
          ),
        ],
      ),
    ),
  );

  Widget buildZone1(BuildContext context) => Builder(
    builder:
        (context) => DropzoneView(
          operation: DragOperation.copy,
          cursor: CursorType.grab,
          onCreated: (ctrl) => controller1 = ctrl,
          onLoaded: () => print('Zone 1 loaded'),
          onError: (error) => print('Zone 1 error: $error'),
          onHover: () {
            setState(() => highlighted1 = true);
            print('Zone 1 hovered');
          },
          onLeave: () {
            setState(() => highlighted1 = false);
            print('Zone 1 left');
          },
          onDropFile: (file) async {
            print('Zone 1 drop: ${file.name}');
            setState(() {
              message1 = '${file.name} dropped';
              highlighted1 = false;
            });
            final bytes = await controller1.getFileData(file);
            print('Read bytes with length ${bytes.length}');
            print(bytes.sublist(0, min(bytes.length, 20)));
          },
          onDropString: (s) {
            print('Zone 1 drop: $s');
            setState(() {
              message1 = 'text dropped';
              highlighted1 = false;
            });
            print(s.substring(0, min(s.length, 20)));
          },
          onDropInvalid: (mime) => print('Zone 1 invalid MIME: $mime'),
          onDropFiles: (files) => print('Zone 1 drop multiple: $files'),
          onDropStrings: (strings) => print('Zone 1 drop multiple: $strings'),
        ),
  );

  Widget buildZone2(BuildContext context) => Builder(
    builder:
        (context) => DropzoneView(
          operation: DragOperation.move,
          mime: const ['image/jpeg'],
          onCreated: (ctrl) => controller2 = ctrl,
          onLoaded: () => print('Zone 2 loaded'),
          onError: (error) => print('Zone 2 error: $error'),
          onHover: () => print('Zone 2 hovered'),
          onLeave: () => print('Zone 2 left'),
          onDropFile: (DropzoneFileInterface file) async {
            print('Zone 2 drop: ${file.name}');
            setState(() {
              message2 = '${file.name} dropped';
            });
            final fileStream = controller2.getFileStream(file);
            final bytes = await collectBytes(fileStream);
            print('Streamed bytes with length ${bytes.length}');
            print(bytes.sublist(0, min(bytes.length, 20)));
          },
          onDropString: (s) {
            print('Zone 2 drop: $s');
            setState(() {
              message2 = 'text dropped';
            });
            print(s.substring(0, min(s.length, 20)));
          },
          onDropInvalid: (mime) => print('Zone 2 invalid MIME: $mime'),
          onDropFiles: (files) => print('Zone 2 drop multiple: $files'),
          onDropStrings: (strings) => print('Zone 2 drop multiple: $strings'),
        ),
  );

  Future<Uint8List> collectBytes(Stream<List<int>> source) {
    var bytes = BytesBuilder(copy: false);
    var completer = Completer<Uint8List>.sync();
    source.listen(
      bytes.add,
      onError: completer.completeError,
      onDone: () => completer.complete(bytes.takeBytes()),
      cancelOnError: true,
    );
    return completer.future;
  }
}