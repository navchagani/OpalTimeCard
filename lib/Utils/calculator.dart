import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  TextEditingController pinCode = TextEditingController();

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
      pinCode.text = text;
    });
  }

  Widget calcButton(String btntxt, Color btncolor, Color txtcolor) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      child: ElevatedButton(
        onPressed: () {
          calculation(btntxt);
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: btncolor,
          padding: EdgeInsets.all(
            height > 800 ? width / 20 : width / 50,
          ),
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height > 800 ? height / 1.85 : height / 1.4,
      width: height > 900 ? width / 1.85 : width / 1.2,
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(20.0),
        elevation: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Enter Your 4-digit No',
                      style: TextStyle(
                        fontSize: width > 600 ? 20 : 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
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
                      width: height > 800 ? width / 7 : width / 20,
                      height: height > 800 ? height / 15 : height / 12,
                      textStyle: const TextStyle(
                        fontSize: 40,
                        color: Color.fromRGBO(30, 60, 87, 1),
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
                  ),
                ),
              ),
              // const SizedBox(height: 10),
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
              // const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('C', Colors.grey, Colors.black),
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
