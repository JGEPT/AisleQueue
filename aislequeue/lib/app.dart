import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class LayoutCreator extends StatelessWidget {
  const LayoutCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AisleQueue',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "AisleQueue"),
    );
  }
}
