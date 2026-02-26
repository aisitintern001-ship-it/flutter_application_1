import 'package:flutter_application_1/models/person.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class ApiService {
    // Add a new employee
  static const String baseUrl = 'http://10.0.0.155:8000/api';

    static Future<bool> addEmployee(Person person) async {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/employees'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(person.toJson()),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          return true;
        } else {
          throw Exception('Failed to add employee: \\${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Error: $e');
      }
    }

  // Get all employees
  static Future<List<dynamic>> getAllEmployees() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/employees'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update an employee
  static Future<bool> updateEmployee(String id, Person person) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/employees/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update employee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete an employee
  static Future<bool> deleteEmployee(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/employees/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      // Treat common success codes as success (200 OK, 202 Accepted, 204 No Content)
      if (response.statusCode == 200 ||
          response.statusCode == 202 ||
          response.statusCode == 204) {
        return true;
      }

      // Log details to help debug issues like 404s from the backend
      print(
          'Delete failed. Status: ${response.statusCode}, body: ${response.body}');
      throw Exception('Failed to delete employee: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

}