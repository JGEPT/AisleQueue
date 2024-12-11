import 'package:flutter/material.dart';
import '../services/layout_file_handler.dart';
import '../models/layout_data.dart';
import 'LayoutCreator.dart';

class LayoutsScreen extends StatefulWidget {
  const LayoutsScreen({Key? key}) : super(key: key);

  @override
  State<LayoutsScreen> createState() => _LayoutsScreenState();
}

class _LayoutsScreenState extends State<LayoutsScreen> {
  List<String> _layouts = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isRemoveMode = false;

  @override
  void initState() {
    super.initState();
    _loadLayouts();
  }

  Future<void> _loadLayouts() async {
    try {
      _layouts = await LayoutFileHandler.listLayouts();
      setState(() {});
    } catch (e) {
      // Handle error
      print('Error loading layouts: $e');
    }
  }

  void _toggleRemoveMode() {
    setState(() {
      _isRemoveMode = !_isRemoveMode;
    });
  }

  void _createNewLayout() async {
    // Ensure remove mode is off when creating a new layout
    if (_isRemoveMode) {
      _toggleRemoveMode();
    }

    // Logic to create a new layout
    String? layoutName = await _showFileNameDialog('Create New Layout');
    if (layoutName != null && layoutName.isNotEmpty) {
      // Create a new layout with an empty list of placed tiles
      LayoutData newLayout = LayoutData(name: layoutName, placedTiles: []);
      try {
        await LayoutFileHandler.saveLayout(newLayout);
        _showSuccessDialog('Layout created successfully: $layoutName');
        _loadLayouts(); // Refresh the layout list
      } catch (e) {
        _showErrorDialog('Failed to create layout: $e');
      }
    }
  }

  void _loadLayout(String layoutName) async {
    // If in remove mode, delete the layout instead of loading
    if (_isRemoveMode) {
      _deleteLayout(layoutName);
      return;
    }

    try {
      LayoutData? layout = await LayoutFileHandler.loadLayout(layoutName);
      if (layout != null) {
        // Navigate to the LayoutCreator screen with the loaded layout
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LayoutCreator(
                title: layout.name,
                layout: layout), // Pass the layout to LayoutCreator
          ),
        );
      } else {
        _showErrorDialog('Layout not found: $layoutName');
      }
    } catch (e) {
      _showErrorDialog('Failed to load layout: $e');
    }
  }

  void _deleteLayout(String layoutName) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this layout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm) {
      try {
        await LayoutFileHandler.deleteLayout(layoutName);
        _showSuccessDialog('Layout deleted successfully: $layoutName');
        _loadLayouts(); // Refresh the layout list
      } catch (e) {
        _showErrorDialog('Failed to delete layout: $e');
      }
    }

    // Turn off remove mode after deletion
    if (_isRemoveMode) {
      _toggleRemoveMode();
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(right: 48.0), // Adjust the offset as needed
              child: Container(
                width: 250,
                height: 25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/BannerLogo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search stores',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _layouts.length,
                itemBuilder: (context, index) {
                  if (_layouts[index].toLowerCase().contains(_searchQuery)) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: _isRemoveMode ? 8 : 4,
                      color: _isRemoveMode ? Colors.red[100] : null,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () => _loadLayout(_layouts[index]),
                            child: Center(
                              child: Text(
                                _layouts[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isRemoveMode ? Colors.red[900] : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(); // Return an empty container if it doesn't match the search
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FloatingActionButton(
              onPressed: _createNewLayout,
              tooltip: 'Create New Layout',
              child: const Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FloatingActionButton(
              onPressed: _toggleRemoveMode,
              tooltip: _isRemoveMode ? 'Cancel Delete Mode' : 'Delete a layout',
              backgroundColor: Colors.red[700],
              child: Icon(
                _isRemoveMode ? Icons.close : Icons.delete,
                color: Colors.white,
                size: 28,
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
        ],
      ),
    );
  }
}
