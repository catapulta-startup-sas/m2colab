import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/constants.dart';

class ContainerCalificacion extends StatelessWidget {
  ContainerCalificacion(
      {this.calificacion, this.nombre, this.comentario, this.creacion});
  String nombre;
  String creacion;
  int calificacion;
  String comentario;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBlackColor,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10  ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(nombre,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: kWhiteColor,
                        fontSize: 14,
                    )
                ),),
                Expanded(child: Container()),
                Text(creacion,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: kWhiteColor.withOpacity(0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w300
                        )
                    ))
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Image.asset(
                  'images/estrella.png',
                  color:
                      calificacion < 1 ? kBlackColorOpacity : kGreenManda2Color,
                  height: 14,
                ),
                SizedBox(width: 6),
                Image.asset(
                  'images/estrella.png',
                  color:
                      calificacion < 2 ? kBlackColorOpacity : kGreenManda2Color,
                  height: 14,
                ),
                SizedBox(width: 6),

                Image.asset(
                  'images/estrella.png',
                  color:
                      calificacion < 3 ? kBlackColorOpacity : kGreenManda2Color,
                  height: 14,
                ),
                SizedBox(width: 6),

                Image.asset(
                  'images/estrella.png',
                  color:
                      calificacion < 4 ? kBlackColorOpacity : kGreenManda2Color,
                  height: 14,
                ),
                SizedBox(width: 6),

                Image.asset(
                  'images/estrella.png',
                  color:
                      calificacion < 5 ? kBlackColorOpacity : kGreenManda2Color,
                  height: 14,
                ),
              ],
            ),
            SizedBox(height: 5),

            comentario == null || comentario == ''
                ? Container()
                : Text(comentario,
            textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: kWhiteColor.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w300
                    )
                ))
          ],
        ),
      ),
    );
  }
}
