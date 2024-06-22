import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';
import 'package:opaltimecard/Utils/customDailoge.dart';

class AuthService {
  Future<Map<String, dynamic>> loginUser(BuildContext context, String email,
      String password, String modelName, String macAddress) async {
    final body = {
      'email': email,
      'password': password,
      'model_name': modelName,
      'mac_address': macAddress
    };

    try {
      final response = await http.post(
        Uri.parse('https://opaltimecard.com/api/login'),
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['success']) {
          LoggedInUser loggedInUser =
              LoggedInUser.fromJson(responseBody['data']);
          log("model:${responseBody['data']}");
          return {'success': true, 'data': loggedInUser.toJson()};
        } else {
          // Adjusted to handle error info in the `data` key
          var errorMessage = responseBody['data'] != null
              ? responseBody['data']['info']
              : 'Unknown error';
          ConstDialog(context).showErrorDialog(error: errorMessage);
          return {'success': false, 'error': errorMessage};
        }
      } else {
        final responseBody = json.decode(response.body)
            as Map<String, dynamic>?; // Cast as a Map if not null
        var errorMessage = 'Network error';
        if (responseBody != null && responseBody['data'] != null) {
          errorMessage = responseBody['data']['info'] ?? errorMessage;
        }
        return {'success': false, 'error': errorMessage};
      }
    } catch (e) {
      // ConstDialog(context).showErrorDialog(error: 'Network error: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }
}
