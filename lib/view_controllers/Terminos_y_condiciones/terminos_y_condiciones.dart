import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import '../../constants.dart';

class DocumentacionLegal extends StatefulWidget {
  @override
  _DocumentacionLegalState createState() => _DocumentacionLegalState();
}

class _DocumentacionLegalState extends State<DocumentacionLegal> {
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
          border: Border.all(color: kBlackColor),
          middle: Container(
            child: Text(
              "Documentación legal",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 17,
                  color: kWhiteColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        body: CatapultaScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    top: 30),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        tyc,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: kWhiteColor,
                          ),
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
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
