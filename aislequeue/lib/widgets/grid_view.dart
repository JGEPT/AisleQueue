import 'package:flutter/material.dart';
import '../models/placed_tile_data.dart';
import '../utils/constants.dart';

class InteractiveGridView extends StatefulWidget {
  final TransformationController transformationController;
  final List<PlacedTileData> placedTiles;
  final bool isPlacementMode;
  final bool isSearching;
  final String searchQuery;
  final int currentGridX;
  final int currentGridY;
  final int? firstGridX;
  final int? firstGridY;
  final bool isSelectingFirstPoint;
  final bool isSelectingSecondPoint;
  final void Function(Offset position) onUpdateGridPosition;
  final VoidCallback onGridTap;

  const InteractiveGridView({
    super.key,
    required this.transformationController,
    required this.placedTiles,
    required this.isPlacementMode,
    required this.isSearching,
    required this.searchQuery,
    required this.currentGridX,
    required this.currentGridY,
    this.firstGridX,
    this.firstGridY,
    required this.isSelectingFirstPoint,
    required this.isSelectingSecondPoint,
    required this.onUpdateGridPosition,
    required this.onGridTap,
  });

  @override
  State<InteractiveGridView> createState() => _InteractiveGridViewState();
}

class _InteractiveGridViewState extends State<InteractiveGridView> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (details) => widget.onUpdateGridPosition(details.position),
      child: InteractiveViewer(
        transformationController: widget.transformationController,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 2.0,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTap: widget.onGridTap,
              child: Stack(
                children: [
                  ..._buildGridLines(constraints),
                  // Render all tiles with dynamic opacity
                  ...widget.placedTiles.map((tileData) => Positioned(
                        left: tileData.gridX * AppConstants.gridCellSize,
                        top: tileData.gridY * AppConstants.gridCellSize,
                        child: Opacity(
                          opacity: widget.isSearching && 
                                   !tileData.category.toLowerCase().contains(widget.searchQuery.toLowerCase()) 
                              ? 0.2  // Reduced opacity for non-matching tiles
                              : 1.0, // Full opacity for matching or when not searching
                          child: Container(
                            width: tileData.width * AppConstants.gridCellSize,
                            height: tileData.height * AppConstants.gridCellSize,
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
                  if (widget.isSelectingFirstPoint && widget.isPlacementMode)
                    Positioned(
                      left: widget.currentGridX * AppConstants.gridCellSize,
                      top: widget.currentGridY * AppConstants.gridCellSize,
                      child: Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: AppConstants.gridCellSize,
                          height: AppConstants.gridCellSize,
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
                  if (widget.isSelectingSecondPoint && widget.firstGridX != null && widget.firstGridY != null)
                    Positioned(
                      left: (widget.firstGridX! < widget.currentGridX ? widget.firstGridX! : widget.currentGridX) * AppConstants.gridCellSize,
                      top: (widget.firstGridY! < widget.currentGridY ? widget.firstGridY! : widget.currentGridY) * AppConstants.gridCellSize,
                      child: Opacity(
                        opacity: 0.3,
                        child: Container(
                          width: ((widget.firstGridX! - widget.currentGridX).abs() + 1) * AppConstants.gridCellSize,
                          height: ((widget.firstGridY! - widget.currentGridY).abs() + 1) * AppConstants.gridCellSize,
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
    );
  }

  List<Widget> _buildGridLines(BoxConstraints constraints) {
    List<Widget> gridLines = [];

    for (int x = 0; x <= AppConstants.gridColumns; x++) {
      gridLines.add(
        Positioned(
          left: x * AppConstants.gridCellSize,
          top: 0,
          child: Container(
            width: 1,
            height: constraints.maxHeight,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      );
    }

    for (int y = 0; y <= AppConstants.gridRows; y++) {
      gridLines.add(
        Positioned(
          left: 0,
          top: y * AppConstants.gridCellSize,
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
