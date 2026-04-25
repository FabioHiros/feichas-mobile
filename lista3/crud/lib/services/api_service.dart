import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/grocery_item.dart';

// Change to 'http://10.0.2.2:8000' for Android emulator
// Change to your machine's LAN IP for physical devices
const String _baseUrl = 'http://localhost:8000';

class ApiService {
  static Future<List<GroceryItem>> fetchItems() async {
    final response = await http.get(Uri.parse('$_baseUrl/items'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load items: ${response.statusCode}');
    }
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((j) => GroceryItem.fromJson(j as Map<String, dynamic>)).toList();
  }

  static Future<GroceryItem> createItem(GroceryItem item) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/items'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create item: ${response.statusCode}');
    }
    return GroceryItem.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  static Future<GroceryItem> updateItem(GroceryItem item) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/items/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update item: ${response.statusCode}');
    }
    return GroceryItem.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  static Future<void> deleteItem(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/items/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete item: ${response.statusCode}');
    }
  }
}
