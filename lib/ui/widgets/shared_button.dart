import 'package:flutter/material.dart';

import '../../utils.dart';


class ShareButton extends StatelessWidget{

  final VoidCallback onPressed;
  final double width;
  final double height;
  final double paddingHorizontal;
  final double paddingVertical;
  final Color color;
  final double textSize;

  ShareButton({
    @required this.onPressed,
    this.width,
    this.height,
    this.paddingHorizontal,
    this.paddingVertical,
    this.color,
    this.textSize
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal?? 10, vertical: paddingVertical?? 5),
        height: height ?? 28,
        width: width,
        decoration: BoxDecoration(
            color: color?? Color(0xFF4FCE5D),
            borderRadius: BorderRadius.circular( height!=null ? height/2 : 14)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/wa_logo_white.png"),
            SizedBox(width: 5,),
            Text(
              "Share",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: textSize??15
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class FilledButton extends StatelessWidget {

  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback onPressed;

  FilledButton({this.color, this.textColor, @required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color ?? colorBlue,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: textColor ?? Colors.white
            ),
          ),
        ),
      ),
    );
  }
}