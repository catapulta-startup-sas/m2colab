import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class TituloSubTitulo extends StatelessWidget {
  String title;
  String text;
  bool noInicado = false;
  TituloSubTitulo({this.title, this.text, this.noInicado});
  @override
  Widget build(BuildContext context) {
    if (noInicado == null) noInicado = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 14,
                color: kBlackColorOpacity,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        SizedBox(height: 7),
        Text(
          text,
          style: noInicado
              ? GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 15,
                      color: kWhiteColor.withOpacity(0.3),
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic),
                )
              : GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 15,
                      color: kWhiteColor,
                      fontWeight: FontWeight.w300),
                ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
