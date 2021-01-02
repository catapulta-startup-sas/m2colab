import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/m2_calificacion.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';
import 'package:manda2domis/functions/formato_fecha.dart';
import 'package:manda2domis/model/domiciliario_model.dart';
import 'package:manda2domis/model/resena_model.dart';
import 'package:manda2domis/model/user_model.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants.dart';

class Calificacion extends StatefulWidget {
  @override
  _CalificacionState createState() => _CalificacionState();
}

class _CalificacionState extends State<Calificacion> {
  Stream domiciliarioStream;
  int cantidad = 0;
  double promedio = 0;

  @override
  void initState() {
    _getDomiciliarioStream();
    super.initState();
  }

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
          ),
        ),
        backgroundColor: kBlackColor,
        border: Border.all(color: kBlackColor),
        middle: Text(
          "Calificaciones y reseñas",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 17,
              color: kWhiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: domiciliarioStream,
            builder: (context, domiciliariosSnapshot) {
              List<Resena> resenas = List();
              if (domiciliariosSnapshot.hasData) {
                List<Domiciliario> domiciliarios =
                    domiciliariosSnapshot.data.toList();
                Domiciliario domiciliario =
                    domiciliarios.firstWhere((domiciliario) {
                  return domiciliario.user.objectId == domi.user.objectId;
                });
                List<dynamic> resenasMapList = domiciliario.resenas ?? [];
                if (resenasMapList.isNotEmpty) {
                  resenasMapList.forEach((resena) {
                    resenas.add(Resena(
                      calificacion: resena["calificacion"],
                      created: resena["created"],
                      comentario: resena["resena"],
                      nombreCalificador: resena["name"],
                    ));
                  });
                }
                cantidad = domiciliario.cantidadCalificaciones;
                promedio = (domiciliario.califPromedio * 10).round() / 10;
              }
              return !domiciliariosSnapshot.hasData || resenas.isEmpty
                  ? _aunNoLayout()
                  : Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(17, 10, 17, 10),
                          child: Container(
                            height: 111,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: kColorDeFondo,
                                borderRadius: BorderRadius.circular(26)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 37),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$cantidad',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: kWhiteColor,
                                            fontSize: 26,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Calificaciones',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: kWhiteColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$promedio',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: kWhiteColor,
                                            fontSize: 26,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Promedio',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: kWhiteColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, position) {
                              return _setupList(resenas[position]);
                            },
                            itemCount: resenas.length,
                          ),
                        ),
                      ],
                    );
            }),
      ),
    );
  }

  Widget _setupList(Resena resena) {
    return ContainerCalificacion(
      nombre: resena.nombreCalificador,
      creacion: dateFormattedFromDateTime(
          DateTime.fromMillisecondsSinceEpoch(resena.created)),
      calificacion: resena.calificacion,
      comentario: resena.comentario,
    );
  }

  Widget _aunNoLayout() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(17, 10, 17, 10),
          child: Container(
            height: 111,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: kColorDeFondo, borderRadius: BorderRadius.circular(26)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 37),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$cantidad',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: kWhiteColor,
                            fontSize: 26,
                          ),
                        ),
                      ),
                      Text(
                        'Calificaciones',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: kWhiteColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(child: Container()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$promedio',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: kWhiteColor,
                            fontSize: 26,
                          ),
                        ),
                      ),
                      Text(
                        'Promedio',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: kWhiteColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(child: Container()),
        Text(
          'Aquí encontrarás tus\ncalificaciones y reseñas.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: kBlackColorOpacity.withOpacity(0.5),
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Expanded(flex: 2, child: Container()),
      ],
    );
  }

  void _getDomiciliarioStream() async {
    domiciliarioStream = await Firestore.instance
        .collection("domiciliarios")
        .snapshots()
        .map(
          (r) => r.documents.map(
            (v) => Domiciliario(
              user: User(
                objectId: v.documentID,
              ),
              califPromedio: v.data["calificaciones"]["promedio"].toDouble(),
              cantidadCalificaciones: v.data["calificaciones"]["cantidad"],
              resenas: v.data["resenas"],
            ),
          ),
        );
    setState(() {});
  }
}
