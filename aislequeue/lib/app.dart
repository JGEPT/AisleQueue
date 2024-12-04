import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class AisleQueueApp extends StatelessWidget {
  const AisleQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AisleQueue',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(title: "AisleQueue"),
    );
  }
}
