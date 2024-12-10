import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inventory_items.dart';

class InventoryService {
  static const String baseUrl = 'http://172.27.16.1:3000';

  static Future<void> saveInventory({
    required String layoutName, 
    required String tileCategory, 
    required List<InventoryItem> inventoryItems,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/inventory/save'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'layout_name': layoutName,
          'tile_category': tileCategory,
          'inventory_items': inventoryItems.map((item) => item.toJson()).toList(),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save inventory: ${response.body}');
      }
    } catch (e) {
      print('Error saving inventory: $e');
      rethrow;
    }
  }

  static Future<List<InventoryItem>> loadInventory({
    required String layoutName, 
    required String tileCategory,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/inventory/${Uri.encodeComponent(layoutName)}/${Uri.encodeComponent(tileCategory)}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((item) => InventoryItem.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load inventory: ${response.body}');
      }
    } catch (e) {
      print('Error loading inventory: $e');
      rethrow;
    }
  }
}
