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
  // Grid configuration
  static const int gridColumns = 10;
  static const int gridRows = 8;
  static const double gridCellSize = 60; // Size of each grid cell

  final List<PlacedTileData> _placedTiles = [];
  bool _isPlacementMode = false;
  
  // Grid-based positioning
  int _currentGridX = 0;
  int _currentGridY = 0;

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
    // Check if the current grid position is already occupied
    bool isOccupied = _placedTiles.any((tile) => 
      tile.gridX == _currentGridX && tile.gridY == _currentGridY);

    if (!isOccupied) {
      setState(() {
        final newTile = PlacedTileData(
          gridX: _currentGridX,
          gridY: _currentGridY,
          category: category,
        );
        _placedTiles.add(newTile);
      });
    } else {
      // Show a snackbar or dialog indicating the grid cell is occupied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This grid cell is already occupied')),
      );
    }
  }

  void _updateGridPosition(Offset position) {
    if (_isPlacementMode) {
      // Calculate grid coordinates based on tap/hover position
      setState(() {
        _currentGridX = (position.dx / gridCellSize).floor();
        _currentGridY = (position.dy / gridCellSize).floor();

        // Ensure coordinates are within grid bounds
        _currentGridX = _currentGridX.clamp(0, gridColumns - 1);
        _currentGridY = _currentGridY.clamp(0, gridRows - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return MouseRegion(
            onHover: (details) => _updateGridPosition(details.position),
            child: GestureDetector(
              onTap: _isPlacementMode 
                ? () => _showCategoryDialog(context)
                : null,
              child: Stack(
                children: [
                  // Grid visualization (optional, for debugging)
                  ..._buildGridLines(constraints),

                  // Instruction text
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
                    left: tileData.gridX * gridCellSize,
                    top: tileData.gridY * gridCellSize,
                    child: Container(
                      width: gridCellSize,
                      height: gridCellSize,
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
                      left: _currentGridX * gridCellSize,
                      top: _currentGridY * gridCellSize,
                      child: Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: gridCellSize,
                          height: gridCellSize,
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlacementMode,
        tooltip: 'Toggle Placement Mode',
        backgroundColor: _isPlacementMode ? Colors.red : Colors.green,
        child: Icon(_isPlacementMode ? Icons.close : Icons.add),
      ),
    );
  }

  // Helper method to draw grid lines (optional, for visualization)
  List<Widget> _buildGridLines(BoxConstraints constraints) {
    List<Widget> gridLines = [];

    // Vertical lines
    for (int x = 0; x < gridColumns; x++) {
      gridLines.add(
        Positioned(
          left: x * gridCellSize,
          top: 0,
          child: Container(
            width: 1,
            height: constraints.maxHeight,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      );
    }

    // Horizontal lines
    for (int y = 0; y < gridRows; y++) {
      gridLines.add(
        Positioned(
          left: 0,
          top: y * gridCellSize,
          child: Container(
            width: constraints.maxWidth,
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      );
    }

    return gridLines;
  }
}

// A data class to store tile information
class PlacedTileData {
  final int gridX;
  final int gridY;
  final String category;

  PlacedTileData({
    required this.gridX,
    required this.gridY,
    required this.category,
  });
}
