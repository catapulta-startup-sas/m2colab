import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../constants.dart';

class ContainerDetalle extends StatelessWidget {
  ContainerDetalle({this.dirA, this.dirB, this.nombre, this.fotoPerfilURL});
  String nombre;
  String fotoPerfilURL;
  String dirA;
  String dirB;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
      child: Container(
        padding: EdgeInsets.fromLTRB(4, 20, 0, 20),
        width: MediaQuery.of(context).size.width - 34,
        decoration: BoxDecoration(borderRadius: kRadiusAll, color: kBlackColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 19, top: 7),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kTransparent),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Color(0x15D1D1D1),
                      highlightColor: Color(0x01D1D1D1),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: kTransparent),
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.lightBlue[100],
                        ),
                        height: 77,
                        width: 74,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Image(
                            image: NetworkImage(fotoPerfilURL),
                          ),
                        ),
                      ),
                    ),
                    height: 77,
                    width: 74,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kTransparent),
                      borderRadius: BorderRadius.circular(9),
                      image: DecorationImage(
                        image: NetworkImage(fotoPerfilURL),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 77,
                    width: 74,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ///Nombre
                Padding(
                  padding: EdgeInsets.only(left: 17, bottom: 10),
                  child: Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      nombre,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 14, color: kBlackColorOpacity)),
                    ),
                  ),
                ),

                /// Direccion A
                Padding(
                  padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 20,
                        width: 25,
                        child: Image(
                          image: AssetImage('images/A.png'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          dirA,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 13,
                              color: kWhiteColor,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 17),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                ),

                /// Direccion B
                Padding(
                  padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 20,
                        width: 25,
                        child: Image(
                          image: AssetImage('images/B.png'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          dirB,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 13,
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.w300)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
