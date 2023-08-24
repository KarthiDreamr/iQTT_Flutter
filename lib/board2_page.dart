import 'package:flutter/material.dart';
import 'global_variable.dart';

class Board2Page extends StatelessWidget {
  const Board2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board 2'),
      ),
      body: Center(
        child: Text(mqttStatus[2]),
      ),
    );
  }
}
