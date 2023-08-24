import 'package:flutter/material.dart';
import 'global_variable.dart';

class Board3Page extends StatelessWidget {
  const Board3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board 3'),
      ),
      body: Center(
        child: Text(mqttStatus[3]),
      ),
    );
  }
}
