import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import 'm2_button_historial.dart';

class ContainerHistorial extends StatefulWidget {
  ContainerHistorial({
    this.fechaMaxEntrega,
    this.hora,
    this.dirA,
    this.dirB,
    this.estado,
    this.onPressed,
  });

  DateTime fechaMaxEntrega;
  String hora;
  String dirA;
  String dirB;
  String estado;
  Function onPressed;

  @override
  _ContainerHistorialState createState() => _ContainerHistorialState(
      fechaMaxEntrega: fechaMaxEntrega,
      hora: hora,
      dirA: dirA,
      dirB: dirB,
      estado: estado,
      onPressed: onPressed);
}

class _ContainerHistorialState extends State<ContainerHistorial> {
  _ContainerHistorialState({
    this.fechaMaxEntrega,
    this.hora,
    this.dirA,
    this.dirB,
    this.estado,
    this.onPressed,
  });

  DateTime fechaMaxEntrega;
  String fecha;

  String hora;
  String dirA;
  String dirB;
  String estado;
  Function onPressed;
  bool isLoading;

  @override
  void initState() {
    fecha = "${DateFormat.yMMMEd('es').format(fechaMaxEntrega)}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(17, 0, 17, 17),
      child: Container(
        height: 260,
        width: MediaQuery.of(context).size.width - 34,
        decoration: BoxDecoration(borderRadius: kRadiusAll, color: kBlackColor),
        child: Column(
          children: <Widget>[
            /// Fecha limite
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 20,
                    width: 90,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          'Fecha límite',
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
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        child: Text(
                          fecha,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: kGreenManda2Color, fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Hora limite
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 20,
                    width: 60,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          'Hora límite',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: kBlackColorOpacity, fontSize: 10)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        child: Text(
                          hora,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: kGreenManda2Color, fontSize: 10)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            /// Direccion A
            Padding(
              padding: EdgeInsets.fromLTRB(17, 15, 17, 0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 25,
                    width: 25,
                    child: Image(
                      image: AssetImage('images/A.png'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          dirA,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 13,
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.w300)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 17),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 25,
                  width: 25,
                  child: Icon(
                    Icons.more_vert,
                    color: kBlackColorOpacity,
                  ),
                ),
              ),
            ),

            /// Direccion B
            Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 25,
                    width: 25,
                    child: Image(
                      image: AssetImage('images/B.png'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          dirB,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 13,
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.w300)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            /// Estado y Boton
            Padding(
              padding: EdgeInsets.fromLTRB(17, 28, 17, 0),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 15,
                        width: 34,
                        child: FittedBox(
                          child: Text(
                            'Estado',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: kBlackColorOpacity, fontSize: 10)),
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 59,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            child: Text(
                              estado,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: kGreenManda2Color, fontSize: 14)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  M2ButtonHistorial(
                    width: MediaQuery.of(context).size.width * 0.5,
                    title: 'Detalles',
                    onPressed: onPressed,
                    isLoading: isLoading,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
