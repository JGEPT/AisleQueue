import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
      home: const MyHomePage(title: "AisleQueue"),
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
  static const int gridColumns = 64;
  static const int gridRows = 64;
  static const double gridCellSize = 40;
  late String deviceType;

  final List<PlacedTileData> _placedTiles = [];
  bool _isPlacementMode = false;

  int _currentGridX = 0;
  int _currentGridY = 0;

  // New variable to track the current scale
  double _currentScale = 1.0;

  final TransformationController _transformationController =
      TransformationController();

  // Search-related variables
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    
    // Set up a listener for scale changes
    _transformationController.addListener(_onTransformationChanged);
  }

  @override
  void dispose() {
    // Dispose of search controller
    _searchController.dispose();

    // Remove the listener when the widget is disposed
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    super.dispose();
  }

  // Method to extract current scale
  void _onTransformationChanged() {
    // Extract the scale from the transformation matrix
    Matrix4 matrix = _transformationController.value;
    
    // Extract scale components
    double scaleX = matrix.getColumn(0).xyz.length;
    double scaleY = matrix.getColumn(1).xyz.length;
    
    // Calculate average scale
    double newScale = (scaleX + scaleY) / 2;
    
    // Update state only if the scale has changed significantly
    if ((newScale - _currentScale).abs() > 0.01) {
      setState(() {
        _currentScale = newScale;
      });
    }
  }

  // Modified method to filter tiles based on search query
  void _filterTiles(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
  }

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

  String _getDeviceType(BuildContext context) {
    // Improved device type detection
    if (kIsWeb) return 'Web';
    
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide < 600) return 'Phone';
    if (shortestSide < 1200) return 'Tablet';
    return 'Desktop';
  }

  void _placeTile(String category) {
    // Prevent placement if the current grid position is invalid or occupied
    bool isOccupied = _placedTiles.any((tile) =>
        tile.gridX == _currentGridX && tile.gridY == _currentGridY);

    if (_currentGridX >= 0 && _currentGridX < gridColumns && 
        _currentGridY >= 0 && _currentGridY < gridRows && 
        !isOccupied) {
      setState(() {
        final newTile = PlacedTileData(
          gridX: _currentGridX,
          gridY: _currentGridY,
          category: category,
        );
        _placedTiles.add(newTile);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot place tile here')),
      );
    }
  }

  void _updateGridPosition(Offset position, String deviceType) {
    if (_isPlacementMode) {
      // Transform the global cursor position to scene coordinates
      final Offset localPosition =
          _transformationController.toScene(position);
      
      setState(() {
        _currentGridX = (localPosition.dx / gridCellSize).floor();
        if(deviceType == 'Phone'){
          _currentGridY = ((localPosition.dy - ((gridCellSize/_currentScale)*3.50))/ gridCellSize).floor();
        }
        else{
          _currentGridY = ((localPosition.dy - ((gridCellSize/_currentScale)*3.00))/ gridCellSize).floor();
        }

        // Clamp the coordinates within the grid
        _currentGridX = _currentGridX.clamp(0, gridColumns - 1);
        _currentGridY = _currentGridY.clamp(0, gridRows - 1);

        // Check if the current grid cell is already occupied
        bool isOccupied = _placedTiles.any((tile) =>
          tile.gridX == _currentGridX && tile.gridY == _currentGridY);

        // If the cell is occupied, reset the grid coordinates to an invalid position
        if (isOccupied) {
          _currentGridX = -1;
          _currentGridY = -1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceType = _getDeviceType(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            const Icon(Icons.shopping_bag, color: Colors.black),
            const SizedBox(width: 8),
            Text(widget.title),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cart button pressed!')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: $value')),
              );
            },
            itemBuilder: (BuildContext context) {
              return {'Option 1', 'Option 2', 'Option 3'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search categories...',
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.green),
                          onPressed: () {
                            _searchController.clear();
                            _filterTiles('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, 
                    vertical: 12
                  ),
                ),
                onChanged: _filterTiles,
              ),
            ),
          ),
          
          // Existing grid view with search filtering
          Expanded(
            child: MouseRegion(
              onHover: (details) => _updateGridPosition(details.position, deviceType),
              child: InteractiveViewer(
                transformationController: _transformationController,
                boundaryMargin: const EdgeInsets.all(100),
                minScale: 0.5,
                maxScale: 2.0,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onTap: _isPlacementMode
                          ? () => _showCategoryDialog(context)
                          : null,
                      child: Stack(
                        children: [
                          ..._buildGridLines(constraints),
                          // Render all tiles with dynamic opacity
                          ..._placedTiles.map((tileData) => Positioned(
                                left: tileData.gridX * gridCellSize,
                                top: tileData.gridY * gridCellSize,
                                child: Opacity(
                                  opacity: _isSearching && 
                                           !tileData.category.toLowerCase().contains(_searchController.text.toLowerCase()) 
                                      ? 0.2  // Reduced opacity for non-matching tiles
                                      : 1.0, // Full opacity for matching or when not searching
                                  child: Container(
                                    width: gridCellSize,
                                    height: gridCellSize,
                                    color: Colors.green.shade500,
                                    child: Center(
                                      child: Text(
                                        tileData.category,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          if (_isPlacementMode && _currentGridX >= 0 && _currentGridY >= 0 &&
                              !_placedTiles.any((tile) => 
                                  tile.gridX == _currentGridX && tile.gridY == _currentGridY))
                            Positioned(
                              left: _currentGridX * gridCellSize,
                              top: _currentGridY * gridCellSize,
                              child: Opacity(
                                opacity: 0.5,
                                child: Container(
                                  width: gridCellSize,
                                  height: gridCellSize,
                                  color: Colors.green.shade200,
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
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlacementMode,
        tooltip: 'Toggle Placement Mode',
        backgroundColor: _isPlacementMode ? Colors.red : Colors.green,
        child: Icon(_isPlacementMode ? Icons.close : Icons.add),
      ),
    );
  }

  List<Widget> _buildGridLines(BoxConstraints constraints) {
    List<Widget> gridLines = [];

    for (int x = 0; x <= gridColumns; x++) {
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

    for (int y = 0; y <= gridRows; y++) {
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
