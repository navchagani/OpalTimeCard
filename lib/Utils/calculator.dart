import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  dynamic text = '';
  final bool _isObscure = true;

  void calculation(btnText) {
    setState(() {
      if (btnText == 'AC') {
        text = '';
      } else if (btnText == '<') {
        if (text.length > 1) {
          text = text.substring(0, text.length - 1);
        } else {
          text = '';
        }
      } else {
        if (text == '') {
          text = btnText;
        } else {
          text = text + btnText;
        }
      }
    });
  }

  Widget calcButton(String btntxt, Color btncolor, Color txtcolor) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          calculation(btntxt);
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: btncolor,
          padding: const EdgeInsets.all(15),
        ),
        child: Text(
          btntxt,
          style: TextStyle(
            fontSize: 20,
            color: txtcolor,
          ),
        ),
      ),
    );
  }

  String obscureText(String text) {
    return '*' * text.length;
  }

  @override
  Widget build(BuildContext context) {
    String obscuredText = obscureText(text);

    return SizedBox(
      height: 600,
      width: 400,
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Enter Your 4-digit No',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 50, bottom: 40, left: 30, right: 40),
                    child: Text(
                      obscuredText,
                      // "$text",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('7', Colors.grey[850]!, Colors.white),
                  calcButton('8', Colors.grey[850]!, Colors.white),
                  calcButton('9', Colors.grey[850]!, Colors.white),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('4', Colors.grey[850]!, Colors.white),
                  calcButton('5', Colors.grey[850]!, Colors.white),
                  calcButton('6', Colors.grey[850]!, Colors.white),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('1', Colors.grey[850]!, Colors.white),
                  calcButton('2', Colors.grey[850]!, Colors.white),
                  calcButton('3', Colors.grey[850]!, Colors.white),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('AC', Colors.grey, Colors.black),
                  calcButton('0', Colors.grey[850]!, Colors.white),
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
