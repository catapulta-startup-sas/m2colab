import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/m2_sin_conexion_container.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/firebase/notifications.dart';
import 'package:manda2domis/firebase/start_databases/get_constantes.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';
import 'package:manda2domis/components/m2_button.dart';
import 'package:manda2domis/functions/formato_fecha.dart';
import 'package:manda2domis/functions/launch_whatsapp.dart';
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:manda2domis/model/categoria_model.dart';
import 'package:manda2domis/model/estadistica_domi_model.dart';
import 'package:manda2domis/model/lugar_model.dart';
import 'package:manda2domis/model/user_model.dart';
import 'package:manda2domis/view_controllers/Home/tomar_mandado.dart';
import 'package:manda2domis/view_controllers/perfil/completar_registro/registro.dart';
import 'package:manda2domis/view_controllers/perfil/perfil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:manda2domis/model/mandado_model.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home({
    this.isDomi,
    this.docsSent,
  });
  bool isDomi;
  int docsSent;
  @override
  _HomeState createState() => _HomeState(
        isDomi: isDomi,
        docsSent: docsSent,
      );
}

class _HomeState extends State<Home> {
  _HomeState({
    this.isDomi,
    this.docsSent,
  });

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  DateTime now = DateTime.now();

  bool isDomi;
  int docsSent;

  bool successContainerIsHidden = true;
  String successContainerMessage;
  var first;

  bool askingPermission = false;
  double longitudInicial;
  double latitudInicial;
  DateTime fecha;

  Stream mandadosStream;
  Stream usersStream;

  @override
  void initState() {
    initializeDateFormatting();
    _getMandadosStream();
    _getUsersStream();
    final pushNotification = PushNotification();
    pushNotification.initNotifications();
    pushNotification.mensaje.listen((data) {
      setState(() {
        print("NUEVO MANDADO");
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: kBlackColor,
        appBar: CupertinoNavigationBar(
          border: Border.all(color: kBlackColor),
          backgroundColor: kBlackColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Perfil(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 13, horizontal: 5),
              color: kBlackColor,
              child: Image(
                image: AssetImage('images/perfil.png'),
                color: kWhiteColor,
              ),
            ),
          ),
          middle: Text(
            "Mandados disponibles",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 17,
                  color: kWhiteColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
          trailing: domi.user.isDomi == true
              ? SizedBox()
              : domi.user.docsSent == 1
                  ? GestureDetector(
                      onTap: _getUser,
                      child: Container(
                        height: 21,
                        width: 21,
                        child: Image(
                          image: AssetImage('images/refresh.png'),
                          color: kWhiteColor,
                        ),
                      ),
                    )
                  : SizedBox(),
        ),
        body: domi.user.isDomi ?? false
            ? StreamBuilder(
                stream: mandadosStream,
                builder: (context, mandadosSnapshot) {
                  return !mandadosSnapshot.hasData
                      ? _aunNoLayout()
                      : StreamBuilder(
                          stream: usersStream,
                          builder: (context, usersSnapshot) {
                            List<Mandado> mandados =
                                mandadosSnapshot.data.toList();
                            if (usersSnapshot.hasData) {
                              List<User> clientes = usersSnapshot.data.toList();
                              mandados.forEach((mandado) {
                                mandado.cliente = clientes.firstWhere(
                                  (cliente) =>
                                      mandado.cliente.objectId ==
                                      cliente.objectId,
                                  orElse: () => User(
                                    objectId: "eliminado",
                                    name: "Cliente eliminado",
                                    phoneNumber: contactoSoporte,
                                  ),
                                );
                              });
                              mandados.sort((a, b) => b.createdDateTimeMSE
                                  .compareTo(a.createdDateTimeMSE));
                            }
                            return mandadosSnapshot.data.toList().isEmpty
                                ? _aunNoLayout()
                                : ListView.builder(
                                    itemBuilder: (context, position) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => Tomar(
                                                mandado: mandados[position],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: kColorDeFondo,
                                            child: Column(
                                              children: <Widget>[
                                                /// Nombre
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      13, 5, 13, 0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "${mandados[position].cliente.name}",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            fontSize: 12,
                                                            color: kWhiteColor,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(),
                                                      ),
                                                      Text(
                                                        '${dateFormattedFromDateTime(DateTime.fromMillisecondsSinceEpoch(
                                                          mandados[position]
                                                              .createdDateTimeMSE,
                                                        ))}',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            fontSize: 12,
                                                            color: kWhiteColor
                                                                .withOpacity(
                                                                    0.5),
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),

                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        /// Origen
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(13, 10,
                                                                  13, 0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                width: 30,
                                                                child: Text(
                                                                  'De:',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          kWhiteColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                "${mandados[position].origen.direccion}, ${mandados[position].origen.ciudad}",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  textStyle:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: kWhiteColor
                                                                        .withOpacity(
                                                                            0.5),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),

                                                        /// Destino
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  13, 0, 13, 0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                width: 30,
                                                                child: Text(
                                                                  'A:  ',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          kWhiteColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                "${mandados[position].destino.direccion}, ${mandados[position].destino.ciudad}",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  textStyle:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: kWhiteColor
                                                                        .withOpacity(
                                                                            0.5),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                        child: Container()),
                                                    Image.asset(
                                                      'images/adelante.png',
                                                      height: 8,
                                                      color: kWhiteColor,
                                                    ),
                                                    SizedBox(width: 13)
                                                  ],
                                                ),

                                                /// Fecha limite
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      13, 10, 13, 4),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'Fecha límite',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            color:
                                                                kBlackColorOpacity,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20),
                                                      Text(
                                                        "${dateFormattedFromDateTime(mandados[position].fechaMaxEntrega)}",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            color: kWhiteColor
                                                                .withOpacity(
                                                                    0.5),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount:
                                        mandadosSnapshot.data.toList().length,
                                  );
                          });
                })
            : domi.user.docsSent == 0
                ? _setupCompletarLayout()
                : domi.user.docsSent == 2
                    ? _setupRechazadoLayout()
                    : _setupModificarLayout(),
      ),
    );
  }

  Widget _aunNoLayout() {
    return Center(
      child: Text(
        'Aquí aparecerán los\nmandados disponibles',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: kBlackColorOpacity,
            fontSize: 18,
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _setupCompletarLayout() {
    return Container(
      color: kBlackColor,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: Text(
              '¡Hola! Aquí aparecerán los mandados disponibles. Completa tus datos para poder verlos.',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: kBlackColorOpacity.withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.w300),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Registro(isModificando: true),
                ),
              );
              if (result != null && result == 1) {
                setState(() {
                  domi.user.docsSent = 1;
                  successContainerIsHidden = false;
                  successContainerMessage = "Enviado";
                });
                Future.delayed(Duration(seconds: 3)).then((r) {
                  setState(() {
                    successContainerIsHidden = true;
                  });
                });
              }
            },
            child: Text(
              'Completar datos',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(color: kGreenManda2Color, fontSize: 15),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _setupModificarLayout() {
    return Container(
      color: kBlackColor,
      child: Column(
        children: <Widget>[
          M2AnimatedContainer(
            height: successContainerIsHidden ? 0 : 50,
            backgroundColor: kGreenManda2Color.withOpacity(0.7),
            text: successContainerMessage ?? "",
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: Text(
              '¡Hola! Aquí aparecerán los mandados disponibles cuando seas colaborador.',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: kBlackColorOpacity.withOpacity(0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Registro(isModificando: false),
                ),
              );
              if (result != null && result == 1) {
                setState(() {
                  domi.user.docsSent = 1;
                  successContainerIsHidden = false;
                  successContainerMessage = "Enviado";
                });
                Future.delayed(Duration(seconds: 3)).then((r) {
                  setState(() {
                    successContainerIsHidden = true;
                  });
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
              child: Text(
                'Modificar datos',
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(color: kGreenManda2Color, fontSize: 15)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _setupRechazadoLayout() {
    return Container(
      color: kBlackColor,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: Text(
              'Tu solicitud para ser colaborador fue rechazada.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: kBlackColorOpacity.withOpacity(0.5),
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
          M2Button(
            width: MediaQuery.of(context).size.width - 34,
            title: 'Aplicar de nuevo',
            backgroundColor: kGreenManda2Color,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Registro(),
                ),
              );
              if (result != null && result == 1) {
                setState(() {
                  domi.user.docsSent = 1;
                  successContainerIsHidden = false;
                  successContainerMessage = "Enviado";
                });
                Future.delayed(Duration(seconds: 3)).then((r) {
                  setState(() {
                    successContainerIsHidden = true;
                  });
                });
              }
            },
          ),
          SizedBox(
            height: 36,
          ),
        ],
      ),
    );
  }

  /// ==========================================================================

  void _getMandadosStream() async {
    mandadosStream = await Firestore.instance
        .collection("mandadosDesarrollo")
        .where("vencimiento",
            isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        .where("estados.isTomado", isEqualTo: false)
        .orderBy("vencimiento")
        .orderBy("created", descending: true)
        .snapshots()
        .map(
          (r) => r.documents.map(
            (v) => Mandado(
              id: v.documentID,
              identificador: v.data["identificador"],
              cliente: User(objectId: v.data["clienteId"]),
              categoria: Categoria(
                emoji: v.data["categoria"]["emoji"],
                title: v.data["categoria"]["title"],
              ),
              isTomado: v.data["estados"]["isTomado"] ?? false,
              isRecogido: v.data["estados"]["isRecogido"] ?? false,
              isEntregado: v.data["estados"]["isEntregado"] ?? false,
              isCalificado: v.data["estados"]["isCalificado"] ?? false,
              origen: Lugar(
                apto: v.data["puntoA"]["apto"],
                barrio: v.data["puntoA"]["barrio"],
                direccion: v.data["puntoA"]["calle"],
                ciudad: v.data["puntoA"]["ciudad"],
                contactoName: v.data["puntoA"]["contacto"],
                edificio: v.data["puntoA"]["edificio"],
                notas: v.data["puntoA"]["notas"],
                contactoPhoneNumber: v.data["puntoA"]["phoneNumber"],
              ),
              destino: Lugar(
                apto: v.data["puntoB"]["apto"],
                barrio: v.data["puntoB"]["barrio"],
                direccion: v.data["puntoB"]["calle"],
                ciudad: v.data["puntoB"]["ciudad"],
                contactoName: v.data["puntoB"]["contacto"],
                edificio: v.data["puntoB"]["edificio"],
                notas: v.data["puntoB"]["notas"],
                contactoPhoneNumber: v.data["puntoB"]["phoneNumber"],
              ),
              descripcion: v.data["descripcion"],
              tipoPago: v.data["pago"]["tipoPago"],
              total: v.data["pago"]["total"],
              fechaMaxEntregaStringFormatted: DateFormat('EEE d').format(
                  DateTime.fromMillisecondsSinceEpoch(v.data["vencimiento"])),
              horaMaxEntregaStringFormatted: DateFormat('hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(v.data["vencimiento"])),
              tomadoDateTimeMSE: v.data["estados"]["dates"]["tomado"],
              recogidoDateTimeMSE: v.data["estados"]["dates"]["recogido"],
              entregadoDateTimeMSE: v.data["estados"]["dates"]["entregado"],
              createdDateTimeMSE: v.data["created"],
              fechaMaxEntrega:
                  DateTime.fromMillisecondsSinceEpoch(v.data["vencimiento"]),
            ),
          ),
        );

    setState(() {});
  }

  void _getUsersStream() async {
    usersStream = await Firestore.instance.collection("users").snapshots().map(
          (r) => r.documents.map(
            (v) => User(
              objectId: v.documentID,
              name: v.data["name"],
              fotoPerfilURL: v.data["fotoPerfilURL"],
              phoneNumber: v.data["phoneNumber"],
            ),
          ),
        );
  }

  // Para actualizar estado de domiciliario
  void _getUser() async {
    Firestore.instance
        .document("users/${domi.user.objectId}")
        .get()
        .then((userDoc) {
      if (userDoc.data["roles"]["isDomi"]) {
        Firestore.instance
            .document("domiciliarios/${domi.user.objectId}")
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
          domi.numeroCuentaBancaria = domiDoc.data["cuentaBancaria"]['numero'];
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
              domiDoc.data["estadisticaParcial"]["efectivo"].toDouble() ?? 0;
          domi.estadisticaTotal = EstadisticaDomi();
          domi.estadisticaTotal.mandados =
              domiDoc.data["estadisticaTotal"]["mandados"] ?? 0;
          domi.estadisticaTotal.envios =
              domiDoc.data["estadisticaTotal"]["envios"] ?? 0;
          domi.estadisticaTotal.tarjeta =
              domiDoc.data["estadisticaTotal"]["tarjeta"].toDouble() ?? 0;
          domi.estadisticaTotal.efectivo =
              domiDoc.data["estadisticaTotal"]["efectivo"].toDouble() ?? 0;
          setState(() {
            print("✔️ DOMI APROBADO");
          });
        }).catchError((e) {
          if (e != null) {
            print("💩 ERROR AL OBTENER DOMI: $e");
          }
        });
      } else {
        showBasicAlert(context, "Aún estamos revisando tus datos.",
            "Por favor, intenta más tarde.");
      }
    }).catchError((e) {
      print("💩 ERROR AL OBTENER USER: $e");
    });
  }

  /// ==========================================================================
}
