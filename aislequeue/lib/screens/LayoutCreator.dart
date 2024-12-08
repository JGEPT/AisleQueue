import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/grid_view_widget.dart';
import '../widgets/search_bar_widget.dart' as custom_widgets;
import '../models/placed_tile_data.dart';
import '../utils/device_type.dart';

class LayoutCreator extends StatefulWidget {
  const LayoutCreator({super.key, required this.title});
  final String title;

  @override
  State<LayoutCreator> createState() => _LayoutCreatorState();
}

class _LayoutCreatorState extends State<LayoutCreator> {
  late String deviceType;
  static const int gridColumns = 32;
  static const int gridRows = 32;
  static const double gridCellSize = 40;

  final List<PlacedTileData> _placedTiles = [];
  bool _isPlacementMode = false;
  bool _isSelectingFirstPoint = false;
  bool _isSelectingSecondPoint = false;
  bool _isRemoveMode = false;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    deviceType = getDeviceType(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    super.dispose();
  }

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

  void _filterTiles(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
  }

  void _togglePlacementMode() {
    setState(() {
      _isPlacementMode = !_isPlacementMode;
      _isRemoveMode = false;
      _resetSelection();
    });
  }

  void _toggleRemoveMode() {
    setState(() {
      _isRemoveMode = !_isRemoveMode;
      _isPlacementMode = false;
      _resetSelection();
    });
  }

  void _updateGridPosition(Offset position) {
    if (_isPlacementMode || _isRemoveMode) {
      final Offset localPosition = _transformationController.toScene(position);
      setState(() {
        _currentGridX = (localPosition.dx / gridCellSize).floor();
        if (deviceType == 'Phone') {
          _currentGridY =
              ((localPosition.dy - ((gridCellSize / _currentScale) * 3.50)) /
                      gridCellSize)
                  .floor();
        } else {
          _currentGridY =
              ((localPosition.dy - ((gridCellSize / _currentScale) * 3.00)) /
                      gridCellSize)
                  .floor();
        }
        _currentGridX = _currentGridX.clamp(0, gridColumns - 1);
        _currentGridY = _currentGridY.clamp(0, gridRows - 1);
      });
    }
  }

  void _handleGridTap() {
    if (_isPlacementMode) {
      if (_isSelectingFirstPoint) {
        setState(() {
          _firstGridX = _currentGridX;
          _firstGridY = _currentGridY;
          _isSelectingFirstPoint = false;
          _isSelectingSecondPoint = true;
        });
      } else if (_isSelectingSecondPoint) {
        _placeRectangleTiles();
      }
    } else if (_isRemoveMode) {
      _removeOrEditTile();
    }
  }

  void _removeOrEditTile() {
    PlacedTileData? tileToModify = _findTileAtCurrentPosition();

    if (tileToModify != null) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Tile Options'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _removeTile(tileToModify);
                  },
                  child: const Text('Remove Tile'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showEditCategoryDialog(tileToModify);
                  },
                  child: const Text('Edit Category'),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  PlacedTileData? _findTileAtCurrentPosition() {
    try {
      return _placedTiles.firstWhere(
        (tile) =>
            _currentGridX >= tile.gridX &&
            _currentGridX < tile.gridX + tile.width &&
            _currentGridY >= tile.gridY &&
            _currentGridY < tile.gridY + tile.height,
      );
    } catch (e) {
      return null;
    }
  }

  void _removeTile(PlacedTileData tile) {
    setState(() {
      _placedTiles.remove(tile);
    });
  }

  void _showEditCategoryDialog(PlacedTileData tile) {
    final TextEditingController categoryController =
        TextEditingController(text: tile.category);

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: TextField(
            controller: categoryController,
            decoration:
                const InputDecoration(hintText: 'Enter new category name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  setState(() {
                    tile.category = categoryController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _placeRectangleTiles() {
    if (_firstGridX == null || _firstGridY == null) return;

    int startX = _firstGridX!;
    int startY = _firstGridY!;
    int endX = _currentGridX;
    int endY = _currentGridY;

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

    if (_checkTileOverlap(startX, startY, endX, endY)) {
      _showPlacementErrorDialog();
      return;
    }

    _showRectangleCategoryDialog(startX, startY, endX, endY);
  }

  bool _checkTileOverlap(int startX, int startY, int endX, int endY) {
    return _placedTiles.any((tile) {
      bool xOverlap =
          !(endX < tile.gridX || startX > (tile.gridX + tile.width - 1));
      bool yOverlap =
          !(endY < tile.gridY || startY > (tile.gridY + tile.height - 1));
      return xOverlap && yOverlap;
    });
  }

  void _showPlacementErrorDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Placement Error'),
          content: const Text(
              'The selected area overlaps with existing tiles. Please choose a different area.'),
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
  }

  Future<void> _showRectangleCategoryDialog(
      int startX, int startY, int endX, int endY) async {
    final TextEditingController categoryController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Category Name for Rectangle'),
          content: TextField(
            controller: categoryController,
            decoration:
                const InputDecoration(hintText: 'Enter a category name'),
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
                  _placedTiles.removeWhere((tile) =>
                      tile.gridX >= startX &&
                      tile.gridX <= endX &&
                      tile.gridY >= startY &&
                      tile.gridY <= endY);

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
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Column(
        children: [
          custom_widgets.SearchBar(
            controller: _searchController,
            onChanged: _filterTiles,
          ),
          Expanded(
            child: GridViewWidget(
              placedTiles: _placedTiles,
              isSearching: _isSearching,
              searchQuery: _searchController.text,
              onGridTap: _handleGridTap,
              onHover: _updateGridPosition,
              transformationController: _transformationController,
              isPlacementMode: _isPlacementMode,
              isRemoveMode: _isRemoveMode,
              currentGridX: _currentGridX,
              currentGridY: _currentGridY,
              isSelectingFirstPoint: _isSelectingFirstPoint,
              isSelectingSecondPoint: _isSelectingSecondPoint,
              firstGridX: _firstGridX,
              firstGridY: _firstGridY,
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FloatingActionButton(
              onPressed: _toggleRemoveMode,
              tooltip: 'Edit/Remove Tiles',
              backgroundColor:
                  _isRemoveMode ? Colors.red[700] : Colors.amber[800],
              heroTag: 'editRemoveButton',
              child: Icon(
                _isRemoveMode ? Icons.close : Icons.edit,
                color: Colors.white,
                size: 24,
              ),
              elevation: _isRemoveMode ? 8 : 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: _isRemoveMode
                    ? BorderSide(color: Colors.red[900]!, width: 2)
                    : BorderSide.none,
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: _togglePlacementMode,
            tooltip: 'Add Tiles',
            backgroundColor:
                _isPlacementMode ? Colors.red[700] : Colors.green[700],
            heroTag: 'placementButton',
            child: Icon(
              _isPlacementMode ? Icons.close : Icons.add,
              color: Colors.white,
              size: 28,
            ),
            elevation: _isPlacementMode ? 8 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: _isPlacementMode
                  ? BorderSide(color: Colors.green[900]!, width: 2)
                  : BorderSide.none,
            ),
          ),
        ],
      ),
    );
  }
}
