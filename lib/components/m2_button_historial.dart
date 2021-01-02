import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

// ignore: must_be_immutable
class M2ButtonHistorial extends StatelessWidget {
  M2ButtonHistorial({
    @required this.onPressed,
    this.title,
    this.backgroundColor,
    this.shadowColor,
    this.isLoading,
    this.width
  });
  String title;
  Color backgroundColor;
  Color shadowColor;
  Function onPressed;
  bool isLoading;
  double width;

  @override
  Widget build(BuildContext context) {
    if (isLoading == null) isLoading = false;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 60,
          width: width ?? MediaQuery.of(context).size.width * 0.87,
          decoration: BoxDecoration(
            border: Border.all(
              color: kGreenManda2Color

            ),
            color: backgroundColor ?? kTransparent,
            borderRadius: kRadiusAll,
          ),


          child: CupertinoButton(
            child: FittedBox(
              child: isLoading
                  ? Container(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kWhiteColor),
                  strokeWidth: 3,
                ),
              )
                  : FittedBox(
                child: Text(
                  title ?? "Detalles",
                  style: GoogleFonts.poppins(textStyle: TextStyle(
                    color: kGreenManda2Color,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
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