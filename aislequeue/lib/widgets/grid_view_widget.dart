import 'package:flutter/material.dart';
import '../models/placed_tile_data.dart';

class GridViewWidget extends StatelessWidget {
  final List<PlacedTileData> placedTiles;
  final bool isSearching;
  final String searchQuery;
  final Function onGridTap;
  final Function onHover;
  final TransformationController transformationController;
  final bool isPlacementMode;
  final bool isRemoveMode;
  final int currentGridX;
  final int currentGridY;
  final bool isSelectingFirstPoint;
  final bool isSelectingSecondPoint;
  final int? firstGridX;
  final int? firstGridY;

  const GridViewWidget({
    Key? key,
    required this.placedTiles,
    required this.isSearching,
    required this.searchQuery,
    required this.onGridTap,
    required this.onHover,
    required this.transformationController,
    required this.isPlacementMode,
    required this.isRemoveMode,
    required this.currentGridX,
    required this.currentGridY,
    required this.isSelectingFirstPoint,
    required this.isSelectingSecondPoint,
    required this.firstGridX,
    required this.firstGridY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the total grid size
    const int gridWidth = 25; // 0-24 inclusive
    const int gridHeight = 25; // 0-24 inclusive
    const double cellSize = 40.0;

    return MouseRegion(
      onHover: (details) => onHover(details.position),
      child: InteractiveViewer(
        transformationController: transformationController,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.1, // Reduced to allow zooming out more
        maxScale: 2.0,
        constrained: false, // Allow unconstrained scaling
        child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () => onGridTap(),
            child: SizedBox(
              width: gridWidth * cellSize,
              height: gridHeight * cellSize,
              child: Stack(
                children: [
                  ..._buildGridLines(gridWidth, gridHeight, cellSize),
                  ...placedTiles.map((tileData) {
                    Color tileColor;
                    switch (tileData.type) {
                      case 'Cashier':
                        tileColor = Colors.blue; // Color for Cashier
                        break;
                      case 'Price Checker':
                        tileColor = Colors.orange; // Color for Price Checker
                        break;
                      default:
                        tileColor = Colors.green.shade500; // Default for Aisle
                    }
                    return Positioned(
                      left: tileData.gridX * cellSize,
                      top: tileData.gridY * cellSize,
                      child: Opacity(
                        opacity: isSearching && !tileData .category.toLowerCase().contains(searchQuery.toLowerCase()) 
                            ? 0.2 
                            : 1.0,
                        child: Container(
                          width: tileData.width * cellSize,
                          height: tileData.height * cellSize,
                          color: tileColor, // Use the determined color
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
                    );
                  }).toList(),                    if (isSelectingFirstPoint && isPlacementMode)
                      Positioned(
                        left: currentGridX * cellSize,
                        top: currentGridY * cellSize,
                        child: Opacity(
                          opacity: 0.5,
                          child: Container(
                            width: cellSize,
                            height: cellSize,
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
                    if (isSelectingSecondPoint && firstGridX != null && firstGridY != null)
                      Positioned(
                        left: (firstGridX! < currentGridX ? firstGridX! : currentGridX) * cellSize,
                        top: (firstGridY! < currentGridY ? firstGridY! : currentGridY) * cellSize,
                        child: Opacity(
                          opacity: 0.3,
                          child: Container(
                            width: (((firstGridX! - currentGridX).abs() + 1) * cellSize),
                            height: (((firstGridY! - currentGridY).abs() + 1) * cellSize),
                            color: Colors.green.shade200,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildGridLines(int gridWidth, int gridHeight, double cellSize) {
    List<Widget> gridLines = [];

    // Vertical lines
    for (int x = 0; x < gridWidth; x++) {
      gridLines.add(
        Positioned(
          left: x * cellSize,
          top: 0,
          child: Container(
            width: 1,
            height: gridHeight * cellSize,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      );
    }

    // Horizontal lines
    for (int y = 0; y < gridHeight; y++) {
      gridLines.add(
        Positioned(
          left: 0,
          top: y * cellSize,
          child: Container(
            width: gridWidth * cellSize,
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      );
    }

    return gridLines;
  }
}
