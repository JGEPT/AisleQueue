import 'inventory_items.dart';

class PlacedTileData {
  int gridX;
  int gridY;
  int width;
  int height;
  String category;
  String type;
  List<InventoryItem> inventory; // New field

  PlacedTileData({
    required this.gridX,
    required this.gridY,
    required this.width,
    required this.height,
    required this.category,
    required this.type,
    List<InventoryItem>? inventory,
  }) : inventory = List<InventoryItem>.from(inventory ?? []);

  // Add toJson and fromJson methods to include inventory
  Map<String, dynamic> toJson() => {
    'gridX': gridX,
    'gridY': gridY,
    'width': width,
    'height': height,
    'category': category,
    'type': type,
    'inventory': inventory.map((item) => item.toJson()).toList(),
  };

  factory PlacedTileData.fromJson(Map<String, dynamic> json) => PlacedTileData(
    gridX: json['gridX'],
    gridY: json['gridY'],
    width: json['width'],
    height: json['height'],
    category: json['category'],
    type: json['type'],
    inventory: (json['inventory'] as List?)
        ?.map((item) => InventoryItem.fromJson(item))
        .toList() ?? [],
  );
}
