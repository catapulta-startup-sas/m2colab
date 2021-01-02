import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/m2_divider.dart';
import 'package:manda2domis/constants.dart';

class M2TextFielIniciarSesion extends StatelessWidget {
  M2TextFielIniciarSesion(
      {@required this.text,
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
      this.altura,
      this.textCapitalization});
  final String text;
  final TextInputType keyboardType;
  final bool isPassword;
  final Function onChanged;
  final Function onTap;
  final Function onEditingComplete;
  final String imageRoute;
  final Function validator;
  final Color iconColor;
  final String errorText;
  final double width;
  final double height;
  final String initialValue;
  final double altura;
  var textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: [
            Row(
              children: <Widget>[
                Center(
                  child: Container(
                    width: width ?? MediaQuery.of(context).size.width,
                    height: height ?? 50,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              initialValue: initialValue,
                              validator: validator,
                              textCapitalization:
                                  textCapitalization ?? TextCapitalization.none,
                              style: GoogleFonts.poppins(
                                  textStyle: kTextFormFieldTextStyle),
                              textAlign: TextAlign.start,
                              decoration: InputDecoration.collapsed(
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
                            height: altura ?? 24,
                            color: iconColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(17, 50, 17, 0),
              child: M2Divider(),
            )
          ],
        ),
      ],
    );
  }
}
