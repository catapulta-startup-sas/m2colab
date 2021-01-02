import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/m2_mandados_tomados.dart';
import 'package:manda2domis/firebase/start_databases/get_constantes.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';
import 'package:manda2domis/functions/formato_fecha.dart';
import 'package:manda2domis/functions/pop.dart';
import 'package:manda2domis/model/categoria_model.dart';
import 'package:manda2domis/model/lugar_model.dart';
import 'package:manda2domis/model/mandado_model.dart';
import 'package:manda2domis/model/user_model.dart';
import 'package:manda2domis/view_controllers/Home/tomar_mandado.dart';
import 'package:manda2domis/view_controllers/perfil/perfil.dart';
import '../../../constants.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'detalles.dart';
import 'mandado_vencido.dart';

class MandadosTomados extends StatefulWidget {
  @override
  _MandadosTomadosState createState() => _MandadosTomadosState();
}

class _MandadosTomadosState extends State<MandadosTomados> {
  int tomado;
  int recogido;
  int entregado;
  int minutos;
  DateTime diferenciaDate;

  Stream mandadosStream;
  Stream usersStream;

  @override
  void initState() {
    initializeDateFormatting();
    _getMandadosStream();
    _getUsersStream();

    super.initState();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kBlackColor,
        appBar: CupertinoNavigationBar(
          backgroundColor: kBlackColor,
          border: Border.all(color: kBlackColor),
          leading: GestureDetector(
              onTap: () {
                Navigator.push(context, SlideRightRoute(page: Perfil()));
              },
              child: Image.asset(
                'images/atras.png',
                color: kWhiteColor,
                width: 25,
              )),
          middle: Text(
            "Mandados tomados",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kWhiteColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        body: StreamBuilder(
            stream: mandadosStream,
            builder: (context, mandadosSnapshot) {
              return !mandadosSnapshot.hasData
                  ? _aunNoLayout()
                  : StreamBuilder(
                      stream: usersStream,
                      builder: (context, usersSnapshot) {
                        List<Mandado> mandados = mandadosSnapshot.data.toList();
                        if (usersSnapshot.hasData) {
                          List<User> clientes = usersSnapshot.data.toList();
                          mandados.forEach((mandado) {
                            mandado.cliente = clientes.firstWhere(
                              (cliente) =>
                                  mandado.cliente.objectId == cliente.objectId,
                              orElse: () => User(
                                objectId: "eliminado",
                                name: "Cliente eliminado",
                                phoneNumber: contactoSoporte,
                              ),
                            );
                          });
                          mandados.sort((a, b) => a.entregadoDateTimeMSE ?? 0.compareTo(b.entregadoDateTimeMSE ?? 0));
                        }

                        return mandadosSnapshot.data.toList().isEmpty
                            ? _aunNoLayout()
                            : ListView.builder(
                                itemBuilder: (context, position) {
                                  return _setupList(mandados[position]);
                                },
                                itemCount:
                                    mandadosSnapshot.data.toList().length,
                              );
                      });
            }),
      ),
    );
  }

  Widget _aunNoLayout() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: kBlackColor,
      child: Center(
          child: Text(
        'Aquí encontrarás los\nmandados que has tomado.',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: kBlackColorOpacity.withOpacity(0.5),
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
        textAlign: TextAlign.center,
      )),
    );
  }

  Widget _setupList(Mandado mandado) {
    DateTime diferncia() {
      return DateTime.now().subtract(Duration(
          milliseconds: DateTime.now()
              .difference(mandado.fechaMaxEntrega)
              .inMilliseconds));
    }

    if (mandado.fechaMaxEntrega.isBefore(DateTime.now()) &&
        !mandado.isEntregado) {
      return EstadoMandado(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Tomar(
                mandado: mandado,
              ),
            ),
          );
        },
        contactoName: "${mandado.cliente.name}",
        origen: '${mandado.origen.direccion}, ${mandado.origen.ciudad}',
        destino: '${mandado.destino.direccion}, ${mandado.destino.ciudad}',
        estado: "Vencido",
        color: kRedColor,
        imageRoute: 'images/cancelado.png',
        fecha: "${dateFormattedFromDateTime(mandado.fechaMaxEntrega)}",
        identificador: mandado.identificador,
        created:
            'Vencido ${dateFormattedFromDateTime(diferncia()).replaceAll("H", "h").replaceAll("J", "j").replaceAll("A", "a")}',
        createdColor: kRedColor,
        vencidoOentregado: true,
      );
    } else {
      return EstadoMandado(
        onTap: () {
          if (mandado.isEntregado) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => Detalles(
                  mandado: mandado,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => Tomar(
                  mandado: mandado,
                ),
              ),
            );
          }
        },
        contactoName: mandado.origen.contactoName,
        origen: '${mandado.origen.direccion}, ${mandado.origen.ciudad}',
        destino: '${mandado.destino.direccion}, ${mandado.destino.ciudad}',
        color: kRedColor,
        imageRoute:
            mandado.isTomado && !mandado.isRecogido && !mandado.isEntregado
                ? 'images/recogido.png'
                : mandado.isTomado && mandado.isRecogido && !mandado.isEntregado
                    ? 'images/recogido.png'
                    : 'images/entregado.png',
        fecha: dateFormattedFromDateTime(mandado.fechaMaxEntrega),
        identificador: mandado.identificador,
        created: mandado.isTomado && !mandado.isRecogido && !mandado.isEntregado
            ? 'Tomado ${dateFormattedFromDateTime(DateTime.fromMillisecondsSinceEpoch(mandado.tomadoDateTimeMSE)).replaceAll("H", "h").replaceAll("J", "j").replaceAll("A", "a")}'
            : mandado.isTomado && mandado.isRecogido && !mandado.isEntregado
                ? 'Recogido ${dateFormattedFromDateTime(DateTime.fromMillisecondsSinceEpoch(mandado.recogidoDateTimeMSE)).replaceAll("H", "h").replaceAll("J", "j").replaceAll("A", "a")}'
                : 'Entregado ${dateFormattedFromDateTime(DateTime.fromMillisecondsSinceEpoch(mandado.entregadoDateTimeMSE)).replaceAll("H", "h").replaceAll("J", "j").replaceAll("A", "a")}',
        vencidoOentregado:
            mandado.isTomado && mandado.isRecogido && mandado.isEntregado
                ? true
                : false,
      );
    }
  }

  /// ==========================================================================

  void _getMandadosStream() async {
    mandadosStream = await Firestore.instance
        .collection("mandadosDesarrollo")
        .where("domiciliarioId", isEqualTo: domi.user.objectId)
        .orderBy("created")
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

  /// ==========================================================================
}
