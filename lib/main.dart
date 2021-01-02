import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/firebase/authentication.dart';
import 'package:manda2domis/firebase/start_databases/get_constantes.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';
import 'package:manda2domis/internet_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:manda2domis/model/estadistica_domi_model.dart';
import 'package:manda2domis/view_controllers/Home/Home.dart';
import 'package:manda2domis/view_controllers/actualizar_page.dart';
import 'package:manda2domis/view_controllers/banned_page.dart';
import 'package:manda2domis/view_controllers/perfil/mandados_tomados/madados_tomados.dart';
import 'package:manda2domis/view_controllers/perfil/perfil.dart';
import 'package:manda2domis/view_controllers/registro/Diapositivas/diapositivas.dart';
import 'package:manda2domis/view_controllers/registro/iniciar_sesion/iniciar_sesion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'functions/get_dispositivo_type.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = await prefs.getBool("isFirstTime") ?? true;

  InternetStatus status = new InternetStatus();
  status.checkCurrentConnection();

  getDispositivoType();

  Firestore.instance.document("constantes/doc1").snapshots().listen((doc) {
    contactoSoporte = doc.data["soporte"]["compradores"];

    if (dispositivo == Dispositivo.ios) {
      actualizacionNecesaria =
          doc.data["actualizacionNecesaria"]["viOS"]["domiciliarios"];
      vBack = doc.data["versiones"]["viOS"]["domiciliarios"];
      if (vLocal < vBack) {
        updateURL = doc.data["tiendasURLs"]["appstore"]["domiciliarios"];
        isUpdated = false;
      }
    } else if (dispositivo == Dispositivo.android) {
      actualizacionNecesaria =
          doc.data["actualizacionNecesaria"]["vAndroid"]["domiciliarios"];
      vBack = doc.data["versiones"]["vAndroid"]["domiciliarios"];
      if (vLocal < vBack) {
        updateURL = doc.data["tiendasURLs"]["playstore"]["domiciliarios"];
        isUpdated = false;
      }
    }

    isUpdated
        ? print("✔️ v$vLocal.0 INSTALADA")
        : print("⚠️ ACTUALIZA A v$vBack");

    actualizacionNecesaria && !isUpdated
        ? print("⚠️ NECESITA ACTUALIZAR")
        : print("✔️ VERSIÓN COMPATIBLE");

    if (actualizacionNecesaria && !isUpdated) {
      runApp(
        ChangeNotifierProvider<InternetStatus>(
          create: (context) => status,
          child: MaterialApp(
            theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: kGreenManda2Color,
            ),
            home: ActualizarPage(),
          ),
        ),
      );
    } else {
      Auth().getCurrentUser().then((firebaseUser) {
        if (firebaseUser != null) {
          Firestore.instance
              .document("users/${firebaseUser?.uid}")
              .get()
              .then((userDoc) {
            if (userDoc.data["roles"]["isBloqueado"] == true) {
              runApp(
                ChangeNotifierProvider<InternetStatus>(
                  create: (context) => status,
                  child: MaterialApp(
                    theme: ThemeData(
                      brightness: Brightness.dark,
                      primaryColor: kGreenManda2Color,
                    ),
                    debugShowCheckedModeBanner: false,
                    home: BannedPage(),
                  ),
                ),
              );
            } else {
              if (!userDoc.data["roles"]["isDomi"]) {
                // No es domi
                domi.user.objectId = userDoc.documentID;
                domi.user.name = userDoc.data["name"];
                domi.hasReviewedDomis = userDoc.data['hasReviewedDomis'];
                domi.user.email = userDoc.data['email'];
                domi.user.phoneNumber = userDoc.data['phoneNumber'];
                domi.user.fotoPerfilURL = userDoc.data['fotoPerfilURL'];
                domi.user.isDomi = userDoc.data["roles"]["isDomi"];
                domi.user.docsSent =
                    userDoc.data["roles"]["estadoRegistroDomi"];
                domi.user.numTomados = userDoc.data['numTomados'];
                domi.user.dispositivos = userDoc.data['dispositivos'] ?? [];
                runApp(
                  ChangeNotifierProvider<InternetStatus>(
                    create: (context) => status,
                    child: MaterialApp(
                      theme: ThemeData(
                        brightness: Brightness.dark,
                        primaryColor: kGreenManda2Color,
                      ),
                      debugShowCheckedModeBanner: false,
                      home: Home(
                        isDomi: false,
                        docsSent: userDoc.data["roles"]["estadoRegistroDomi"],
                      ),
                      routes: <String, WidgetBuilder>{
                        '/home': (BuildContext context) => Home(),
                        '/perfil': (BuildContext context) => Perfil(),
                        '/tomados': (BuildContext context) => MandadosTomados(),
                      },
                    ),
                  ),
                );
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
                  domi.tipoCuentaBancaria =
                      domiDoc.data["cuentaBancaria"]['tipo'];
                  domi.numeroCuentaBancaria =
                      domiDoc.data["cuentaBancaria"]['numero'];
                  domi.user.isDomi = userDoc.data["roles"]["isDomi"];
                  domi.user.docsSent =
                      userDoc.data["roles"]["estadoRegistroDomi"];
                  domi.user.numTomados = userDoc.data['numTomados'];
                  domi.estadisticaParcial = EstadisticaDomi();
                  domi.estadisticaParcial.mandados =
                      domiDoc.data["estadisticaParcial"]["mandados"] ?? 0;
                  domi.estadisticaParcial.envios =
                      domiDoc.data["estadisticaParcial"]["envios"] ?? 0;
                  domi.estadisticaParcial.tarjeta = domiDoc
                          .data["estadisticaParcial"]["tarjeta"]
                          .toDouble() ??
                      0;
                  domi.estadisticaParcial.efectivo = domiDoc
                          .data["estadisticaParcial"]["efectivo"]
                          .toDouble() ??
                      0;
                  domi.estadisticaTotal = EstadisticaDomi();
                  domi.estadisticaTotal.mandados =
                      domiDoc.data["estadisticaTotal"]["mandados"] ?? 0;
                  domi.estadisticaTotal.envios =
                      domiDoc.data["estadisticaTotal"]["envios"] ?? 0;
                  domi.estadisticaTotal.tarjeta =
                      domiDoc.data["estadisticaTotal"]["tarjeta"].toDouble() ??
                          0;
                  domi.estadisticaTotal.efectivo =
                      domiDoc.data["estadisticaTotal"]["efectivo"].toDouble() ??
                          0;
                  runApp(
                    ChangeNotifierProvider<InternetStatus>(
                      create: (context) => status,
                      child: MaterialApp(
                        theme: ThemeData(
                          brightness: Brightness.dark,
                          primaryColor: kGreenManda2Color,
                        ),
                        debugShowCheckedModeBanner: false,
                        home: Home(
                          isDomi: true,
                          docsSent: userDoc.data["roles"]["estadoRegistroDomi"],
                        ),
                        routes: <String, WidgetBuilder>{
                          '/home': (BuildContext context) => Home(),
                          '/perfil': (BuildContext context) => Perfil(),
                          '/tomados': (BuildContext context) =>
                              MandadosTomados(),
                        },
                      ),
                    ),
                  );
                }).catchError((e) {
                  if (e != null) {
                    print("💩 ERROR AL OBTENER DOMI: $e");
                  }
                });
              }
              print("✔️ USER DESCARGADO");
            }
          }).catchError((e) {
            print("💩 ERROR AL OBTENER USER: $e");
          });
        } else {
          if (isFirstTime) {
            runApp(
              ChangeNotifierProvider<InternetStatus>(
                create: (context) => status,
                child: MaterialApp(
                  theme: ThemeData(
                    brightness: Brightness.dark,
                    primaryColor: kGreenManda2Color,
                  ),
                  debugShowCheckedModeBanner: false,
                  home: Diapositivas(),
                ),
              ),
            );
          } else {
            runApp(
              ChangeNotifierProvider<InternetStatus>(
                create: (context) => status,
                child: MaterialApp(
                  theme: ThemeData(
                    brightness: Brightness.dark,
                    primaryColor: kGreenManda2Color,
                  ),
                  debugShowCheckedModeBanner: false,
                  home: IniciarSesion(),
                ),
              ),
            );
          }
        }
      });
    }
  }).onError((e) {
    print("💩 ERROR AL OBTENER CONSTANTES: $e");
    Auth().getCurrentUser().then((firebaseUser) {
      if (firebaseUser != null) {
        Firestore.instance
            .document("users/${firebaseUser?.uid}")
            .get()
            .then((userDoc) {
          if (userDoc.data["roles"]["isBloqueado"] == true) {
            runApp(
              ChangeNotifierProvider<InternetStatus>(
                create: (context) => status,
                child: MaterialApp(
                  theme: ThemeData(
                    brightness: Brightness.dark,
                    primaryColor: kGreenManda2Color,
                  ),
                  debugShowCheckedModeBanner: false,
                  home: BannedPage(),
                ),
              ),
            );
          } else {
            if (!userDoc.data["roles"]["isDomi"]) {
              // No es domi
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
              runApp(
                ChangeNotifierProvider<InternetStatus>(
                  create: (context) => status,
                  child: MaterialApp(
                    theme: ThemeData(
                      brightness: Brightness.dark,
                      primaryColor: kGreenManda2Color,
                    ),
                    debugShowCheckedModeBanner: false,
                    home: Home(
                      isDomi: false,
                      docsSent: userDoc.data["roles"]["estadoRegistroDomi"],
                    ),
                    routes: <String, WidgetBuilder>{
                      '/home': (BuildContext context) => Home(),
                      '/perfil': (BuildContext context) => Perfil(),
                      '/tomados': (BuildContext context) => MandadosTomados(),
                    },
                  ),
                ),
              );
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
                domi.tipoCuentaBancaria =
                    domiDoc.data["cuentaBancaria"]['tipo'];
                domi.numeroCuentaBancaria =
                    domiDoc.data["cuentaBancaria"]['numero'];
                domi.user.isDomi = userDoc.data["roles"]["isDomi"];
                domi.user.docsSent =
                    userDoc.data["roles"]["estadoRegistroDomi"];
                domi.user.numTomados = userDoc.data['numTomados'];
                domi.estadisticaParcial = EstadisticaDomi();
                domi.estadisticaParcial.mandados =
                    domiDoc.data["estadisticaParcial"]["mandados"] ?? 0;
                domi.estadisticaParcial.envios =
                    domiDoc.data["estadisticaParcial"]["envios"] ?? 0;
                domi.estadisticaParcial.tarjeta =
                    domiDoc.data["estadisticaParcial"]["tarjeta"].toDouble() ??
                        0;
                domi.estadisticaParcial.efectivo =
                    domiDoc.data["estadisticaParcial"]["efectivo"].toDouble() ??
                        0;
                domi.estadisticaTotal = EstadisticaDomi();
                domi.estadisticaTotal.mandados =
                    domiDoc.data["estadisticaTotal"]["mandados"] ?? 0;
                domi.estadisticaTotal.envios =
                    domiDoc.data["estadisticaTotal"]["envios"] ?? 0;
                domi.estadisticaTotal.tarjeta =
                    domiDoc.data["estadisticaTotal"]["tarjeta"].toDouble() ?? 0;
                domi.estadisticaTotal.efectivo =
                    domiDoc.data["estadisticaTotal"]["efectivo"].toDouble() ??
                        0;
                runApp(
                  ChangeNotifierProvider<InternetStatus>(
                    create: (context) => status,
                    child: MaterialApp(
                      theme: ThemeData(
                        brightness: Brightness.dark,
                        primaryColor: kGreenManda2Color,
                      ),
                      debugShowCheckedModeBanner: false,
                      home: Home(
                        isDomi: true,
                        docsSent: userDoc.data["roles"]["estadoRegistroDomi"],
                      ),
                      routes: <String, WidgetBuilder>{
                        '/home': (BuildContext context) => Home(),
                        '/perfil': (BuildContext context) => Perfil(),
                        '/tomados': (BuildContext context) => MandadosTomados(),
                      },
                    ),
                  ),
                );
              }).catchError((e) {
                if (e != null) {
                  print("💩 ERROR AL OBTENER DOMI: $e");
                }
              });
            }
            print("✔️ USER DESCARGADO");
          }
        }).catchError((e) {
          print("💩 ERROR AL OBTENER USER: $e");
        });
      } else {
        if (isFirstTime) {
          runApp(
            ChangeNotifierProvider<InternetStatus>(
              create: (context) => status,
              child: MaterialApp(
                theme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: kGreenManda2Color,
                ),
                debugShowCheckedModeBanner: false,
                home: Diapositivas(),
              ),
            ),
          );
        } else {
          runApp(
            ChangeNotifierProvider<InternetStatus>(
              create: (context) => status,
              child: MaterialApp(
                theme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: kGreenManda2Color,
                ),
                debugShowCheckedModeBanner: false,
                home: IniciarSesion(),
              ),
            ),
          );
        }
      }
    });
  });
}
