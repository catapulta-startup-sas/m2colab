import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class M2TextField extends StatelessWidget {
  M2TextField({
    @required this.text,
    @required this.title,
    this.keyboardType,
    this.isPassword,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.width,
    this.height,
    this.textCapitalization,
  });
  final String text;
  final String title;
  final TextInputType keyboardType;
  final bool isPassword;
  final Function onChanged;
  final Function onTap;
  final Function onEditingComplete;
  final double width;
  final double height;
  var textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            title == ""
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width * 0.86,
                    height: MediaQuery.of(context).size.height * 0.05,
                    alignment: Alignment(-1, 0),
                    child: FittedBox(
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          textStyle: kTextFormFieldTittleTextStyle,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
          ],
        ),
        Container(
          width: width ?? MediaQuery.of(context).size.width * 0.86,
          height: height ?? MediaQuery.of(context).size.height * 0.065,
          decoration: BoxDecoration(
              borderRadius: kRadiusAll,
              border: Border.all(color: kBlackColorOpacity)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              maxLines: 20,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              style: GoogleFonts.poppins(textStyle: kTextFormFieldTextStyle),
              textAlign: TextAlign.start,
              decoration: InputDecoration.collapsed(
                hintText: text,
                hintStyle:
                    GoogleFonts.poppins(textStyle: kTextFormFieldHintTextStyle),
              ),
              keyboardType: keyboardType ?? TextInputType.text,
              obscureText: isPassword ?? false,
              onChanged: onChanged,
              onTap: onTap,
              onEditingComplete: onEditingComplete,
            ),
          ),
        ),
      ],
    );
  }
}
