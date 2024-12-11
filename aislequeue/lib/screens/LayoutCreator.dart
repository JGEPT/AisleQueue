import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/grid_view_widget.dart';
import '../widgets/search_bar_widget.dart' as custom_widgets;
import '../models/placed_tile_data.dart';
import '../utils/device_type.dart';
import '../models/layout_data.dart';
import '../services/layout_file_handler.dart';
import '../models/inventory_items.dart';
import '../services/inventory_service.dart';

class LayoutCreator extends StatefulWidget {
  final String title;
  final LayoutData? layout; // Accept the layout data

  const LayoutCreator({Key? key, required this.title, this.layout})
      : super(key: key);

  @override
  State<LayoutCreator> createState() => _LayoutCreatorState();
}

class _LayoutCreatorState extends State<LayoutCreator> {
  late String deviceType;
  static const int gridColumns = 32;
  static const int gridRows = 32;
  static const double gridCellSize = 40;

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
  String? _currentLoadedLayoutName; // Track the currently loaded layout name
  late List<PlacedTileData> _placedTiles;

  @override
  void initState() {
    super.initState();
    _placedTiles = widget.layout?.placedTiles ??
        []; // Use the loaded layout or an empty list
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
              ((localPosition.dy - ((gridCellSize / _currentScale) * 4.25)) /
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
                    _showInventoryScreen(
                        tileToModify); // Open inventory management
                  },
                  child: const Text('Manage Inventory'),
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
    String selectedType = 'Aisle'; // Default type

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Category Name for Rectangle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration:
                    const InputDecoration(hintText: 'Enter a category name'),
              ),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter dropdownState) {
                  return DropdownButton<String>(
                    value: selectedType,
                    items: <String>['Aisle', 'Cashier', 'Price Checker']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      dropdownState(() {
                        selectedType = newValue!;
                      });
                    },
                  );
                },
              ),
            ],
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
                      type: selectedType, // Set the type of the tile
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

  void _showSuccessDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveLayout() async {
    if (_currentLoadedLayoutName != null) {
      // If we're editing an existing layout, offer to update it
      bool? confirmUpdate = await _showConfirmationDialog(
        'Update Existing Layout',
        'Do you want to update the existing layout with name: $_currentLoadedLayoutName?',
      );

      if (confirmUpdate == true) {
        await _updateExistingLayout();
        for (var tile in _placedTiles) {
          await InventoryService.saveInventory(
            layoutName: _currentLoadedLayoutName ?? 'default',
            tileCategory: tile.category,
            inventoryItems: tile.inventory,
          );
        }
        return;
      }
    }

    // If not updating an existing layout, proceed with saving as new
    String? layoutName = await _showFileNameDialog('Save Layout');
    if (layoutName != null && layoutName.isNotEmpty) {
      LayoutData layout =
          LayoutData(name: layoutName, placedTiles: _placedTiles);
      try {
        await LayoutFileHandler.saveLayout(layout);
        for (var tile in _placedTiles) {
          await InventoryService.saveInventory(
            layoutName: _currentLoadedLayoutName ?? 'default',
            tileCategory: tile.category,
            inventoryItems: tile.inventory,
          );
        }
        _showSuccessDialog('Layout saved with name: $layoutName');
        setState(() {
          _currentLoadedLayoutName = layoutName;
        });
      } catch (e) {
        _showErrorDialog('Failed to save layout: $e');
      }
    }
  }

  Future<void> _updateExistingLayout() async {
    if (_currentLoadedLayoutName == null) return;

    try {
      LayoutData layout = LayoutData(
          placedTiles: _placedTiles, name: _currentLoadedLayoutName!);
      await LayoutFileHandler.updateLayout(_currentLoadedLayoutName!, layout);
      _showSuccessDialog('Layout updated successfully.');
    } catch (e) {
      _showErrorDialog('Failed to update layout: $e');
    }
  }

  void _loadLayout() async {
    try {
      List<String> availableLayouts = await LayoutFileHandler.listLayouts();

      if (availableLayouts.isEmpty) {
        if (!mounted) return;
        _showErrorDialog('No layouts available.');
        return;
      }

      if (!mounted) return;
      String? selectedLayout = await showDialog<String>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Select Layout to Load'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableLayouts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(availableLayouts[index]),
                    onTap: () {
                      Navigator.of(dialogContext).pop(availableLayouts[index]);
                    },
                  );
                },
              ),
            ),
          );
        },
      );

      if (!mounted) return;

      if (selectedLayout != null && selectedLayout.isNotEmpty) {
        String encodedLayoutName = Uri.encodeComponent(selectedLayout);
        LayoutData? layout =
            await LayoutFileHandler.loadLayout(encodedLayoutName);
        if (!mounted) return;

        if (layout != null) {
          setState(() {
            _placedTiles.clear();
            _placedTiles.addAll(layout.placedTiles);
            _currentLoadedLayoutName = selectedLayout;
          });
          _showSuccessDialog('Layout loaded successfully.');
        } else {
          _showErrorDialog('Failed to load layout. Please try again.');
        }
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('Failed to retrieve layouts: $e');
    }
  }

  void _deleteLayout() async {
    try {
      List<String> availableLayouts = await LayoutFileHandler.listLayouts();

      if (availableLayouts.isEmpty) {
        if (!mounted) return;
        _showErrorDialog('No layouts available to delete.');
        return;
      }

      if (!mounted) return;
      String? selectedLayout = await showDialog<String>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Select Layout to Delete'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableLayouts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(availableLayouts[index]),
                    onTap: () {
                      Navigator.of(dialogContext).pop(availableLayouts[index]);
                    },
                  );
                },
              ),
            ),
          );
        },
      );

      if (!mounted) return;

      if (selectedLayout != null && selectedLayout.isNotEmpty) {
        // URL encode the selected layout name
        String encodedLayoutName = Uri.encodeComponent(selectedLayout);

        // Confirm deletion
        bool? confirmDelete = await _showConfirmationDialog(
          'Confirm Delete',
          'Are you sure you want to delete the layout with name: $selectedLayout?',
        );

        if (!mounted) return;

        if (confirmDelete == true) {
          await LayoutFileHandler.deleteLayout(
              encodedLayoutName); // Use the encoded name

          if (!mounted) return;

          // Clear current layout if the deleted layout was the loaded one
          if (selectedLayout == _currentLoadedLayoutName) {
            setState(() {
              _placedTiles.clear();
              _currentLoadedLayoutName = null;
            });
          }

          _showSuccessDialog('Layout deleted successfully.');
        }
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('Failed to retrieve or delete layout: $e');
    }
  }

  // New button for creating a new layout
  void _createNewLayout() {
    setState(() {
      _placedTiles.clear();
      _currentLoadedLayoutName = null; // Reset the current layout name
    });
    _showSuccessDialog('New layout created.');
  }

  Future<bool?> _showConfirmationDialog(String title, String content) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showFileNameDialog(String title) async {
    final TextEditingController controller = TextEditingController();
    String? fileName;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter file name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                fileName = controller.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return fileName;
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showInventoryScreen(PlacedTileData tile) async {
    try {
      // Try to load existing inventory from backend
      tile.inventory = await InventoryService.loadInventory(
        layoutName: _currentLoadedLayoutName ?? 'default',
        tileCategory: tile.category,
      );
    } catch (e) {
      // If loading fails, use existing or empty inventory
      tile.inventory = tile.inventory ?? [];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder: (_, controller) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '${tile.category} Inventory',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: tile.inventory.isEmpty
                        ? Center(child: Text('No items in inventory'))
                        : ListView.builder(
                            itemCount: tile.inventory.length,
                            itemBuilder: (context, index) {
                              final item = tile.inventory[index];
                              return ListTile(
                                title: Text(item.name),
                                subtitle: Text(
                                  'Quantity: ${item.quantity} | Price: \$${item.price.toStringAsFixed(2)}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _editInventoryItem(
                                        tile,
                                        item,
                                        () => setState(() {}),
                                      ),
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _removeInventoryItem(
                                        tile,
                                        item,
                                        () => setState(() {}),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () => _addInventoryItem(
                        tile,
                        () => setState(() {}),
                      ),
                      child: Text('Add New Item'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _addInventoryItem(PlacedTileData tile, VoidCallback updateState) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Inventory Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                // Ensure the list is growable
                if (tile.inventory is! List<InventoryItem>) {
                  tile.inventory = <InventoryItem>[];
                }

                final newItem = InventoryItem(
                  name: nameController.text,
                  quantity: int.tryParse(quantityController.text) ?? 0,
                  price: double.tryParse(priceController.text) ?? 0.0,
                );

                // Explicitly use .add()
                tile.inventory.add(newItem);

                updateState();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editInventoryItem(
      PlacedTileData tile, InventoryItem item, VoidCallback updateState) {
    final nameController = TextEditingController(text: item.name);
    final quantityController =
        TextEditingController(text: item.quantity.toString());
    final priceController = TextEditingController(text: item.price.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Inventory Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                item.name = nameController.text;
                item.quantity = int.tryParse(quantityController.text) ?? 0;
                item.price = double.tryParse(priceController.text) ?? 0.0;

                updateState();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _removeInventoryItem(
      PlacedTileData tile, InventoryItem item, VoidCallback updateState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to remove this item?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete'),
              onPressed: () {
                // Use .remove() explicitly
                tile.inventory.removeWhere((i) => i.id == item.id);

                updateState();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
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
          // Add Tiles Button
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FloatingActionButton(
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
          ),
          // Save Layout Button
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FloatingActionButton(
              onPressed: _saveLayout,
              tooltip: 'Save Layout',
              heroTag: 'saveButton',
              child: const Icon(Icons.save),
            ),
          ),
        ],
      ),
    );
  }
}
