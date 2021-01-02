import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:manda2domis/firebase/authentication.dart';
import 'package:manda2domis/firebase/handles/sign_in_handle.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/m2_button.dart';
import 'package:manda2domis/components/m2_text_field_iniciar_sesion.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:manda2domis/model/estadistica_domi_model.dart';
import 'package:manda2domis/view_controllers/banned_page.dart';
import 'package:manda2domis/view_controllers/registro/Recuperar_Contrasena/olvide_contrasena_page.dart';
import 'package:manda2domis/view_controllers/registro/crear_cuenta/crear_cuenta.dart';
import 'package:manda2domis/view_controllers/Home/Home.dart';

class IniciarSesion extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => IniciarSesion(),
    );
  }

  @override
  _IniciarSesionState createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  String email;
  String password;
  Color buttonBackgroundColor = kBlackColorOpacity;

  RegExp emailRegExp = RegExp("[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+");
  Color emailIconColor = kWhiteColor;
  Color passwordIconColor = kWhiteColor;

  bool isLoadingBtn = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: kColorDeFondo,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                color: kFondo,
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Container(
                          color: kColorDeFondo,
                          child: Column(
                            children: <Widget>[
                              Stack(
                                alignment: Alignment.bottomLeft,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.asset(
                                        "images/iniciarSesionDomiciliarios.png"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(17, 0, 0, 6),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 20,
                                          child: FittedBox(
                                            child: Text(
                                              'Bienvenido a',
                                              style: GoogleFonts.poppins(
                                                  textStyle:
                                                      ksubtituloInicioSesion),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 44,
                                          child: FittedBox(
                                            child: Text(
                                              'Manda2',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                  textStyle:
                                                      kTituloInicioSesion),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              M2TextFielIniciarSesion(
                                text: 'E-mail',
                                imageRoute: 'images/mail.png',
                                iconColor: emailIconColor,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (text) {
                                  setState(() {
                                    email = text;

                                    if (email != "" &&
                                        email != null &&
                                        password != "" &&
                                        password != null &&
                                        emailRegExp.hasMatch(email)) {
                                      buttonBackgroundColor = kGreenManda2Color;
                                    } else {
                                      buttonBackgroundColor =
                                          kBlackColorOpacity;
                                    }
                                    if (emailRegExp.hasMatch(text)) {
                                      emailIconColor = kGreenManda2Color;
                                    } else if (email == '') {
                                      emailIconColor = kWhiteColor;
                                    } else {
                                      emailIconColor = kRedColor;
                                    }
                                  });
                                },
                              ),
                              SizedBox(height: 40),
                              M2TextFielIniciarSesion(
                                text: 'Contraseña',
                                imageRoute: 'images/password.png',
                                isPassword: true,
                                keyboardType: TextInputType.text,
                                onChanged: (text) {
                                  setState(() {
                                    password = text;
                                    if (password == '') {
                                      passwordIconColor = kWhiteColor;
                                    } else {
                                      passwordIconColor = kGreenManda2Color;
                                    }
                                    if (email != "" &&
                                        email != null &&
                                        password != "" &&
                                        password != null &&
                                        emailRegExp.hasMatch(email)) {
                                      buttonBackgroundColor = kGreenManda2Color;
                                    } else {
                                      buttonBackgroundColor =
                                          kBlackColorOpacity;
                                    }
                                  });
                                },
                                iconColor: passwordIconColor,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                height: 20,
                                width: MediaQuery.of(context).size.width - 34,
                                child: Stack(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Container(
                                            height: 20,
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    34) *
                                                0.4,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: FittedBox(
                                                child: Text(
                                                  'Crear cuenta',
                                                  style: GoogleFonts.poppins(
                                                      textStyle: kCrearCuenta),
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    CrearCuenta(),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Container(
                                            height: 20,
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    34) *
                                                0.6,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: FittedBox(
                                                child: Text(
                                                  '¿Olvidaste tu contraseña?',
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          kOlvidoInicioSesion),
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    OlvidePassword(),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              M2Button(
                                title: "Iniciar sesión",
                                isLoading: isLoadingBtn,
                                onPressed: () {
                                  if (email == null || email == "") {
                                    showBasicAlert(context,
                                        "Por favor, ingresa tu email.", "");
                                  } else {
                                    if (password == null || password == "") {
                                      showBasicAlert(
                                          context,
                                          "Por favor, ingresa tu contraseña.",
                                          "");
                                    } else if (emailRegExp.hasMatch(email)) {
                                      loginUser();
                                    } else {
                                      showBasicAlert(
                                          context,
                                          "E-mail incorrecto",
                                          "Por favor, ingresa un e-mail correcto.");
                                    }
                                  }
                                },
                                backgroundColor: buttonBackgroundColor,
                              ),
                              SizedBox(height: 48),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginUser() {
    print("⏳ INICIARÉ SESIÓN");
    setState(() {
      isLoadingBtn = true;
    });

    Auth().signIn(email, password).then((firebaseUser) async {
      Firestore.instance
          .document("users/${firebaseUser?.uid}")
          .get()
          .then((userDoc) {
        if (userDoc.data["roles"]["isBloqueado"] == true) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => BannedPage(),
            ),
          );
        } else {
          if (!userDoc.data["roles"]["isDomi"]) {
            // No ha enviado documentos para ser domi
            domi.user.objectId = userDoc.documentID;
            domi.user.name = userDoc.data["name"];
            domi.hasReviewedDomis = userDoc.data['hasReviewedDomis'];
            domi.user.email = userDoc.data['email'];
            domi.user.phoneNumber = userDoc.data['phoneNumber'];
            domi.user.fotoPerfilURL = userDoc.data['fotoPerfilURL'];
            domi.user.isDomi = userDoc.data["roles"]["isDomi"];
            domi.user.docsSent = userDoc.data["roles"]["estadoRegistroDomi"];
            domi.user.numTomados = userDoc.data['numTomados'];
            domi.user.dispositivos = userDoc.data['dispositivos'] ?? [];
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => Home(
                    isDomi: false,
                    docsSent: userDoc.data["roles"]["estadoRegistroDomi"]),
              ),
            );
            setState(() {
              isLoadingBtn = false;
            });
          } else {
            Firestore.instance
                .document("domiciliarios/${firebaseUser?.uid}")
                .get()
                .then((domiDoc) {
              // Documentos para ser domi fueron enviados
              domi.user.objectId = userDoc.documentID;
              domi.user.name = userDoc.data["name"];
              domi.hasReviewedDomis = userDoc.data['hasReviewedDomis'];
              domi.user.email = userDoc.data['email'];
              domi.user.phoneNumber = userDoc.data['phoneNumber'];
              domi.user.fotoPerfilURL = userDoc.data['fotoPerfilURL'];
              domi.user.dispositivos = userDoc.data['dispositivos'] ?? [];
              // Sólo domis ·······················
              domi.cantidadCalificaciones =
                  domiDoc.data["calificaciones"]['cantidad'];
              domi.califPromedio =
                  domiDoc.data["calificaciones"]['promedio'].toDouble();
              domi.vehiculo = domiDoc.data['vehiculo'];
              domi.dniType = domiDoc.data["dni"]['tipo'];
              domi.dniNumber = domiDoc.data["dni"]['numero'];
              domi.banco = domiDoc.data["cuentaBancaria"]['banco'];
              domi.tipoCuentaBancaria = domiDoc.data["cuentaBancaria"]['tipo'];
              domi.numeroCuentaBancaria =
                  domiDoc.data["cuentaBancaria"]['numero'];
              domi.user.isDomi = userDoc.data["roles"]["isDomi"];
              domi.user.docsSent = userDoc.data["roles"]["estadoRegistroDomi"];
              domi.user.numTomados = userDoc.data['numTomados'];
              domi.estadisticaParcial = EstadisticaDomi();

              domi.estadisticaParcial.mandados =
                  domiDoc.data["estadisticaParcial"]["mandados"] ?? 0;
              domi.estadisticaParcial.envios =
                  domiDoc.data["estadisticaParcial"]["envios"] ?? 0;
              domi.estadisticaParcial.tarjeta =
                  domiDoc.data["estadisticaParcial"]["tarjeta"].toDouble() ?? 0;
              domi.estadisticaParcial.efectivo =
                  domiDoc.data["estadisticaParcial"]["efectivo"].toDouble();
              domi.estadisticaTotal = EstadisticaDomi();

              domi.estadisticaTotal.mandados =
                  domiDoc.data["estadisticaTotal"]["mandados"] ?? 0;
              domi.estadisticaTotal.envios =
                  domiDoc.data["estadisticaTotal"]["envios"] ?? 0;
              domi.estadisticaTotal.tarjeta =
                  domiDoc.data["estadisticaTotal"]["tarjeta"].toDouble() ?? 0;
              domi.estadisticaTotal.efectivo =
                  domiDoc.data["estadisticaTotal"]["efectivo"].toDouble();
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Home(
                    isDomi: userDoc.data["roles"]["isDomi"],
                    docsSent: userDoc.data["roles"]["estadoRegistroDomi"],
                  ),
                ),
              );
              setState(() {
                isLoadingBtn = false;
              });
            });
          }
          print("✔️ DOMI DESCARGADO");
        }
      }).catchError((e) {
        print("💩 ERROR AL OBTENER DOMI: $e");
      });
      print("✔️ SESIÓN INICIADA");
    }).catchError((e) {
      print("💩️ ERROR AL INICIAR SESIÓN: $e");
      if (e is PlatformException) {
        handleSignInError(context, e.code);
      }
      setState(() {
        isLoadingBtn = false;
      });
    });
  }
}
