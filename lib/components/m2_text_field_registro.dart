import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/m2_divider.dart';
import 'package:manda2domis/constants.dart';

class M2TextFielIdAgregarTarjeta extends StatelessWidget {
  M2TextFielIdAgregarTarjeta(
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
      this.inputFormatters,
      this.textCapitalization,
      this.initialValue});
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
  final String initialValue;
  final List<TextInputFormatter> inputFormatters;
  final TextCapitalization textCapitalization;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 61,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            color: kBlackColorOpacity.withOpacity(0.4),
                          ),
                        )),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                initialValue: initialValue,
                                inputFormatters: inputFormatters,
                                validator: validator,
                                textCapitalization: textCapitalization ??
                                    TextCapitalization.sentences,
                                style: GoogleFonts.poppins(
                                    textStyle: kTextFormFieldTextStyle),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration.collapsed(
                                  hintText: text,
                                  hintStyle: GoogleFonts.poppins(
                                    textStyle:
                                        kTextFormFieldHintTextStyleInicioSesion,
                                  ),
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
                              width: 24,
                              height: 24,
                              color: iconColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
