import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_button.dart';
import 'package:manda2domis/components/m2_recuperar_text_field.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/firebase/handles/reset_password_handle.dart';
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:manda2domis/view_controllers/registro/Recuperar_Contrasena/confirma_reset_password.dart';

class OlvidePassword extends StatefulWidget {
  @override
  _OlvidePasswordState createState() => _OlvidePasswordState();
}

class _OlvidePasswordState extends State<OlvidePassword> {
  String email;
  Color buttonBackgroundColor = kBlackColorOpacity;
  Color buttonShadowColor = kTransparent;
  bool isSendingCodeToMail = false;
  Color iconEmailColor = kWhiteColor;
  RegExp emailRegExp = RegExp("[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorDeFondo,
      appBar: CupertinoNavigationBar(
        actionsForegroundColor: kGreenManda2Color,
        backgroundColor: kFondo,
        middle: FittedBox(
          child: Text(
            "Restaurar contraseña",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kWhiteColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: CatapultaScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            M2TextFielRecuperar(
              title: "E-mail",
              text: "mariano@manda2.app",
              color: iconEmailColor,
              imageRoute: "images/mail.png",
              keyboardType: TextInputType.emailAddress,
              bottomText:
                  'Enviaremos un mensaje a tu e-mail con indicaciones para restaurar tu contraseña.',
              helpText: '',
              width: MediaQuery.of(context).size.width * 0.15,
              width2: MediaQuery.of(context).size.width * 0.47,
              onChanged: (text) {
                setState(() {
                  email = text;
                  if (emailRegExp.hasMatch(email)) {
                    buttonBackgroundColor = kGreenManda2Color;
                    buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                    iconEmailColor = kGreenManda2Color;
                  } else if (email == '') {
                    iconEmailColor = kBlackColor;
                  } else {
                    buttonBackgroundColor = kBlackColorOpacity;
                    buttonShadowColor = kTransparent;
                    iconEmailColor = kRedColor;
                  }
                });
              },
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.03),
              child: M2Button(
                title: "Continuar",
                isLoading: isSendingCodeToMail,
                backgroundColor: buttonBackgroundColor,
                shadowColor: buttonShadowColor,
                onPressed: () {
                  if (email == null || email == "") {
                    showBasicAlert(context, "Por favor, ingresa tu email.", "");
                  } else {
                    _sendCodeToMail(context, email);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sendCodeToMail(context, email) {
    setState(() {
      isSendingCodeToMail = true;
    });
    print("⏳ ENVIARÉ EMAIL");
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((r) {
      setState(() {
        isSendingCodeToMail = false;
      });
      print("✔️ EMAIL ENVIADO");
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ConfirmacionResetPassword(),
        ),
      );
    }).catchError((e) {
      print("💩 ERROR AL ENVIAR EMAIL: $e");
      if (e is PlatformException) {
        handleResetPasswordError(context, e.code);
      }
      setState(() {
        isSendingCodeToMail = false;
      });
    });
  }
}
