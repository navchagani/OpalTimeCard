// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';
import 'package:opaltimecard/Utils/customDailoge.dart';

class AuthService {
  Future<Map<String, dynamic>> loginUser(
      BuildContext context, String email, String password) async {
    final body = {
      'username': email,
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
          return map;
        } else {
          log('store url is correct but cant login');
          ConstDialog(context)
              .showErrorDialog(error: responseBody['error']['info']);
          return {
            'success': false,
            'error': responseBody['error'] ?? 'Unknown error'
          };
        }
      } else {
        log('wrong password');
        final Map<String, dynamic> responseBody = json.decode(response.body);
        ConstDialog(context)
            .showErrorDialog(error: responseBody['error']['info']);
        return {
          'success': false,
          'error': {'info': 'Network error'}
        };
      }
    } catch (e) {
      log('print Error');
      ConstDialog(context).showErrorDialog(error: 'Invalid Email & Password');
      return {
        'success': false,
        'error': {'info': 'Network error: $e'}
      };
    }
  }
}
