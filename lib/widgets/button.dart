import 'package:flutter/material.dart';

import '../helper/constant.dart';

/// full rounded button
class FullRoundedButton extends StatelessWidget {
  final String text;
  final double height;
  final Color background;
  final Color color;
  final Function()? onPressed;

  const FullRoundedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 50,
    this.background = primaryColor,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(color: background),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(background),
          elevation: MaterialStateProperty.all(0),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
