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
}