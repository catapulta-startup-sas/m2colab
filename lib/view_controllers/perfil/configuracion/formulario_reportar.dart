import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_button.dart';
import 'package:manda2domis/components/m2_text_field.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';

class FormularioReportar extends StatefulWidget {
  String tipoReporte;

  FormularioReportar({this.tipoReporte});

  @override
  _FormularioReportarState createState() =>
      _FormularioReportarState(tipoReporte: tipoReporte);
}

class _FormularioReportarState extends State<FormularioReportar> {
  String comentario;
  String tipoReporte;

  Color buttonBackgroundColor = kBlackColorOpacity;
  Color buttonShadowColor = kTransparent;

  bool isSavingChanges = false;
  Color passwordIconColor = kWhiteColor;

  _FormularioReportarState({this.tipoReporte});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      appBar: CupertinoNavigationBar(
        backgroundColor: kFondo,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'images/atras.png',
              color: kWhiteColor,
              width: 25,
            )),
        border: Border(
          bottom: BorderSide(
            color: kBlackColor,
            width: 1.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        middle: Text(
          "Comentarios",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 17,
              color: kWhiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: CatapultaScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(28, 32, 17, 0),
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width - 34,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tipoReporte,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: kWhiteColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(28, 0, 17, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  tipoReporte == 'Algo no funciona'
                      ? 'Por favor, describe el error que identificaste.'
                      : tipoReporte == 'Comentarios generales'
                          ? 'Por favor, explica brevemente lo que te gusta o lo que se podría mejorar.'
                          : 'Por favor, describe lo sucedido. Nos pondremos en contacto lo más rápido posible.',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: kWhiteColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
            M2TextField(
              textCapitalization: TextCapitalization.sentences,
              text: 'Escribe tu reporte',
              title: '',
              height: 200,
              onChanged: (text) {
                comentario = text;
                setState(() {
                  if (comentario != '' && comentario != null) {
                    buttonBackgroundColor = kGreenManda2Color;
                    buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                  } else if (comentario == '') {
                    buttonBackgroundColor = kBlackColorOpacity;
                    buttonShadowColor = kTransparent;
                  }
                });
              },
            ),
            Expanded(child: Container(height: 24)),
            Padding(
              padding: EdgeInsets.only(bottom: 48 ),
              child: M2Button(
                title: "Enviar",
                isLoading: isSavingChanges,
                backgroundColor: buttonBackgroundColor,
                shadowColor: buttonShadowColor,
                onPressed: () {
                  _guardarReporte(comentario);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _guardarReporte(String comentario) async {
    setState(() {
      isSavingChanges = true;
    });

    Map<String, dynamic> reporteMap = {
      "comentario": comentario,
      "ownerId": domi.user.objectId,
      "nombreUsuario": domi.user.name,
      "tipoReporte": tipoReporte,
      "created": DateTime.now().millisecondsSinceEpoch,
    };

    print("⏳ SUBIRÉ REPORTE");
    Firestore.instance.collection("reportes").add(reporteMap).then((r) {
      print("✔️ REPORTE SUBIDO");
      Navigator.pop(context, "Reporte enviado");
      setState(() {
        isSavingChanges = false;
      });
    }).catchError((e) {
      print("💩 ERROR AL SUBIR REPORTE: $e");
      setState(() {
        isSavingChanges = false;
      });
    });
  }
}
