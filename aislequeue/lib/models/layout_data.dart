import 'placed_tile_data.dart';

class LayoutData {
  List<PlacedTileData> placedTiles;

  LayoutData({required this.placedTiles});

  Map<String, dynamic> toJson() {
    return {
      'placedTiles': placedTiles.map((tile) => {
        'gridX': tile.gridX,
        'gridY': tile.gridY,
        'width': tile.width,
        'height': tile.height,
        'category': tile.category,
      }).toList(),
    };
  }

  factory LayoutData.fromJson(Map<String, dynamic> json) {
    return LayoutData(
      placedTiles: (json['placedTiles'] as List)
          .map((tile) => PlacedTileData(
                gridX: tile['gridX'],
                gridY: tile['gridY'],
                width: tile['width'],
                height: tile['height'],
                category: tile['category'],
              ))
          .toList(),
    );
  }
}
