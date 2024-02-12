import 'package:flutter/material.dart';
import 'package:todo_app/pages/drawing_area.dart';

class DrawingApp extends StatelessWidget {
  const DrawingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: DrawingArea()),
    );
  }
}
