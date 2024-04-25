import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:opaltimecard/User/Modal/usermodal.dart';

class UserService {
  Future<Map<String, dynamic>> UserAttendance(String pin) async {
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
          return {'success': true, 'data': map};
        } else {
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
