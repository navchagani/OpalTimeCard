import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';

class AuthService {
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final body = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(
            'https://monstersmokeoutlet.com/public/timestation/public/api/login'),
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['success'] == true) {
          LoggedInUser loggedInUser =
              LoggedInUser.fromJson(responseBody['data']);
          Map<String, dynamic> map = loggedInUser.toJson();
          log('store url success');
          return {'success': true, 'data': map};
        } else {
          log('store url is correct but cant login');
          return {
            'success': false,
            'error': responseBody['error'] ?? 'Unknown error'
          };
        }
      } else {
        log('wrong password');
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return {
          'success': false,
          'error': responseBody['error'] ?? 'Network error'
        };
      }
    } catch (e) {
      log('print Error');
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
}
