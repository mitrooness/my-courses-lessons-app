import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:preparia_ma/models/course_models.dart';
import 'models/customer.dart';
import 'models/category.dart'; // Assuming you place the category models in this file

class APIService {
  final String baseUrl = 'https://shopkech.com/preparia/wp-json/wp/v2';

  Future<bool> createCustomer(CustomerModel model) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': model.email,
        'email': model.email,
        'password': model.password,
        'first_name': model.firstName,
        'last_name': model.lastName,
      }),
    );

    return response.statusCode == 201;
  }

  Future<bool> loginCustomer(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://shopkech.com/preparia/wp-json/jwt-auth/v1/token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': email,
        'password': password,
      }),
    );

    print('Login Response: ${response.statusCode}');
    print('Login Response Body: ${response.body}');

    return response.statusCode == 200;
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Fetch Categories Response: ${response.statusCode}');
    print('Fetch Categories Response Body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Category> categories = body.map((dynamic item) => Category.fromJson(item)).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Course> courses = body.map((dynamic item) => Course.fromJson(item)).toList();
      return courses;
    } else {
      throw Exception('Failed to load courses');
    }
  }
}
