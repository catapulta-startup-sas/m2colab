import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manda2domis/functions/formato_fecha.dart';

import '../constants.dart';
import 'm2_button_historial.dart';

class ContainerLista extends StatefulWidget {
  ContainerLista(
      {this.fechaMaxEntrega,
      this.origen,
      this.destino,
      this.onTap,
      this.nombre,
      this.fechaPedido});

  DateTime fechaMaxEntrega;
  DateTime fechaPedido;

  String origen;
  String destino;
  Function onTap;
  String nombre;

  @override
  _ContainerListaState createState() => _ContainerListaState(
        fechaMaxEntrega: fechaMaxEntrega,
        origen: origen,
        destino: destino,
        onTap: onTap,
        nombre: nombre,
        fechaPedido: fechaPedido,
      );
}

class _ContainerListaState extends State<ContainerLista> {
  _ContainerListaState({
    this.fechaMaxEntrega,
    this.origen,
    this.destino,
    this.onTap,
    this.nombre,
    this.fechaPedido,
  });

  DateTime fechaMaxEntrega;
  DateTime fechaPedido;

  String fecha;
  String origen;
  String destino;
  Function onTap;
  String nombre;

  @override
  void initState() {
    fecha = dateFormattedFromDateTime(fechaMaxEntrega);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: kColorDeFondo,
          child: Column(
            children: <Widget>[
              /// Nombre
              Padding(
                padding: EdgeInsets.fromLTRB(13, 5, 13, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "$nombre",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: kWhiteColor,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      '${dateFormattedFromDateTime(fechaPedido)}',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: kWhiteColor.withOpacity(0.5),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Origen
                      Padding(
                        padding: EdgeInsets.fromLTRB(13, 10, 13, 0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              child: Text(
                                'De:',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        color: kWhiteColor,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            Text(
                              origen,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 12,
                                      color: kWhiteColor.withOpacity(0.5),
                                      fontWeight: FontWeight.w300)),
                            )
                          ],
                        ),
                      ),

                      /// Destino
                      Padding(
                        padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              child: Text(
                                'A:  ',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        color: kWhiteColor,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            Text(
                              destino,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 12,
                                      color: kWhiteColor.withOpacity(0.5),
                                      fontWeight: FontWeight.w300)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  Image.asset(
                    'images/adelante.png',
                    height: 8,
                    color: kWhiteColor,
                  ),
                  SizedBox(width: 13)
                ],
              ),

              /// Fecha limite
              Padding(
                padding: EdgeInsets.fromLTRB(13, 10, 13, 4),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Fecha límite',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: kBlackColorOpacity,
                              fontSize: 12,
                              fontWeight: FontWeight.w300)),
                    ),
                    SizedBox(width: 20),
                    Text(
                      fecha,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: kWhiteColor.withOpacity(0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w300)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
