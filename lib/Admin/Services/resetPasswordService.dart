import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:opaltimecard/Utils/customDailoge.dart';

class ResetPasswordService {
  Future<Map<String, dynamic>> resetPassword(
    BuildContext context,
    String email,
  ) async {
    final body = {
      'email': email,
    };

    try {
      final response = await http.post(
        Uri.parse('https://opaltimecard.com/api/send-email-forgot-password'),
        body: body,
      );
      log("body:$body");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        // log("body:${response.body}");

        if (responseBody['success']) {
          log("model:${responseBody['data']}");
          return {
            'success': true,
          };
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
      log('loginerror:$e');

      return {'success': false, 'error': 'Network error: $e'};
    }
  }
}
