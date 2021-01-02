import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/m2_divider.dart';

import '../constants.dart';

class M2Editar extends StatelessWidget {
  M2Editar({
    this.titulo,
    this.text,
    this.keyboardType,
    this.isPassword,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.imageRoute,
    this.validator,
    this.iconColor,
    this.errorText,
    this.width,
    this.height,
    this.initialValue,
    this.capitalization,
  });
  String titulo;
  String text;
  String imageRoute;
  final TextInputType keyboardType;
  final bool isPassword;
  final Function onChanged;
  final Function onTap;
  final Function onEditingComplete;
  final Function validator;
  final Color iconColor;
  final String errorText;
  final double width;
  final double height;
  var capitalization;
  String initialValue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(17, 0, 0, 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                '$titulo',
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 15, color: kBlackColorOpacity)),
              ),
            ),
          ),
          Center(
            child: Container(
              width: width ?? MediaQuery.of(context).size.width,
              height: height ?? 50,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
                    child: Stack(
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                textCapitalization:
                                    capitalization ?? TextCapitalization.none,
                                initialValue: initialValue,
                                validator: validator,
                                style: GoogleFonts.poppins(
                                    textStyle: kTextFormFieldTextStyle),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration.collapsed(
                                  hintText: text,
                                  hintStyle: GoogleFonts.poppins(
                                      textStyle:
                                          kTextFormFieldHintTextStyleInicioSesion),
                                ),
                                keyboardType:
                                    keyboardType ?? TextInputType.text,
                                keyboardAppearance: Brightness.dark,
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
                              color: iconColor ?? kGreenManda2Color,
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 35),
                          child: M2Divider(),
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
    );
  }
}
