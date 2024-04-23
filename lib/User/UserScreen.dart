import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opaltimecard/Utils/calculator.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    String Date = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    String Time = DateFormat('hh:mm a').format(DateTime.now());
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Texas E Cigrates Inc',
                    style: TextStyle(fontSize: 50, color: Color(0xff390E82)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    Date,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    Time,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  )
                ],
              )),
              const Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Calculator()],
              )),
            ],
          )
        ],
      ),
    );
  }
}
