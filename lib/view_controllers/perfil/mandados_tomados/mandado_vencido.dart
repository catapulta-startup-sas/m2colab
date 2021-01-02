import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_container_configuracion.dart';
import 'package:manda2domis/firebase/start_databases/get_constantes.dart';
import 'package:manda2domis/functions/launch_whatsapp.dart';
import 'package:manda2domis/functions/llamar.dart';
import 'package:manda2domis/model/mandado_model.dart';
import 'package:manda2domis/view_controllers/perfil/mandados_tomados/detalles.dart';

import '../../../constants.dart';

class MandadoVencido extends StatefulWidget {
  MandadoVencido({this.mandado});
  Mandado mandado;
  @override
  _MandadoVencidoState createState() => _MandadoVencidoState(mandado: mandado);
}

class _MandadoVencidoState extends State<MandadoVencido> {
  _MandadoVencidoState({this.mandado});
  Mandado mandado;
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
            )),
        middle: Text(
          "Solicitud del mandado",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 17, color: kWhiteColor, fontWeight: FontWeight.w500),
          ),
        ),
        border: Border.all(color: kBlackColor),
      ),
      body: CatapultaScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(17, 17, 17, 0),
              child: Text(
                "Mandado vencido",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 15,
                    color: kWhiteColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 17),
              child: Text(
                "Dejaste vencer el mandado, contacta al comprador para extender el plazo.",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 12,
                      color: kWhiteColor.withOpacity(0.5),
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ContainerConfiguracion(
              text: 'Ver resumen de mandado',
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => Detalles(
                      mandado: mandado,
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            ContainerConfiguracion(
              text: 'Contactar a comprador',
              onTap: () {
                llamar(context, mandado.destino.contactoPhoneNumber);
              },
            ),
            SizedBox(
              height: 10,
            ),
            ContainerConfiguracion(
              text: 'Escribir a soporte',
              onTap: () {
                _alertContactSoporte();
              },
            ),
            SizedBox(
              height: 10,
            ),

            /// Antes [Eliminar mandado]. Lo comenté porque sobra y no es
            /// necesario enredarnos con esa funcionalidad ahora. Tal vez
            /// debamos integrarla más adelante, así que dejo el front aquí
            /// montado de una. No eliminar.
            /*
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 20,
                        height: 50,
                        color: kBlackColor,
                      ),
                      Container(
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Eliminar mandado',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 13,
                                  color: kRedColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              )
               */
          ],
        ),
      ),
    );
  }

  void _alertContactSoporte() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text("Serás redirigido a un chat de WhatsApp"),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Abrir en WhatsApp"),
            isDestructiveAction: false,
            onPressed: () {
              launchWhatsApp(context, "$contactoSoporte".replaceAll("+", ""));
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Volver"),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
