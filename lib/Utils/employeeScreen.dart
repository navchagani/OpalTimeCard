// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';
import 'package:opaltimecard/User/Modal/EmployeeData.dart';
import 'package:opaltimecard/User/Services/userService.dart';
import 'package:opaltimecard/localDatabase/DatabaseHelper.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  TextEditingController pinCode = TextEditingController();
  UserService userService = UserService();
  List<LoggedInUser>? currentUser;

  String text = '';
  FocusNode pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    pinFocusNode.addListener(() {
      if (!pinFocusNode.hasFocus) {
        pinCode.clear();
      }
    });
  }

  void calculation(btnText) {
    setState(() {
      if (btnText == 'C') {
        text = '';
      } else if (btnText == '<') {
        if (text.isNotEmpty) {
          text = text.substring(0, text.length - 1);
        }
      } else if (text.length < 4) {
        text += btnText;
      }
      setState(() {
        pinCode.text = text;
      });
    });
  }

  // void employeeAttendance({required BuildContext context}) async {
  //   await userService.userAttendance(context, pinCode.text);

  //   setState(() {
  //     pinCode.clear();
  //     text = '';
  //   });
  // }
//   extension IterableExtension<T> on Iterable<T> {
//   T? firstWhereOrNull(bool Function(T) test) {
//     for (final element in this) {
//       if (test(element)) {
//         return element;
//       }
//     }
//     return null;
//   }
// }

  void employeeAttendance({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('loggedInUser');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      LoggedInUser loggedInUser = LoggedInUser.fromJson(userMap);
      List<Employees>? employees = loggedInUser.employees;

      bool pinMatch =
          employees!.any((employee) => employee.pin == pinCode.text);

      if (pinMatch) {
        Employees? matchedEmployee = employees.firstWhere(
          (employee) => employee.pin == pinCode.text,
          orElse: () {
            log('Employee not found with pin ${pinCode.text}');
            return Employees(); // return a default employee object
          },
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            double width = MediaQuery.of(context).size.width;

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
                                ' ${matchedEmployee.name ?? "Unknown"}',
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
                            'Time: ${DateFormat('hh:mm a').format(DateTime.now())}',
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
          },
        ).whenComplete(() async {
          String currentTime = DateFormat('hh:mm a').format(DateTime.now());
          EmployeeAttendance attendanceRecord = EmployeeAttendance(
            employeename: matchedEmployee.name,
            pin: matchedEmployee.pin,
            checkIn: currentTime,
          );
          int id =
              await DatabaseHelper.instance.insertAttendance(attendanceRecord);
          log('Attendance record inserted with ID: $id');

          log('Attendance record with ID $id inserted successfully');
        });
      } else {
        log('PIN not found: ${pinCode.text}');
      }
    }

    setState(() {
      pinCode.clear();
      text = '';
    });
  }

  Widget calcButton(String btntxt, Color btncolor, Color txtcolor) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      child: ElevatedButton(
        onPressed: () async {
          calculation(btntxt);
          // final player = AudioPlayer();
          // await player.play(AssetSource('audios/touch.mp3'));
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: btncolor,
          padding: EdgeInsets.all(
            height < 700 ? height / 20 : height / 40,
          ),
        ),
        child: Text(
          btntxt,
          style: TextStyle(
            fontSize: width > 700 ? 30 : 20,
            color: txtcolor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height > 800 ? height / 1.85 : height / 1.55,
      width: width > 900 ? width / 3.85 : width / 1.5,
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(20.0),
        elevation: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        'Enter Your 4-digit Pin',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 37, 84, 124),
                          fontSize: width > 600 ? 25 : 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(pinFocusNode);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Pinput(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      controller: pinCode,
                      pinContentAlignment: Alignment.center,
                      focusNode: pinFocusNode,
                      defaultPinTheme: PinTheme(
                        width: width > 800 ? width / 23 : width / 9,
                        height: height > 800 ? height / 15 : height / 14,
                        textStyle: TextStyle(
                          fontSize: height > 850 ? 65 : 40,
                          color: const Color.fromRGBO(30, 60, 87, 1),
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 35, 36, 36)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      readOnly: true,
                      onCompleted: (value) {
                        employeeAttendance(context: context);
                      }),
                ),
              ),
              // const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton(
                      '7', const Color.fromRGBO(30, 60, 87, 1), Colors.white),
                  calcButton(
                      '8', const Color.fromRGBO(30, 60, 87, 1), Colors.white),
                  calcButton(
                      '9', const Color.fromRGBO(30, 60, 87, 1), Colors.white),
                ],
              ),
              // const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton(
                      '4', const Color.fromRGBO(30, 60, 87, 1), Colors.white),
                  calcButton(
                      '5', const Color.fromRGBO(30, 60, 87, 1), Colors.white),
                  calcButton(
                      '6', const Color.fromRGBO(30, 60, 87, 1), Colors.white),
                ],
              ),
              // const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton(
                      '1', const Color.fromRGBO(30, 60, 87, 1), Colors.white),
                  calcButton(
                      '2', const Color.fromRGBO(30, 60, 87, 1), Colors.white),
                  calcButton(
                      '3', const Color.fromRGBO(30, 60, 87, 1), Colors.white),
                ],
              ),
              // const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('C', Colors.grey, Colors.black),
                  calcButton(
                      '0', const Color.fromRGBO(30, 60, 87, 1), Colors.white),
                  calcButton('<', Colors.grey, Colors.black),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
