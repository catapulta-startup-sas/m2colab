import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_button.dart';
import 'package:manda2domis/view_controllers/Home/Home.dart';
import 'package:manda2domis/view_controllers/registro/iniciar_sesion/iniciar_sesion.dart';
import '../../constants.dart';

class Politicas extends StatefulWidget {
  @override
  _PoliticasState createState() => _PoliticasState();
}

class _PoliticasState extends State<Politicas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
        appBar: CupertinoNavigationBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'images/atras.png',
                color: kWhiteColor,
                width: 25,
              )),
            backgroundColor: kBlackColor,
          border: Border.all(color: kBlackColor)
        ),
        body: Container(
          color: kBlackColor,
          child: Column(
            children: <Widget>[
              Expanded(
                child: CatapultaScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.05, right: MediaQuery.of(context).size.width *0.05, top: 30),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Términos condiciones',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: kWhiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Text(
                            'MATT Manda2',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: kWhiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Políticas de tratamiento de datos personales',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: kWhiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            pp,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: kWhiteColor
                                )
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(17, 20, 17, 20),
                child: M2Button(
                  title: 'Continuar',
                  width: MediaQuery.of(context).size.width - 34,
                  backgroundColor: kGreenManda2Color,
                  onPressed: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        )
    );
  }
}