import 'placed_tile_data.dart';

class LayoutData {
  String name; // New field for layout name
  List<PlacedTileData> placedTiles;

  LayoutData({required this.name, required this.placedTiles});

  Map<String, dynamic> toJson() {
    return {
      'name': name, // Include the name in the JSON
      'placedTiles': placedTiles.map((tile) => {
        'gridX': tile.gridX,
        'gridY': tile.gridY,
        'width': tile.width,
        'height': tile.height,
        'category': tile.category,
        'type': tile.type,
      }).toList(),
    };
  }

  factory LayoutData.fromJson(Map<String, dynamic> json) {
    return LayoutData(
      name: json['name'], // Deserialize the name from JSON
      placedTiles: (json['placedTiles'] as List)
          .map((tile) => PlacedTileData(
                gridX: tile['gridX'],
                gridY: tile['gridY'],
                width: tile['width'],
                height: tile['height'],
                category: tile['category'],
                type: tile['type'],
              ))
          .toList(),
    );
  }
}
