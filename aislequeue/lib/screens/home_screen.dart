import 'package:flutter/material.dart';
import '../models/placed_tile_data.dart';
import '../utils/device_type_detector.dart';
import '../utils/constants.dart';
import '../widgets/grid_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
  late String deviceType;

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

  void _updateGridPosition(Offset position) {
    if (_isPlacementMode) {
      // Transform the global cursor position to scene coordinates
      final Offset localPosition = _transformationController.toScene(position);
      
      setState(() {
        _currentGridX = (localPosition.dx / GridConstants.gridCellSize).floor();
        if(deviceType == 'Phone'){
          _currentGridY = ((localPosition.dy - ((GridConstants.gridCellSize/_currentScale)*3.50))/ GridConstants.gridCellSize).floor();
        }
        else{
          _currentGridY = ((localPosition.dy - ((GridConstants.gridCellSize/_currentScale)*3.00))/ GridConstants.gridCellSize).floor();
        }

        // Clamp the coordinates within the grid
        _currentGridX = _currentGridX.clamp(0, GridConstants.gridColumns - 1);
        _currentGridY = _currentGridY.clamp(0, GridConstants.gridRows - 1);
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
            title: const Text
