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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  final List<PlacedTileData> _placedTiles = [];
  bool _isPlacementMode = false;
  Offset _currentTilePosition = Offset.zero;

  void _togglePlacementMode() {
    setState(() {
      _isPlacementMode = !_isPlacementMode;
    });
  }

  Future<void> _showCategoryDialog(BuildContext context) async {
    final TextEditingController categoryController = TextEditingController();
    
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Category Name'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(
              hintText: 'Enter a category name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  _placeTile(categoryController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _placeTile(String category) {
    setState(() {
      final newTile = PlacedTileData(
        left: _currentTilePosition.dx - 50,
        top: _currentTilePosition.dy - 75,
        category: category,
      );
      _placedTiles.add(newTile);
    });
  }

  void _updateTilePosition(Offset position) {
    setState(() {
      _currentTilePosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: MouseRegion(
        onHover: (details) => _updateTilePosition(details.position),
        child: GestureDetector(
          onTap: _isPlacementMode 
            ? () => _showCategoryDialog(context)
            : null,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isPlacementMode 
                        ? 'Hover and tap to place a tile with a category' 
                        : 'Toggle placement mode to add tiles',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Render placed tiles
              ..._placedTiles.map((tileData) => Positioned(
                left: tileData.left,
                top: tileData.top,
                child: Container(
                  width: 100,
                  height: 50,
                  color: Colors.blue.shade300,
                  child: Center(
                    child: Text(
                      tileData.category,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )),
              
              // Preview tile in placement mode
              if (_isPlacementMode)
                Positioned(
                  left: _currentTilePosition.dx - 50,
                  top: _currentTilePosition.dy - 75,
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      width: 100,
                      height: 50,
                      color: Colors.blue.shade200,
                      child: const Center(
                        child: Text(
                          'New Tile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlacementMode,
        tooltip: 'Toggle Placement Mode',
        backgroundColor: _isPlacementMode ? Colors.red : Colors.green,
        child: Icon(_isPlacementMode ? Icons.close : Icons.add),
      ),
    );
  }
}

// A data class to store tile information
class PlacedTileData {
  final double left;
  final double top;
  final String category;

  PlacedTileData({
    required this.left,
    required this.top,
    required this.category,
  });
}
