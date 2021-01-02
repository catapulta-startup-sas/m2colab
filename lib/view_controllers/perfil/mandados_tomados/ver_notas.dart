import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_button.dart';
import 'package:manda2domis/components/m2_datos_entrega_o_recogida.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/model/mandado_model.dart';
import 'package:url_launcher/url_launcher.dart';

class VerNotas extends StatefulWidget {
  final Mandado mandado;

  VerNotas({
    this.mandado,
  });

  @override
  _VerNotasState createState() => _VerNotasState(
        mandado: mandado,
      );
}

class _VerNotasState extends State<VerNotas> {
  _VerNotasState({
    this.mandado,
  });

  final Mandado mandado;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorDeFondo,
      appBar: CupertinoNavigationBar(
        actionsForegroundColor: kGreenManda2Color,
        backgroundColor: kBlackColor,
        middle: FittedBox(
          child: Text(
            "Notas",
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
            Container(
              margin: EdgeInsets.fromLTRB(17, 28, 17, 0),
              padding: EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: kBlackColor,
                borderRadius: kRadiusAll,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(27, 0, 27, 0),
                    child: Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width - 88,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          child: Text(
                            "Notas al domiciliario",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 15, color: kBlackColorOpacity)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(27, 0, 27, 0),
                    child: Text(
                      mandado.descripcion,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: kWhiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
