import 'package:flutter/material.dart';

import '../models/placed_tile_data.dart';
import '../utils/constants.dart';
import '../utils/device_type_detector.dart';
import '../widgets/search_bar.dart';
import '../widgets/app_bar.dart';
import '../widgets/grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<PlacedTileData> _placedTiles = [];
  bool _isPlacementMode = false;
  bool _isSelectingFirstPoint = false;
  bool _isSelectingSecondPoint = false;
  int? _firstGridX;
  int? _firstGridY;
  int _currentGridX = 0;
  int _currentGridY = 0;
  double _currentScale = 1.0;
  late String deviceType;

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
    Matrix4 matrix = _transformationController.value;
    
    double scaleX = matrix.getColumn(0).xyz.length;
    double scaleY = matrix.getColumn(1).xyz.length;
    
    double newScale = (scaleX + scaleY) / 2;
    
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

  void _updateGridPosition(Offset position) {
    if (_isPlacementMode) {
      // Transform the global cursor position to scene coordinates
      final Offset localPosition = _transformationController.toScene(position);
      
      setState(() {
        _currentGridX = (localPosition.dx / AppConstants.gridCellSize).floor();
        if(deviceType == 'Phone'){
          _currentGridY = ((localPosition.dy - ((AppConstants.gridCellSize/_currentScale)*3.50))/ AppConstants.gridCellSize).floor();
        }
        else{
          _currentGridY = ((localPosition.dy - ((AppConstants.gridCellSize/_currentScale)*3.00))/ AppConstants.gridCellSize).floor();
        }

        // Clamp the coordinates within the grid
        _currentGridX = _currentGridX.clamp(0, AppConstants.gridColumns - 1);
        _currentGridY = _currentGridY.clamp(0, AppConstants.gridRows - 1);
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
    deviceType = DeviceTypeDetector.getDeviceType(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
      ),
      body: Column(
        children: [
          // Search Bar
          CategorySearchBar(
            searchController: _searchController,
            onFilterChanged: _filterTiles,
          ),
          
          // Grid View
          Expanded(
            child: MouseRegion(
              onHover: (details) => _updateGridPosition(details.position),
              child: InteractiveViewer(
                transformationController: _transformationController,
                boundaryMargin: const EdgeInsets.all(100),
                minScale: 0.5,
                maxScale: 2.0,
                child: InteractiveGridView(
                  transformationController: _transformationController,
                  placedTiles: _placedTiles,
                  isSearching: _isSearching,
                  searchQuery: _searchController.text,
                  isPlacementMode: _isPlacementMode,
                  isSelectingFirstPoint: _isSelectingFirstPoint,
                  isSelectingSecondPoint: _isSelectingSecondPoint,
                  firstGridX: _firstGridX,
                  firstGridY: _firstGridY,
                  currentGridX: _currentGridX,
                  currentGridY: _currentGridY,
                  onUpdateGridPosition: _updateGridPosition,
                  onGridTap: _handleGridTap,
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
}
