import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_button.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/view_controllers/Home/Home.dart';

class MandadoEntregado extends StatefulWidget {
  @override
  _MandadoEntregadoState createState() => _MandadoEntregadoState();
}

class _MandadoEntregadoState extends State<MandadoEntregado> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: kBlackColor,
        body: CatapultaScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Image(
                    image: AssetImage('images/exito.png'),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.04,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      '¡Mandado entregado con éxito!',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: kWhiteColor,
                              fontWeight: FontWeight.w400)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.04,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      'Has realizado exitosamente un mandado.',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 13,
                          color: kBlackColorOpacity,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.03),
                child: M2Button(
                  title: "Aceptar",
                  backgroundColor: kGreenManda2Color,
                  shadowColor: kGreenManda2Color.withOpacity(0.4),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
