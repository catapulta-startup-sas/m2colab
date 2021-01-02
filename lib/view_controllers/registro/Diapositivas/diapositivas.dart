import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/view_controllers/registro/iniciar_sesion/iniciar_sesion.dart';
import 'package:manda2domis/components/diapositiva.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Diapositivas extends StatefulWidget {
  @override
  _DiapositivasState createState() => _DiapositivasState();
}

class _DiapositivasState extends State<Diapositivas> {
  String title1 = "Sé parte de la cultura";
  String title2 = "inclusiva, sostenible,";
  String title3 = "paciente y proactiva";
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Diapositiva(
        number: "0$page",
        width: MediaQuery.of(context).size.width,
        title1: title1,
        title2: title2,
        title3: title3,
        imageRoute: "images/diapositiva$page.png",
        onPressed: handleNextBtn,
      ),
    );
  }

  void handleNextBtn() {
    if (page == 1) {
      setState(() {
        page = 2;
        title1 = "Genera ganancias";
        title2 = "adicionales en tus";
        title3 = "tiempos libres";
      });
    } else if (page == 2) {
      setState(() {
        page = 3;
        title1 = "Sé un héroe:";
        title2 = "Ayuda a los demás a";
        title3 = "quedarse en casa";
      });
    } else if (page == 3) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => IniciarSesion(),
        ),
      );
      _updateIsFirstTime();
    }
  }

  void _updateIsFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFirstTime", false);
  }
}
