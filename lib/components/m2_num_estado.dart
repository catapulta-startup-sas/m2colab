import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

// ignore: must_be_immutable
class ContainerNum extends StatelessWidget {
  ContainerNum({
   @required this.num,this.color
});
  int num;
  Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 17),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: color ?? kGreenManda2Color,
          borderRadius: kRadiusMandado
        ),

        child: Center(
          child: Text(
            '$num',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 13,
                color: kWhiteColor,
                fontWeight: FontWeight.w600
              )
            ),
          ),
        ),
      ),
    );
  }
}
