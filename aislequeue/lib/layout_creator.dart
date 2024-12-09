import 'package:flutter/material.dart';
import 'screens/LayoutCreator.dart';

class LayoutCreatorApp extends StatelessWidget {
  const LayoutCreatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AisleQueue',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LayoutCreator(title: "AisleQueue"),
    );
  }
}

