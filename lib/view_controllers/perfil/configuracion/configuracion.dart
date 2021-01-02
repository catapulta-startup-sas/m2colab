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
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:manda2domis/model/domiciliario_model.dart';
import 'package:manda2domis/model/user_model.dart';
import 'package:manda2domis/view_controllers/perfil/configuracion/reportar.dart';
import 'package:manda2domis/view_controllers/registro/iniciar_sesion/iniciar_sesion.dart';
import 'package:manda2domis/view_controllers/Terminos_y_condiciones/terminos_y_condiciones.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';
import '../../../constants.dart';

class Configuracion extends StatefulWidget {
  @override
  _ConfiguracionState createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
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
              )),           border: Border(
            bottom: BorderSide(
              color: kBlackColor,
              width: 1.0, // One physical pixel.
              style: BorderStyle.solid,
            ),
          ),
          middle: Text(
            "Configuración",
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
                  text: 'Cambiar contraseña',
                  isLoading: isChangingPassword,
                  onTap: () {
                    setState(() {
                      isChangingPassword = true;
                    });
                    print("⏳ ENVIARÉ EMAIL");
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(email: domi.user.email)
                        .then((r) {
                      print("✔️ EMAIL ENVIADO");
                      showBasicAlert(
                        context,
                        "Mensaje enviado",
                        "Hemos enviado un correo electrónico a ${domi.user.email} con un enlace para restablecer la contraseña.",
                      );
                      setState(() {
                        isChangingPassword = false;
                      });
                    }).catchError((e) {
                      print("💩 ERROR AL ENVIAR EMAIL: $e");
                      if (e is PlatformException) {
                        handleResetPasswordError(context, e.code);
                      }
                      setState(() {
                        isChangingPassword = false;
                      });
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),

                ContainerConfiguracion(
                  text: 'Documentación legal',
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => DocumentacionLegal(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ContainerConfiguracion(
                  text: 'Eliminar cuenta',
                  onTap: () {
                    showAlert(
                      context: context,
                      title: "¿Te vas? 😣",
                      body:
                          "¿Qué tal si primero nos dices cómo podríamos mejorar? Nos encantaría conocer tu opinión.",
                      actions: [
                        AlertAction(
                          text: "Eliminar cuenta",
                          isDestructiveAction: true,
                          onPressed: deleteUserBack,
                        ),
                        AlertAction(
                          text: "Mejoremos juntos",
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Reportar(),
                              ),
                            );
                          },
                        ),
                        AlertAction(
                          text: "Volver",
                          isDefaultAction: true,
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    _alertLogOut();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 20,
                          height: 50,
                          color: kBlackColor,
                        ),
                        Container(
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Cerrar sesión',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 13,
                                    color: kRedColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _alertLogOut() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text("¿Quieres cerrar sesión?"),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Cerrar sesión"),
            isDestructiveAction: true,
            onPressed: cerrarSesionBack,
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

  void deleteUserBack() async {
    print("⏳ ELIMINARÉ USER");
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    firebaseUser.delete().then((r) {
      print("✔️ USER ELIMINADO");
      print("⏳ ELIMINARÉ DATOS USER");
      Firestore.instance
          .document("users/${domi.user.objectId}")
          .delete()
          .then((r) {
        print("✔️ USER ELIMINADO");
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => IniciarSesion(),
          ),
        );
        domi = Domiciliario(user: User());
      }).catchError((e) {
        print("💩 ERROR AL ELIMINAR DATOS DE USER: $e");
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => IniciarSesion(),
          ),
        );
        domi = Domiciliario(user: User());
      });
    }).catchError((e) {
      print("💩 ERROR AL ELIMINAR USER: $e");
      handleDeleteUserError(e, context, cerrarSesionBack);
    });
  }

  void cerrarSesionBack() async {
    print("⏳ CERRARÉ SESIÓN");
    Auth().signOut().then((r) {
      print("✔️ SESIÓN CERRADA");
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => IniciarSesion(),
        ),
      );
      domi = Domiciliario(user: User());
    }).catchError((e) {
      print("💩️ ERROR AL CERRAR SESIÓN: $e");
      handleSignOutError(context);
    });
  }
}
