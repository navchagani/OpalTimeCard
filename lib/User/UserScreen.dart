import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:opaltimecard/Utils/calculator.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String Date = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    String Time = DateFormat('hh:mm a').format(DateTime.now());
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 29, 29),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Texas E Cigrates Inc',
                    style: TextStyle(
                        fontSize: width > 600 ? 30 : 20,
                        color: Color.fromARGB(255, 177, 149, 226),
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    Time,
                    style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                  Text(
                    Date,
                    style: TextStyle(
                        fontSize: width > 600 ? 30 : 20, color: Colors.white),
                  ),
                  SizedBox(
                    height: height > 768 ? height / 20 : height / 30,
                  ),
                  const Calculator()
                ],
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () {},
          child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.power_settings_new_rounded,
                  color: Colors.deepOrange))),
    );
  }

  logout() {
    return AlertDialog(
        // title: "",
        );
  }
}
