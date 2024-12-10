import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/layout_data.dart';

class LayoutFileHandler {
  static const String baseUrl = 'http://172.27.16.1:3000';

  // Save a new layout
  static Future<String> saveLayout(LayoutData layout) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save-layout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(layout.toJson()),
    );

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      return responseBody['id']
          .toString(); // Return the generated layout ID as a string
    } else {
      throw Exception('Failed to save layout: ${response.body}');
    }
  }

  // Load a layout by name
  static Future<LayoutData?> loadLayout(String name) async {
    final response = await http.get(
      Uri.parse('$baseUrl/layouts/$name'), // Adjust path to match Go backend
    );

    if (response.statusCode == 200) {
      return LayoutData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load layout: ${response.body}');
    }
  }

  // Update an existing layout
  static Future<void> updateLayout(String name, LayoutData layout) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update-layout/$name'), // Adjust path to include name
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(layout.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update layout: ${response.body}');
    }
  }

  // Delete a layout by name
  static Future<void> deleteLayout(String name) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete-layout/$name'), // Adjust to query parameter
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete layout: ${response.body}');
    }
  }

  // List all layouts
  static Future<List<String>> listLayouts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/layouts'), // Endpoint to list all layouts
    );

    if (response.statusCode == 200) {
      final List<dynamic> layoutsJson = jsonDecode(response.body);
      return layoutsJson
          .map((layout) => layout['name'] as String)
          .toList(); // Extract names
    } else {
      throw Exception('Failed to retrieve layouts: ${response.body}');
    }
  }
}
