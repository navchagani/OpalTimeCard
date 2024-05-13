// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<Map<String, dynamic>> userAttendance(
    BuildContext context,
  ) async {
    final body = {
      'pin': 2222,
      'empid': '115',
      'date': '2024-05-04',
      'time': '03:50:02',
      'status': 'out',
      'uid': '1'
    };

    try {
      final response = await http.post(
        Uri.parse('https://opaltimecard.com/api/markattandence'),
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['success'] == true) {
          return {'success': true};
        } else {}
      } else {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final error = responseBody['error'] ??
            responseBody['data']['error'] ??
            'Network error';

        return {'success': false, 'error': error};
      }
    } catch (e) {
      return {'success': false, 'error': 'Exception caught: $e'};
    }

    return {'success': false, 'error': 'Unknown error occurred'};
  }
}
