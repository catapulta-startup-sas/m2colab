import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_container_configuracion.dart';
import 'package:manda2domis/firebase/authentication.dart';
import 'package:manda2domis/firebase/handles/delete_user_handle.dart';
import 'package:manda2domis/firebase/handles/reset_password_handle.dart';
import 'package:manda2domis/firebase/handles/sign_out_handle.dart';
import 'package:manda2domis/firebase/start_databases/get_constantes.dart';
import 'package:manda2domis/functions/launch_whatsapp.dart';
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:manda2domis/model/domiciliario_model.dart';
import 'package:manda2domis/model/user_model.dart';
import 'package:manda2domis/view_controllers/perfil/configuracion/reportar.dart';
import 'package:manda2domis/view_controllers/registro/iniciar_sesion/iniciar_sesion.dart';
import 'package:manda2domis/view_controllers/Terminos_y_condiciones/terminos_y_condiciones.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';
import '../../../constants.dart';

class Soporte extends StatefulWidget {
  @override
  _SoporteState createState() => _SoporteState();
}

class _SoporteState extends State<Soporte> {
  bool isChangingPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBlackColor,
        appBar: CupertinoNavigationBar(
          backgroundColor: kBlackColor,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'images/atras.png',
                color: kWhiteColor,
                width: 25,
              )),          border: Border(
            bottom: BorderSide(
              color: kBlackColor,
              width: 1.0, // One physical pixel.
              style: BorderStyle.solid,
            ),
          ),
          middle: Text(
            "Soporte",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 17,
                  color: kWhiteColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        body: CatapultaScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                ContainerConfiguracion(
                  text: 'Reportar un problema',
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Reportar(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ContainerConfiguracion(
                  text: 'Escribir a soporte',
                  onTap: () {
                    _alertContactSoporte();
                  },
                ),
              ],
            ),
          ),
        ));
  }






  void _alertContactSoporte() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text("Serás redirigido a un chat de WhatsApp"),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Abrir en WhatsApp"),
            isDestructiveAction: false,
            onPressed: () {
              launchWhatsApp(context, "$contactoSoporte".replaceAll("+", ""));
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Volver"),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

}
