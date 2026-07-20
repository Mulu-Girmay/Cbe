// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cbe_mobile_app/services/storage_service.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';

  // Get headers with token
  Future<Map<String, String>> getHeaders() async {
    final token = await StorageService.getSecure('firebase_token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // Handle API errors
  dynamic handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ??
          'Request failed with status: ${response.statusCode}');
    }
  }

  // GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: await getHeaders(),
      );
      return handleResponse(response);
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // POST request
  Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: await getHeaders(),
        body: jsonEncode(data),
      );
      return handleResponse(response);
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, dynamic data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: await getHeaders(),
        body: jsonEncode(data),
      );
      return handleResponse(response);
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: await getHeaders(),
      );
      return handleResponse(response);
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
