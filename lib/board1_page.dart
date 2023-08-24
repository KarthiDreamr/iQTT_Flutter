import 'package:flutter/material.dart';
import 'global_variable.dart';

class Board1Page extends StatelessWidget {
  const Board1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board 1'),
      ),
      body: Center(
        child: Text(mqttStatus[1]),
      ),
    );
  }
}
