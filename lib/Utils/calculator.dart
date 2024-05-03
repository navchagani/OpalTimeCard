// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opaltimecard/User/Modal/usermodal.dart';
import 'package:opaltimecard/User/Services/userService.dart';
import 'package:opaltimecard/bloc/Blocs.dart';
import 'package:pinput/pinput.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  TextEditingController pinCode = TextEditingController();
  UserService userService = UserService();

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

  void employeeAttendance({required BuildContext context}) async {
    await userService.userAttendance(context, pinCode.text);

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
