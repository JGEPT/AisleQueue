class PlacedTileData {
  int gridX;
  int gridY;
  int width;
  int height;
  String category;
  String type; // New property to define the type of tile

  PlacedTileData({
    required this.gridX,
    required this.gridY,
    required this.width,
    required this.height,
    required this.category,
    required this.type, // Include type in the constructor
  });
}
