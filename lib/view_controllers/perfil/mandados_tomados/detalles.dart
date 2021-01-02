import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_divider.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/firebase/start_databases/get_constantes.dart';
import 'package:manda2domis/functions/launch_whatsapp.dart';
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:manda2domis/model/mandado_model.dart';
import 'package:manda2domis/view_controllers/Home/mandado_entregado.dart';

class Detalles extends StatefulWidget {
  final Mandado mandado;
  Detalles({
    this.mandado,
  });

  @override
  _DetallesState createState() {
    return _DetallesState(
      mandado: mandado,
    );
  }
}

class _DetallesState extends State<Detalles> {
  _DetallesState({
    this.mandado,
  });

  final Mandado mandado;
  bool isEntrega;

  bool successContainerIsHidden = true;
  String successContainerMessage;

  @override
  void initState() {
    super.initState();
  }

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
        border: Border.all(color: kBlackColor),
        middle: Text(
          "Detalles del mandado",
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
        child: Container(
          color: kBlackColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Mandado
              Padding(
                padding: EdgeInsets.fromLTRB(17, 18, 17, 0),
                child: Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      child: Text(
                        'Mandado:  ${mandado.categoria.emoji} ${mandado.categoria.title}',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: kWhiteColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// de donde sale el mandado
              Padding(
                padding: EdgeInsets.fromLTRB(17, 20, 17, 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          child: Text(
                            '${mandado.origen.contactoName}',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: kWhiteColor, fontSize: 14)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Origen
              Padding(
                padding: EdgeInsets.fromLTRB(17, 5, 17, 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 30,
                      child: Text(
                        'De:',
                        style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(color: kWhiteColor, fontSize: 12)),
                      ),
                    ),
                    Text(
                      '${mandado.origen.direccion}, ${mandado.origen.ciudad}',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: kWhiteColor.withOpacity(0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w300)),
                    ),
                  ],
                ),
              ),

              ///Destino
              Padding(
                padding: EdgeInsets.fromLTRB(17, 5, 17, 20),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 30,
                      child: Text(
                        'A:',
                        style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(color: kWhiteColor, fontSize: 12)),
                      ),
                    ),
                    Text(
                      '${mandado.destino.direccion}, ${mandado.destino.ciudad}',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: kWhiteColor.withOpacity(0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w300)),
                    ),
                  ],
                ),
              ),
              M2Divider(),

              /// Tipo pago
              Padding(
                padding: EdgeInsets.fromLTRB(17, 21, 17, 21),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          child: Text(
                            'Tipo de pago',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: kWhiteColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          child: Text(
                            mandado.tipoPago == "Efectivo contra entrega"
                                ? "Efectivo"
                                : 'Online',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: kWhiteColor.withOpacity(0.5),
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              M2Divider(),

              ///Identificador
              Padding(
                padding: EdgeInsets.fromLTRB(17, 20, 17, 18),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          child: Text(
                            'Identificador ',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: kBlackColorOpacity, fontSize: 14)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      '${mandado.identificador}',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: kBlackColorOpacity, fontSize: 14)),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _alertContactSoporte();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 17),
                  child: Container(
                    height: 25,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      'Escribir a soporte',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: kGreenManda2Color,
                              fontSize: 14,
                              fontWeight: FontWeight.w300)),
                    ),
                  ),
                ),
              ),
            ],
          ),
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

  String getMandadoStatusString() {
    if (mandado.isEntregado) {
      return "Entregado";
    }
    // else if (mandado.isEnCamino) {
    //   return "En camino";
    // }
    else if (mandado.isTomado) {
      return "Tomado";
    }
    // else if (mandado.isCancelado) {
    //   return "Cancelado";
    // }
    else {
      return "";
    }
  }

  String getTipoPagoString() {
    if (mandado.tipoPago == "Efectivo contra entrega" ||
        (mandado.tipoPago != "Envío redimible")) {
      return "Efectivo";
    } else {
      return "Online";
    }
  }

  void marcarEntregadoBack() {
    Map<String, dynamic> mandadoMap = {
      "estados.isEntregado": true,
      "estados.dates.entregado": DateTime.now().millisecondsSinceEpoch,
    };
    print("ACTUALIZARÉ MANDADO");
    Firestore.instance
        .document("mandados/${mandado.id}")
        .updateData(mandadoMap)
        .then((r) {
      print("MANDADO ACTUALIZADO");
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MandadoEntregado(),
        ),
      );
    }).catchError((e) {
      print("ERROR AL ACTUALIZAR MANDADO: $e");
      showBasicAlert(
        context,
        "Hubo un error.",
        "Por favor, intenta más tarde.",
      );
    });
  }

  void cancelarMandadoBack() {
    Map<String, dynamic> mandadoMap = {
      "estados.isTomado": false,
      "estados.dates.tomado": null,
      "domiciliario": {
        "id": null,
        "fotoPerfilURL": null,
        "califPromedio": null,
        "numCalificaciones": null,
        "phoneNumber": null,
        "name": null,
      },
    };
    print("CANCELARÉ MANDADO");
    Firestore.instance
        .document("mandados/${mandado.id}")
        .updateData(mandadoMap)
        .then((r) {
      print("MANDADO CANCELADO");
      Navigator.pop(context);
      Navigator.pop(context, "Cancelado");
    }).catchError((e) {
      print("ERROR AL CANCELAR MANDADO: $e");
      showBasicAlert(
        context,
        "Hubo un error.",
        "Por favor, intenta más tarde.",
      );
    });
  }

  void _showAlertCancelar() {
    showAlert(
      context: context,
      title: "¿Quieres cancelar el mandado?",
      body:
          "Desaparecerá de tu historial y será publicado de nuevo, para que otros domiciliarios puedan tomarlo.",
      actions: [
        AlertAction(text: "Volver", isDefaultAction: true),
        AlertAction(
          text: "Sí, cancelar",
          isDestructiveAction: true,
          onPressed: () {
            cancelarMandadoBack();
          },
        ),
      ],
    );
  }

  // handleTrailingActionSheet(BuildContext context) {
  //   if (mandado.isEntregado) {
  //     showCupertinoModalPopup(
  //         context: context,
  //         builder: (context) {
  //           return Padding(
  //             padding: EdgeInsets.only(bottom: 20),
  //             child: CupertinoActionSheet(
  //               actions: <Widget>[
  //                 CupertinoActionSheetAction(
  //                   child: Text('Llamar a soporte'),
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     llamar(context, contactoSoporte);
  //                   },
  //                 ),
  //               ],
  //               cancelButton: CupertinoActionSheetAction(
  //                 child: Text('Volver'),
  //                 isDefaultAction: true,
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ),
  //           );
  //         });
  //   } else {
  //     showCupertinoModalPopup(
  //         context: context,
  //         builder: (context) {
  //           return Padding(
  //             padding: EdgeInsets.only(bottom: 20),
  //             child: CupertinoActionSheet(
  //               actions: <Widget>[
  //                 CupertinoActionSheetAction(
  //                   child: Text('Llamar al cliente'),
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     llamar(context, mandado.cliente.phoneNumber);
  //                   },
  //                 ),
  //                 CupertinoActionSheetAction(
  //                   child: Text('Llamar a soporte'),
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     llamar(context, contactoSoporte);
  //                   },
  //                 ),
  //               ],
  //               cancelButton: CupertinoActionSheetAction(
  //                 child: Text('Volver'),
  //                 isDefaultAction: true,
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ),
  //           );
  //         });
  //   }
  // }
}
