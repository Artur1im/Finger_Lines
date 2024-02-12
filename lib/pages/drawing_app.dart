import 'package:flutter/material.dart';
import 'drawing_area.dart';

class DrawingApp extends StatelessWidget {
  const DrawingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing App'),
      ),
      body: const DrawingArea(),
    );
  }
}
