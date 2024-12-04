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
  static const int gridColumns = 128;
  static const int gridRows = 128;
  static const double gridCellSize = 40;
  late String deviceType;

  final List<PlacedTileData> _placedTiles = [];
  bool _isPlacementMode = false;

  // New variables for rectangular selection
  bool _isSelectingFirstPoint = false;
  bool _isSelectingSecondPoint = false;
  int? _firstGridX;
  int? _firstGridY;
  int _currentGridX = 0;
  int _currentGridY = 0;

  double _currentScale = 1.0;

  final TransformationController _transformationController =
      TransformationController();

  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformationChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
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
      
      // Reset selection state when toggling placement mode
      _isSelectingFirstPoint = _isPlacementMode;
      _isSelectingSecondPoint = false;
      _firstGridX = null;
      _firstGridY = null;
    });
  }

  String _getDeviceType(BuildContext context) {
    // Improved device type detection
    if (kIsWeb) return 'Web';
    
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide < 600) return 'Phone';
    if (shortestSide < 1200) return 'Tablet';
    return 'Desktop';
  }

  void _updateGridPosition(Offset position, String deviceType) {
    if (_isPlacementMode) {
      // Transform the global cursor position to scene coordinates
      final Offset localPosition = _transformationController.toScene(position);
      
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
      });
    }
  }

  void _handleGridTap() {
    if (_isPlacementMode) {
      if (_isSelectingFirstPoint) {
        // First point selection
        setState(() {
          _firstGridX = _currentGridX;
          _firstGridY = _currentGridY;
          _isSelectingFirstPoint = false;
          _isSelectingSecondPoint = true;
        });
      } else if (_isSelectingSecondPoint) {
        // Second point selection and tile placement
        _placeRectangleTiles();
      }
    }
  }

  bool _checkTileOverlap(int startX, int startY, int endX, int endY) {
    // Check if the new tile intersects with any existing tiles
    return _placedTiles.any((tile) {
      // Check if the new tile overlaps with an existing tile
      bool xOverlap = !(endX < tile.gridX || startX > (tile.gridX + tile.width - 1));
      bool yOverlap = !(endY < tile.gridY || startY > (tile.gridY + tile.height - 1));
      return xOverlap && yOverlap;
    });
  }

  void _placeRectangleTiles() {
    if (_firstGridX == null || _firstGridY == null) return;

    // Determine the bounds of the rectangle
    int startX = _firstGridX!;
    int startY = _firstGridY!;
    int endX = _currentGridX;
    int endY = _currentGridY;

    // Ensure start is always less than end
    if (startX > endX) {
      int temp = startX;
      startX = endX;
      endX = temp;
    }

    if (startY > endY) {
      int temp = startY;
      startY = endY;
      endY = temp;
    }

    // Check for overlapping tiles before showing the dialog
    if (_checkTileOverlap(startX, startY, endX, endY)) {
      // Show an error dialog if tiles would overlap
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Placement Error'),
            content: const Text('The selected area overlaps with existing tiles. Please choose a different area.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetSelection();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Show category dialog to get category name
    _showRectangleCategoryDialog(startX, startY, endX, endY);
  }

  Future<void> _showRectangleCategoryDialog(int startX, int startY, int endX, int endY) async {
    final TextEditingController categoryController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Category Name for Rectangle'),
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
                _resetSelection();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  // Remove any existing tiles in the rectangle area
                  _placedTiles.removeWhere((tile) => 
                    tile.gridX >= startX && tile.gridX <= endX &&
                    tile.gridY >= startY && tile.gridY <= endY
                  );

                  // Place a single large tile
                  setState(() {
                    final newTile = PlacedTileData(
                      gridX: startX,
                      gridY: startY,
                      width: endX - startX + 1,
                      height: endY - startY + 1,
                      category: categoryController.text,
                    );
                    _placedTiles.add(newTile);
                  });

                  Navigator.of(context).pop();
                  _resetSelection();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _resetSelection() {
    setState(() {
      _isSelectingFirstPoint = _isPlacementMode;
      _isSelectingSecondPoint = false;
      _firstGridX = null;
      _firstGridY = null;
    });
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
                      onTap: _handleGridTap,
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
                                    width: tileData.width * gridCellSize,
                                    height: tileData.height * gridCellSize,
                                    color: Colors.green.shade500,
                                    child: Center(
                                      child: Text(
                                        tileData.category,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          // Highlight first selected point
                          if (_isSelectingFirstPoint && _isPlacementMode)
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
                                      'First Point',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          // Highlight rectangular selection area
                          if (_isSelectingSecondPoint && _firstGridX != null && _firstGridY != null)
                            Positioned(
                              left: (_firstGridX! < _currentGridX ? _firstGridX! : _currentGridX) * gridCellSize,
                              top: (_firstGridY! < _currentGridY ? _firstGridY! : _currentGridY) * gridCellSize,
                              child: Opacity(
                                opacity: 0.3,
                                child: Container(
                                  width: (((_firstGridX! - _currentGridX).abs() + 1) * gridCellSize),
                                  height: (((_firstGridY! - _currentGridY).abs() + 1) * gridCellSize),
                                  color: Colors.green.shade200,
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
  final int width;
  final int height;
  final String category;

  PlacedTileData({
    required this.gridX,
    required this.gridY,
    required this.width,
    required this.height,
    required this.category,
  });
}
