import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_container_configuracion.dart';
import 'package:manda2domis/components/m2_sin_conexion_container.dart';

import '../../../constants.dart';
import 'formulario_reportar.dart';

class Reportar extends StatefulWidget {
  @override
  _ReportarState createState() => _ReportarState();
}

class _ReportarState extends State<Reportar> {
  String tipoReporte = "";
  bool successContainerIsHidden = true;
  String successContainerMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      appBar: CupertinoNavigationBar(
        backgroundColor: kBlackColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'images/atras.png',
              color: kWhiteColor,
              width: 25,
            )),        border: Border(
          bottom: BorderSide(
            color: kBlackColor,
            width: 1.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        middle: Text(
          "Reportar",
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
            M2AnimatedContainer(
              height: successContainerIsHidden ? 0 : 50,
              backgroundColor: kGreenManda2Color.withOpacity(0.7),
              text: successContainerMessage ?? "",
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(17, 32, 17, 0),
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width - 34,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      'Reportar un problema',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: kWhiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 17, 32),
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width - 34,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      '¿Qué sucede?',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: kWhiteColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ContainerConfiguracion(
              text: 'Algo no funciona',
              onTap: () async {
                setState(() {
                  tipoReporte = "Algo no funciona";
                });
                final result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => FormularioReportar(
                      tipoReporte: tipoReporte,
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    successContainerIsHidden = false;
                    successContainerMessage = result as String;
                  });
                  Future.delayed(Duration(seconds: 3)).then((r) {
                    setState(() {
                      successContainerIsHidden = true;
                    });
                  });
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            ContainerConfiguracion(
              text: 'Comentarios generales',
              onTap: () async {
                setState(() {
                  tipoReporte = "Comentarios generales";
                });
                final result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => FormularioReportar(
                      tipoReporte: tipoReporte,
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    successContainerIsHidden = false;
                    successContainerMessage = result as String;
                  });
                  Future.delayed(Duration(seconds: 3)).then((r) {
                    setState(() {
                      successContainerIsHidden = true;
                    });
                  });
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            ContainerConfiguracion(
              text: 'Problema con la calidad del servicio',
              onTap: () async {
                setState(() {
                  tipoReporte = "Problema con la calidad del servicio";
                });
                final result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => FormularioReportar(
                      tipoReporte: tipoReporte,
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    successContainerIsHidden = false;
                    successContainerMessage = result as String;
                  });
                  Future.delayed(Duration(seconds: 3)).then((r) {
                    print("QUITA LA BARRA");
                    setState(() {
                      successContainerIsHidden = true;
                    });
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
