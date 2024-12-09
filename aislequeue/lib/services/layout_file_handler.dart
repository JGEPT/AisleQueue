import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/layout_data.dart';

class LayoutFileHandler {
  static const String baseUrl = 'http://localhost:3000';

  // Save a new layout
  static Future<String> saveLayout(LayoutData layout) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save-layout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(layout.toJson()),
    );
    
    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      return responseBody['id'].toString(); // Return the generated layout ID as a string
    } else {
      throw Exception('Failed to save layout: ${response.body}');
    }
  }

  // Load a layout by ID
  static Future<LayoutData?> loadLayout(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/layouts/$id'), // Adjust path to match Go backend
    );
    
    if (response.statusCode == 200) {
      return LayoutData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load layout: ${response.body}');
    }
  }

  // Update an existing layout
  static Future<void> updateLayout(String id, LayoutData layout) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update-layout/$id'), // Adjust path to include ID
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(layout.toJson()),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update layout: ${response.body}');
    }
  }

  // Delete a layout by ID
  static Future<void> deleteLayout(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete-layout?id=$id'), // Adjust to query parameter
    );
    
    if (response.statusCode != 204) {
      throw Exception('Failed to delete layout: ${response.body}');
    }
  }
}
