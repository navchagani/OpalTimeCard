import 'package:flutter/material.dart';

class ConstDialog {
  final BuildContext context;
  ConstDialog(this.context);

  showErrorDialog({
    required String error,
    String? title,
    final IconData? iconData,
    Color? iconColor,
    double? iconSize,
    String? iconText,
    final Function()? ontap, // Make ontap optional
  }) {
    showDialog(
      barrierColor: Colors.black87,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                iconData ?? Icons.error,
                color: iconColor ?? const Color(0xff390E82),
                size: iconSize ?? 20.0,
              ),
              const SizedBox(width: 8),
              Text(iconText ?? 'Alert'),
            ],
          ),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: ontap ??
                  () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  showLoadingDialog({String? text}) {
    showDialog(
        context: context,
        builder: ((context) => Dialog(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(text ?? 'Loading Please wait...')
                  ],
                ),
              ),
            )));
  }
}
