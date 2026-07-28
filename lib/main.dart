import 'package:flutter/material.dart';

void main() {
  runApp(const BassamApp());
}

class BassamApp extends StatelessWidget {
  const BassamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bassam AB',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bassam AB'),
      ),
      body: const Center(
        child: Text(
          'Hello Bassam!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
