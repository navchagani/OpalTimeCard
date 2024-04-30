import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:opaltimecard/User/Modal/usermodal.dart';

class UserService {
  Future<Map<String, dynamic>> userAttendance(String pin) async {
    final body = {'pin': pin};

    try {
      final response = await http.post(
        Uri.parse(
            'https://monstersmokeoutlet.com/public/timestation/public/api/markattandence'),
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['success'] == true) {
          EmployeeModel employeeModel =
              EmployeeModel.fromJson(responseBody['data']);

          Map<String, dynamic> map = employeeModel.toJson();
          log("${employeeModel.toJson()}");

          return {'success': true, 'data': map};
        } else {
          // Better error handling when the operation was not successful
          final error = responseBody['error'] ??
              responseBody['data']['error'] ??
              'Unknown error';
          return {'success': false, 'error': error};
        }
      } else {
        log('Wrong password or other HTTP error');
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final error = responseBody['error'] ??
            responseBody['data']['error'] ??
            'Network error';
        return {'success': false, 'error': error};
      }
    } catch (e) {
      log('Network error: $e');
      return {'success': false, 'error': 'Exception caught: $e'};
    }
  }
}
