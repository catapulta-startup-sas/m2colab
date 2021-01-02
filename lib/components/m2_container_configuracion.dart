import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class ContainerConfiguracion extends StatelessWidget {
  ContainerConfiguracion({
    @required this.text,
    this.padding,
    this.onTap,
    this.width,
    this.image,
    this.isLoading,
  });

  String text;
  double padding;
  double width;
  Function onTap;
  String image;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading == null) isLoading = false;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          children: <Widget>[
            Container(
              width: 10,
              height: 50,
              color: kBlackColor,
            ),
            Container(
              width: 10,
              height: 50,
              color: kBlackColor,
            ),
            Container(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$text',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 13, color: kWhiteColor)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: kBlackColor,
              ),
            ),
            isLoading
                ? Container(
                    margin: EdgeInsets.only(right: 2),
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          kBlackColorOpacity.withOpacity(0.5)),
                      strokeWidth: 3,
                    ),
                  )
                : Image(
                    image: AssetImage('images/adelante.png'),
                    height: 15,
                    color: kBlackColorOpacity,
                  ),
            Container(
              width: 10,
              height: 50,
              color: kBlackColor,
            ),
          ],
        ),
      ),
    );
  }
}
