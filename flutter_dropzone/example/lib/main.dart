import 'package:flutter/material.dart';
import 'package:flutter_dropzone/dropzone_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DropzoneViewController controller;
  String message = 'Drop something here';

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Dropzone example'),
          ),
          body: Stack(
            children: [
              buildZone(context),
              Center(child: Text(message)),
            ],
          ),
        ),
      );

  Widget buildZone(BuildContext context) => Builder(
        builder: (context) => DropzoneView(
          operation: DragOperation.copy,
          onCreated: (ctrl) => controller = ctrl,
          onLoaded: () => print('Zone loaded'),
          onError: (ev) => print('Error: $ev'),
          onDrop: (ev) {
            print('Drop: ${ev.name}');
            setState(() {
              message = '${ev.name} dropped';
            });
          },
        ),
      );
}
