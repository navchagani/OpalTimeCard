// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:opaltimecard/User/Modal/usermodal.dart';
import 'package:opaltimecard/bloc/Blocs.dart';

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
        } else {
          String errorMessage =
              responseBody['error'] ?? 'An unknown error occurred';
          // _showerrorDailog(context, errorMessage);
        }
      } else {
        log('Wrong password or other HTTP error');
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final error = responseBody['error'] ??
            responseBody['data']['error'] ??
            'Network error';
        // _showerrorDailog(context, error);

        return {'success': false, 'error': error};
      }
    } catch (e) {
      log('Network error: $e');
      return {'success': false, 'error': 'Exception caught: $e'};
    }

    // Add a return statement here
    return {'success': false, 'error': 'Unknown error occurred'};
  }

  void _showEmployeeCardDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return employeeCard(context);
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  employeeCard(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    EmployeeBloc employeeBloc = BlocProvider.of<EmployeeBloc>(context);

    if (employeeBloc.state?.out == null) {
      return Dialog(
        child: SizedBox(
          width: width > 800 ? width * 0.3 : width * 0.5,
          child: Wrap(
            children: [
              Column(children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.green.shade800,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          employeeBloc.state?.employeename! ?? "",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 3,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.login_rounded,
                      color: Colors.green.shade800,
                      size: 50,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      employeeBloc.state!.In!,
                      style: TextStyle(
                          fontSize: width < 700 ? 20 : 25,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 30,
                ),
              ]),
            ],
          ),
        ),
      );
    } else {
      return Dialog(
        child: SizedBox(
          width: width > 800 ? width * 0.3 : width * 0.5,
          child: Wrap(
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              employeeBloc.state?.employeename! ?? "",
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 3,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Column(
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: Colors.red,
                                size: 50,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Out',
                                style: TextStyle(
                                    fontSize: width < 700 ? 20 : 25,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                employeeBloc.state?.out ?? '',
                                style: TextStyle(
                                    fontSize: width < 700 ? 15 : 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'In:',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                employeeBloc.state?.In! ?? '',
                                style: TextStyle(
                                    fontSize: width < 700 ? 15 : 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Out:',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                employeeBloc.state?.out! ?? '',
                                style: TextStyle(
                                    fontSize: width < 700 ? 15 : 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Hours:',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                employeeBloc.state?.difference ?? '',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(30, 60, 87, 1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ]),
            ],
          ),
        ),
      );
    }
  }
}
