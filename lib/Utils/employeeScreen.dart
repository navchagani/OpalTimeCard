// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';
import 'package:opaltimecard/User/Modal/EmployeeData.dart';
import 'package:opaltimecard/localDatabase/DatabaseHelper.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  TextEditingController pinCode = TextEditingController();
  // UserService userService = UserService();
  List<LoggedInUser>? currentUser;
  List<EmployeeAttendance> attendanceList = [];

  String text = '';
  FocusNode pinFocusNode = FocusNode();

  @override
  void initState() {
    pinFocusNode.addListener(() {
      if (!pinFocusNode.hasFocus) {
        pinCode.clear();
        log('Employee not found with pin ${pinCode.text}');
      }
    });
    super.initState();
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
            return const Employees();
          },
        );
        EmployeeAttendance? lastAttendance = await DatabaseHelper.instance
            .getLastAttendance(matchedEmployee.pin!);

        if (lastAttendance != null && lastAttendance.status == 'in') {
          List<String> parts = lastAttendance.time!.split(":");
          int hours = int.parse(parts[0]);
          int minutes = int.parse(parts[1]);

          List<String> dateParts = lastAttendance.date!.split("-");
          int year = int.parse(dateParts[0]);
          int month = int.parse(dateParts[1]);
          int day = int.parse(dateParts[2]);

          DateTime dateTime = DateTime(year, month, day, hours, minutes);
          String lastTime = DateFormat('hh:mm a').format(dateTime);

          DateTime time1 = DateTime.now();
          Duration difference = time1.difference(dateTime);

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              double width = MediaQuery.of(context).size.width;

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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ' ${matchedEmployee.name ?? "Unknown"}',
                                      style: TextStyle(
                                        fontSize: width < 700 ? 18 : 25,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Out',
                                        style: TextStyle(
                                            fontSize: width < 700 ? 20 : 25,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        DateFormat('hh:mm a')
                                            .format(DateTime.now()),
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
                                        "${lastAttendance.date ?? ''} $lastTime",
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
                                        DateFormat('yyyy-MM-dd hh:mm aa')
                                            .format(DateTime.now()),
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
                                        "${difference.inHours.toString().padLeft(2, '0')}:${difference.inMinutes.remainder(60).toString().padLeft(2, '0')}",
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
            },
          ).whenComplete(() async {
            String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
            String currentDate =
                DateFormat('yyyy-MM-dd').format(DateTime.now());
            await DatabaseHelper.instance.insertAttendance(
              lastAttendance.copyWith(
                time: currentTime,
                date: currentDate,
                uid: loggedInUser.uid,
                status: 'out',
              ),
            );
          });
          final player = AudioPlayer();
          await player.play(AssetSource('audios/out.mp3'));
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.of(context, rootNavigator: true).pop();
          });
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
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
                                  style: TextStyle(
                                    fontSize: width < 700 ? 18 : 25,
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
                              'IN: ${DateFormat('hh:mm a').format(DateTime.now())}',
                              style: TextStyle(
                                  fontSize: width < 700 ? 20 : 25,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
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
            String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
            String currentDate =
                DateFormat('yyyy-MM-dd').format(DateTime.now());
            EmployeeAttendance attendanceRecord = EmployeeAttendance(
              employeeId: matchedEmployee.id,
              employeeName: matchedEmployee.name,
              pin: matchedEmployee.pin,
              time: currentTime,
              date: currentDate,
              uid: loggedInUser.uid,
              status: 'in',
            );
            int id = await DatabaseHelper.instance
                .insertAttendance(attendanceRecord);
            log('Attendance record inserted with ID: $id');
          });
          final player = AudioPlayer();
          await player.play(AssetSource('audios/in.mp3'));
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.of(context, rootNavigator: true).pop();
          });
        }
      } else {
        final player = AudioPlayer();
        await player.play(AssetSource('audios/pleasetryagain.mp3'));
        _showerrorDailog(context);
      }
    }

    setState(() {
      pinCode.clear();
      text = '';
    });
  }

  void _showerrorDailog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return errorDailog(context);
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  errorDailog(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Dialog(
      child: SizedBox(
        width: width > 800 ? width * 0.3 : width * 0.5,
        child: Wrap(
          children: [
            Column(children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.red,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Alert',
                        style: TextStyle(
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
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text("Invalid User",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: width < 700 ? 20 : 25,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget calcButton(String btntxt, Color btncolor, Color txtcolor) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      child: ElevatedButton(
        onPressed: () async {
          calculation(btntxt);
          final player = AudioPlayer();
          await player.play(AssetSource('audios/touch.mp3'));
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
