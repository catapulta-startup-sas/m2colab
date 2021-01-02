import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_button.dart';
import 'package:manda2domis/components/m2_text_field_iniciar_sesion.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/firebase/authentication.dart';
import 'package:manda2domis/firebase/handles/sign_up_handle.dart';
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:manda2domis/model/estadistica_domi_model.dart';
import 'package:manda2domis/view_controllers/Home/Home.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';
import 'package:manda2domis/view_controllers/Terminos_y_condiciones/terminos_y_condiciones.dart';

class CrearCuenta extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => CrearCuenta(),
    );
  }

  @override
  _CrearCuentaState createState() => _CrearCuentaState();
}

class _CrearCuentaState extends State<CrearCuenta> {
  String name;
  String phoneNumber;
  String email;
  String password;

  Color nameIconColor = kWhiteColor;
  Color numberIconColor = kWhiteColor;
  Color emailIconColor = kWhiteColor;
  Color passwordIconColor = kWhiteColor;

  Color buttonBackgroundColor = kBlackColorOpacity;
  RegExp emailRegExp = RegExp("[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+");

  bool isLoadingBtn = false;

  TapGestureRecognizer _gestureRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    _gestureRecognizer.onTap = () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => DocumentacionLegal(),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kColorDeFondo,
      appBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'images/atras.png',
            color: kWhiteColor,
            width: 25,
          ),
        ),
        middle: Text(" "),
        border: Border.all(color: kTransparent),
        backgroundColor: kColorDeFondo,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: LayoutBuilder(
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
                        Text(
                          'Crear cuenta',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: kTituloInicioSesion),
                        ),
                        Expanded(flex: 2, child: Container()),
                        M2TextFielIniciarSesion(
                          text: 'Nombre completo',
                          imageRoute: 'images/user.png',
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          iconColor: nameIconColor,
                          onChanged: (text) {
                            setState(() {
                              name = text;
                              if (name == '') {
                                nameIconColor = kWhiteColor;
                              } else {
                                nameIconColor = kGreenManda2Color;
                              }
                            });
                          },
                        ),
                        Expanded(child: Container()),
                        M2TextFielIniciarSesion(
                          text: 'Celular',
                          imageRoute: 'images/celular.png',
                          keyboardType: TextInputType.number,
                          iconColor: numberIconColor,
                          onChanged: (text) {
                            setState(() {
                              phoneNumber = text;
                              if (phoneNumber == '') {
                                numberIconColor = kWhiteColor;
                              } else {
                                numberIconColor = kGreenManda2Color;
                              }
                            });
                          },
                        ),
                        Expanded(child: Container()),
                        M2TextFielIniciarSesion(
                          text: 'E-mail',
                          imageRoute: 'images/mail.png',
                          keyboardType: TextInputType.emailAddress,
                          iconColor: emailIconColor,
                          onChanged: (text) {
                            setState(() {
                              email = text;
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
                        Expanded(child: Container()),
                        M2TextFielIniciarSesion(
                          text: 'Contraseña',
                          imageRoute: 'images/password.png',
                          isPassword: true,
                          keyboardType: TextInputType.text,
                          iconColor: passwordIconColor,
                          onChanged: (text) {
                            setState(() {
                              password = text;
                              if (password == '') {
                                passwordIconColor = kWhiteColor;
                              } else {
                                passwordIconColor = kGreenManda2Color;
                              }
                            });
                          },
                        ),
                        Expanded(flex: 4, child: Container()),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: kBlackColorOpacity,
                                ),
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'Al continuar, declaras que conoces y aceptas los ',
                                ),
                                TextSpan(
                                  text: 'Términos y Condiciones ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: kGreenManda2Color,
                                  ),
                                  recognizer: _gestureRecognizer,
                                ),
                                TextSpan(
                                  text: 'y las ',
                                ),
                                TextSpan(
                                  text: 'Políticas de Privacidad.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: kGreenManda2Color,
                                  ),
                                  recognizer: _gestureRecognizer,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.020,
                        ),
                        M2Button(
                          title: "Crear cuenta",
                          isLoading: isLoadingBtn,
                          onPressed: () {
                            if (name == null || name == "") {
                              //Alerta email
                              showBasicAlert(
                                  context, "Por favor, ingresa tu nombre.", "");
                            } else {
                              if (phoneNumber == null || phoneNumber == "") {
                                //Alerta password
                                showBasicAlert(
                                    context,
                                    "Por favor, ingresa tu número de teléfono.",
                                    "");
                              } else if (email == null || email == "") {
                                //Alerta email
                                showBasicAlert(context,
                                    "Por favor, ingresa tu email.", "");
                              } else if (password == null || password == "") {
                                //Alerta email
                                showBasicAlert(context,
                                    "Por favor, ingresa tu contraseña.", "");
                              } else if (emailRegExp.hasMatch(email)) {
                                registerUser();
                              } else {
                                showBasicAlert(context, "E-mail incorrecto",
                                    "Por favor, ingresa un e-mail correcto.");
                              }
                            }
                          },
                          backgroundColor:
                              emailIconColor == kGreenManda2Color &&
                                      nameIconColor == kGreenManda2Color &&
                                      numberIconColor == kGreenManda2Color &&
                                      passwordIconColor == kGreenManda2Color
                                  ? buttonBackgroundColor = kGreenManda2Color
                                  : buttonBackgroundColor = kBlackColorOpacity,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.020,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.width * 0.89,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              FittedBox(
                                child: Text(
                                  '¿Ya tienes una cuenta?',
                                  style:
                                      GoogleFonts.poppins(textStyle: kNoCuenta),
                                ),
                              ),
                              Expanded(child: Container()),
                              GestureDetector(
                                child: FittedBox(
                                  child: Text(
                                    'Iniciar sesión',
                                    style: GoogleFonts.poppins(
                                        textStyle: kInicioSesion),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(
                                    context,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void registerUser() {
    setState(() {
      isLoadingBtn = true;
    });

    print("⏳ REGISTRARÉ USER");

    Auth().signUp(email, password).then((userId) async {
      Map<String, dynamic> userMap = {
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "roles": {
          "isAdmin": false,
          "isDomi": false,
          "estadoRegistroDomi": 0,
        },
        "creditCards": {
          "creditCardA": null,
          "creditCardB": null,
          "creditCardC": null,
        },
        "direcciones": FieldValue.arrayUnion([]),
        "dispositivos": FieldValue.arrayUnion([]),
        "favoriteCreditCard": null,
        "fotoPerfilURL":
            "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png",
        "hasReviewedBuyers": false,
        "numEnvios": 0,
        "numTarjetas": 0,
        "numDirecciones": 0,
        "numSolicitudes": 0,
        "numTomados": 0,
        "payCount": 0,
        "categorias": [
          {
            "emoji": "📦",
            "title": "Paquetes",
            "numMandados": 0,
            "isHidden": false,
          },
          {
            "emoji": "✉️",
            "title": "Mensajería",
            "numMandados": 0,
            "isHidden": false,
          }
        ]
      };

      FirebaseUser firebaseUser = await Auth().getCurrentUser();
      Firestore.instance
          .collection("users")
          .document(userId)
          .setData(userMap)
          .then((r) {
        Firestore.instance
            .document("users/${firebaseUser?.uid}")
            .get()
            .then((userDoc) {
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
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => Home(
                  isDomi: false,
                  docsSent: 0,
                ),
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
        }).catchError((e) {
          print("💩 ERROR AL OBTENER DOMI: $e");
        });

        print("✔️️ USER REGISTRADO");
      });
    }).catchError((e) {
      print("💩️ ERROR AL REGISTRARSE: $e");
      if (e is PlatformException) {
        handleSignUpError(context, e.code);
      }
      setState(() {
        isLoadingBtn = false;
      });
    });
  }
}
