import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class M2TextFielRecuperar extends StatelessWidget {
  M2TextFielRecuperar({
    @required this.title,
    @required this.text,
    @required this.helpText,
    @required this.bottomText,
    @required this.width,
    @required this.width2,
    this.keyboardType,
    this.isPassword,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.imageRoute,
    this.color,
    this.initialValue,
  });
  final String title;
  final String text;
  final String helpText;
  final String bottomText;
  final TextInputType keyboardType;
  final bool isPassword;
  final Function onChanged;
  final Function onTap;
  final Function onEditingComplete;
  final String imageRoute;
  final double width;
  final double width2;
  final Color color;
  String initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.058),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: kWhiteColor,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.022,
                width: 130,
                child: FittedBox(
                  child: Text(
                    '$helpText',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: kBlackColorOpacity,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.082,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.058),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              style: GoogleFonts.poppins(
                                  textStyle: kTextFormFieldTextStyle),
                              textAlign: TextAlign.start,
                              initialValue: initialValue,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: kBlackColorOpacity),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: kBlackColorOpacity),
                                ),
                                hintText: text,
                                hintStyle: GoogleFonts.poppins(
                                    textStyle:
                                        kTextFormFieldHintTextStyleInicioSesion),
                              ),
                              keyboardType: keyboardType ?? TextInputType.text,
                              obscureText: isPassword ?? false,
                              onChanged: onChanged,
                              onTap: onTap,
                              onEditingComplete: onEditingComplete,
                            ),
                          ),
                          Image(
                            image: AssetImage(
                              '$imageRoute',
                            ),
                            height: 24,
                            color: color,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: Text(
            "$bottomText",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 15,
                  color: kWhiteColor,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
