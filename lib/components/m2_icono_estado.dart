import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class IconoEstado extends StatelessWidget {
  IconoEstado(
      {this.text1, this.imageRoute, this.text2, this.onTap, this.color});
  String imageRoute;
  String text1;
  String text2;
  Function onTap;
  Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        color: kColorDeFondo,
        child: Column(
          children: [
            Container(
              height: 21,
              child: Image.asset(
                imageRoute,
                color: color ?? kWhiteColor,
              ),
            ),
            Text(
              text1,
              style: GoogleFonts.poppins(
                color: color ?? kWhiteColor,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              text2,
              style: GoogleFonts.poppins(
                color: color ?? kWhiteColor,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
      ),
    );
  }
}
