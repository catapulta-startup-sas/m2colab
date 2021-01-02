import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class EstadoMandado extends StatelessWidget {
  EstadoMandado(
      {@required this.contactoName,
      @required this.origen,
      this.imageRoute,
      @required this.estado,
      this.color,
      this.onTap,
      this.identificador,
      this.referencia,
      this.relevantDateTimeMSE,
      this.showsProgress,
      this.destino,
      this.fecha,
      this.vencidoOentregado,
      this.created,
      this.createdColor});
  final String contactoName;
  final String origen;
  final String destino;
  final String imageRoute;
  final String estado;
  final String fecha;
  final String identificador;
  final String referencia;
  final String created;
  final Color createdColor;
  final bool showsProgress;
  final int relevantDateTimeMSE;
  final Color color;
  final Function onTap;
  final bool vencidoOentregado;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(17, 20, 17, 0),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            width: MediaQuery.of(context).size.width - 34,
            decoration: BoxDecoration(
              color: kColorDeFondo,
              borderRadius: kRadiusAll,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ///Contacto
                Row(
                  children: <Widget>[
                    Text(
                      contactoName,
                      style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(fontSize: 14, color: kWhiteColor)),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        "Detalles",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: kGreenManda2Color)),
                      ),
                      onPressed: onTap,
                    ),
                  ],
                ),

                ///Direcciones
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 30,
                            child: Text(
                              'De:',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: kWhiteColor),
                              ),
                            ),
                          ),
                          Text(
                            '$origen',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: kWhiteColor.withOpacity(0.5)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 30,
                            child: Text(
                              'A:',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: kWhiteColor),
                              ),
                            ),
                          ),
                          Text(
                            '$destino',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: kWhiteColor.withOpacity(0.5)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                ///hace cuanto e icono
                Row(
                  children: <Widget>[
                    Text(
                      created,
                      style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(fontSize: 14, color: createdColor ?? kWhiteColor, fontWeight: FontWeight.w300)),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Image.asset(imageRoute, height: 27)
                  ],
                ),

                ///Fecha
                !vencidoOentregado
                    ? Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 2),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Fecha límite',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: kBlackColorOpacity)),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              height: 19,
                              child: Text(
                                fecha,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: kBlackColorOpacity)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(height: 7),

                ///identificador
                !vencidoOentregado
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 14),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Identificador',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: kBlackColorOpacity)),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              height: 19,
                              child: Text(
                                identificador,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: kBlackColorOpacity)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(height: 7),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
