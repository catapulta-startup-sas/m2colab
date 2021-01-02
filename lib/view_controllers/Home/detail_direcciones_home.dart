import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_button.dart';
import 'package:manda2domis/components/m2_datos_entrega_o_recogida.dart';
import 'package:manda2domis/components/m2_sin_conexion_container.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/functions/llamar.dart';
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:manda2domis/model/mandado_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RecogidaEntregaHome extends StatefulWidget {
  bool isEntrega;
  final Mandado mandado;

  RecogidaEntregaHome({
    this.isEntrega,
    this.mandado,
  });

  @override
  _RecogidaEntregaHomeState createState() =>
      _RecogidaEntregaHomeState(isEntrega: isEntrega, mandado: mandado);
}

class _RecogidaEntregaHomeState extends State<RecogidaEntregaHome> {
  _RecogidaEntregaHomeState({
    this.isEntrega,
    this.mandado,
  });

  final Mandado mandado;
  bool isEntrega;

  double longitudInicial;
  double latitudInicial;
  String destino = '';
  String destinoSinEspacios;
  String origen = '';
  String origenSinEspacios;

  bool successContainerIsHidden = true;
  String successContainerMessage = "";

  bool failureContainerIsHidden = true;
  String failureContainerMessage = "";

  @override
  void initState() {
    origen = '${mandado.origen.direccion} ${mandado.origen.ciudad}';
    destino = '${mandado.destino.direccion} ${mandado.destino.ciudad}';
    convertirUbicacionDestino();
    convertirUbicacionOrigen();
    obtenerUbicacion();
    super.initState();
  }

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
          isEntrega == true ? "Datos de entrega" : 'Datos de recogida',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 17,
              color: kWhiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        border: Border.all(color: kBlackColor),
      ),
      body: Stack(
        children: <Widget>[
          CatapultaScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),

                  ///Nombre completo
                  TituloSubTitulo(
                    title: 'Nombre completo',
                    text: isEntrega
                        ? mandado.destino.contactoName
                        : mandado.origen.contactoName,
                    noInicado: false,
                  ),

                  ///Celular
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TituloSubTitulo(
                        title: 'Celular',
                        text: isEntrega
                            ? mandado.destino.contactoPhoneNumber
                            : mandado.origen.contactoPhoneNumber,
                        noInicado: false,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isEntrega) {
                            llamar(
                                context, mandado.destino.contactoPhoneNumber);
                          } else {
                            llamar(context, mandado.origen.contactoPhoneNumber);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Llamar',
                            style: GoogleFonts.poppins(
                              color: kGreenManda2Color,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///Ciudad
                  TituloSubTitulo(
                    title: 'Ciudad',
                    text: isEntrega
                        ? mandado.destino.ciudad ?? "Medellín"
                        : mandado.origen.ciudad ?? "Medellín",
                    noInicado: false,
                  ),

                  ///Dir
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TituloSubTitulo(
                        title: 'Dirección',
                        text: isEntrega
                            ? mandado.destino.direccion
                            : mandado.origen.direccion,
                        noInicado: false,
                      ),
                      GestureDetector(
                        onTap: _handleVerMapa,
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                          child: Text(
                            'Ver mapa',
                            style: GoogleFonts.poppins(
                              color: kGreenManda2Color,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///Barrio
                  TituloSubTitulo(
                      title: 'Barrio',
                      text: isEntrega
                          ? mandado.destino.barrio ?? "No indicado"
                          : mandado.origen.barrio ?? "No indicado",
                      noInicado: isEntrega
                          ? mandado.destino.barrio == null ? true : false
                          : mandado.origen.barrio == null ? true : false),

                  ///Edificio
                  TituloSubTitulo(
                      title: 'Edificio',
                      text: isEntrega
                          ? mandado.destino.edificio ?? "No indicado"
                          : mandado.origen.edificio ?? "No indicado",
                      noInicado: isEntrega
                          ? mandado.destino.edificio == null ? true : false
                          : mandado.origen.edificio == null ? true : false),

                  ///Interior
                  TituloSubTitulo(
                      title: 'Interior/Apto',
                      text: isEntrega
                          ? mandado.destino.apto ?? "No indicado"
                          : mandado.origen.apto ?? "No indicado",
                      noInicado: isEntrega
                          ? mandado.destino.apto == null ? true : false
                          : mandado.origen.apto == null ? true : false),

                  ///Info adicional
                  TituloSubTitulo(
                      title: 'Información adicional',
                      text: isEntrega
                          ? mandado.destino.notas ?? "Sin información adicional"
                          : mandado.origen.notas ?? "Sin información adicional",
                      noInicado: isEntrega
                          ? mandado.destino.notas == null ? true : false
                          : mandado.origen.notas == null ? true : false),

                  Expanded(child: Container()),

                  ///BTN
                  SizedBox(
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              M2AnimatedContainer(
                height: successContainerIsHidden ? 0 : 50,
                backgroundColor: kGreenManda2Color.withOpacity(0.7),
                text: successContainerMessage ?? "",
              ),
              M2AnimatedContainer(
                height: failureContainerIsHidden ? 0 : 50,
                text: failureContainerMessage ?? "",
              )
            ],
          ),
        ],
      ),
    );
  }

  void _handleVerMapa() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Ver en Waze"),
            onPressed: () {
              if (isEntrega) {
                _launchURLDestino();
              } else {
                _launchURLOrigen();
              }
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Ver en Google Maps"),
            onPressed: () async {
              String url =
                  "https://www.google.com/maps/dir/?api=1&destination=${isEntrega ? destino.replaceAll("#", "No. ").replaceAll(" ", "+").replaceAll("á", "a").replaceAll("Á", "A").replaceAll("é", "e").replaceAll("É", "E").replaceAll("í", "i").replaceAll("Í", "I").replaceAll("ó", "o").replaceAll("Ó", "O").replaceAll("ú", "u").replaceAll("Ú", "U") : origen.replaceAll("#", "No. ").replaceAll(" ", "+").replaceAll("á", "a").replaceAll("Á", "A").replaceAll("é", "e").replaceAll("É", "E").replaceAll("í", "i").replaceAll("Í", "I").replaceAll("ó", "o").replaceAll("Ó", "O").replaceAll("ú", "u").replaceAll("Ú", "U")}&travelmode=driving";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                showBasicAlert(
                  context,
                  "Hubo un error.",
                  "Por favor, intenta más tarde",
                );
                print("NIGGA: $url");
                throw 'Could not launch $url';
              }
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Copiar dirección"),
            onPressed: () {
              print("PORTA PAPELES");
              if (isEntrega) {
                Clipboard.setData(ClipboardData(text: destino)).then((r) {
                  print("DIRECCIÓN COPIADA");
                  setState(() {
                    failureContainerIsHidden = true;
                    successContainerIsHidden = false;
                    successContainerMessage = "Copiado en portapapeles";
                  });
                  Future.delayed(Duration(seconds: 3)).then((r) {
                    setState(() {
                      failureContainerIsHidden = true;
                      successContainerIsHidden = true;
                    });
                  });
                }).catchError((e) {
                  print("ERROR AL COPIAR DIRECCIÓN: $e");
                  setState(() {
                    successContainerIsHidden = true;
                    failureContainerIsHidden = false;
                    failureContainerMessage = "Error al copiar dirección";
                  });
                  Future.delayed(Duration(seconds: 3)).then((r) {
                    setState(() {
                      successContainerIsHidden = true;
                      failureContainerIsHidden = true;
                    });
                  });
                });
              } else {
                Clipboard.setData(ClipboardData(text: origen)).then((r) {
                  print("DIRECCIÓN COPIADA");
                  setState(() {
                    failureContainerIsHidden = true;
                    successContainerIsHidden = false;
                    successContainerMessage = "Copiado en portapapeles";
                  });
                  Future.delayed(Duration(seconds: 3)).then((r) {
                    setState(() {
                      failureContainerIsHidden = true;
                      successContainerIsHidden = true;
                    });
                  });
                }).catchError((e) {
                  print("ERROR AL COPIAR DIRECCIÓN: $e");
                  setState(() {
                    successContainerIsHidden = true;
                    failureContainerIsHidden = false;
                    failureContainerMessage = "Error al copiar dirección";
                  });
                  Future.delayed(Duration(seconds: 3)).then((r) {
                    setState(() {
                      successContainerIsHidden = true;
                      failureContainerIsHidden = true;
                    });
                  });
                });
              }
              Navigator.pop(context);
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

  ///Obtiene la ubicación del usuario
  void obtenerUbicacion() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitudInicial = (position.latitude);
    longitudInicial = (position.longitude);
  }

  ///Reemplaza los espacios del destino que el usuario proporciona por %20
  void convertirUbicacionDestino() async {
    setState(() {
      destinoSinEspacios = destino.replaceAll(" ", "%20");
    });
  }

  ///Inicia waze con los datos obtenidos por covertirUbicacion y obtenerUbicacion
  _launchURLDestino() async {
    String url =
        'https://waze.com/ul?q=$destinoSinEspacios&ll=$latitudInicial,$longitudInicial';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ///Reemplaza los espacios del destino que el usuario proporciona por %20
  void convertirUbicacionOrigen() async {
    setState(() {
      origenSinEspacios = origen.replaceAll(" ", "%20");
    });
  }

  ///Inicia waze con los datos obtenidos por covertirUbicacion y obtenerUbicacion
  _launchURLOrigen() async {
    String url =
        'https://waze.com/ul?q=$origenSinEspacios&ll=$latitudInicial,$longitudInicial';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
