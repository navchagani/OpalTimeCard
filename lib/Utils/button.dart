import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final double? buttonSize;
  final Function()? onTap;
  final String title;
  final Color? color;
  const CustomButton(
      {super.key,
      this.onTap,
      required this.title,
      this.color,
      this.buttonSize});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = widget.buttonSize ?? screenWidth;
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: buttonWidth,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          margin: const EdgeInsets.only(left: 3, right: 3),
          decoration: BoxDecoration(
            color: widget.color ?? const Color(0xff390E82),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
