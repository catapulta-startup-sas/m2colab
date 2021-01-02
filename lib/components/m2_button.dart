import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

// ignore: must_be_immutable
class M2Button extends StatelessWidget {
  M2Button({
    @required this.onPressed,
    this.title,
    this.backgroundColor,
    this.shadowColor,
    this.isLoading,
    this.width,
    this.fontWeight
  });
  String title;
  Color backgroundColor;
  Color shadowColor;
  Function onPressed;
  bool isLoading;
  double width;
  var fontWeight;

  @override
  Widget build(BuildContext context) {
    if (isLoading == null) isLoading = false;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 60,
          width: width ?? MediaQuery.of(context).size.width - 34,
          decoration: BoxDecoration(
            color: backgroundColor ?? kBlackColor,
            borderRadius: kRadiusAll,

          ),
          child: CupertinoButton(
            child: FittedBox(
              child: isLoading
                  ? Container(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kBlackColor),
                  strokeWidth: 3,
                ),
              )
                  : FittedBox(
                    child: Text(
                title ?? "Continuar",
                style: GoogleFonts.poppins(textStyle: TextStyle(
                  color: kBlackColor,
                  fontSize: 15,
                  fontWeight: fontWeight ?? FontWeight.w400,
                )),
              ),
                  ),
            ),
            onPressed: onPressed,
          ),
        ),

      ],
    );
  }
}
