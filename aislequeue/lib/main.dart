import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AisleQueue',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'AisleQueue'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Positioned> _placedTiles = [];
  bool _isDraggingTile = false;
  Offset _currentTilePosition = Offset.zero;

  void _startPlacingTile(TapDownDetails details) {
    setState(() {
      _isDraggingTile = true;
      _currentTilePosition = details.globalPosition;
    });
  }

  void _updateTilePosition(DragUpdateDetails details) {
    if (_isDraggingTile) {
      setState(() {
        _currentTilePosition = details.globalPosition;
      });
    }
  }

  void _placeTile(TapUpDetails details) {
    if (_isDraggingTile) {
      setState(() {
        // Create a new positioned tile at the current position
        final newTile = Positioned(
          left: _currentTilePosition.dx - 25, // Adjust to center the tile
          top: _currentTilePosition.dy - 25,
          child: Container(
            width: 50,
            height: 50,
            color: Colors.blue.shade300,
            child: Center(
              child: Text('${_placedTiles.length + 1}'),
            ),
          ),
        );

        _placedTiles.add(newTile);
        _isDraggingTile = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _startPlacingTile,
      onPanUpdate: _updateTilePosition,
      onTapUp: _placeTile,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Tap and drag the + button to place a tile',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Add all the placed tiles
            ..._placedTiles,
            
            // Dragging tile
            if (_isDraggingTile)
              Positioned(
                left: _currentTilePosition.dx - 25,
                top: _currentTilePosition.dy - 25,
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.blue.shade300,
                    child: Center(
                      child: Text('${_placedTiles.length + 1}'),
                    ),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {}, // Disabled regular onPressed
          tooltip: 'Drag to place tile',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
