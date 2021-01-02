import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_alert_tomar.dart';
import 'package:manda2domis/components/m2_button.dart';
import 'package:manda2domis/components/m2_icono_estado.dart';
import 'package:manda2domis/components/m2_num_estado.dart';
import 'package:manda2domis/components/m2_sin_conexion_container.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/firebase/start_databases/get_constantes.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';
import 'package:manda2domis/functions/formato_fecha.dart';
import 'package:manda2domis/functions/formatted_money_value.dart';
import 'package:manda2domis/functions/launch_whatsapp.dart';
import 'package:manda2domis/functions/llamar.dart';
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:manda2domis/functions/pop.dart';
import 'package:manda2domis/view_controllers/Home/mandado_entregado.dart';
import 'package:manda2domis/model/mandado_model.dart';
import 'package:manda2domis/view_controllers/Home/detail_direcciones_home.dart';
import 'package:manda2domis/view_controllers/perfil/mandados_tomados/madados_tomados.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Home.dart';

class Tomar extends StatefulWidget {
  Tomar({
    this.mandado,
  });
  Mandado mandado;
  @override
  _TomarState createState() => _TomarState(
        mandado: mandado,
      );
}

class _TomarState extends State<Tomar> {
  _TomarState({
    this.mandado,
  });
  Mandado mandado;

  bool isEntrega;
  bool online = true;
  bool propina = true;

  bool isLoadingBtn = false;

  DateTime ahora;

  double longitudInicial;
  double latitudInicial;
  String destino = '';
  String destinoSinEspacios;
  String origen = '';
  String origenSinEspacios;
  final GlobalKey globalKey = GlobalKey();
  final GlobalKey globalKey2 = GlobalKey();
  double containerWidth;
  double containerHeight;
  double containerWidth2;
  double containerHeight2;

  bool successContainerIsHidden = true;
  String successContainerMessage = "";
  bool failureContainerIsHidden = true;
  String failureContainerMessage = "";

  @override
  void initState() {
    ahora = DateTime.now();
    mandado.recogidoDateTimeMSE = ahora.millisecondsSinceEpoch;
    origen = '${mandado.origen.direccion} ${mandado.origen.ciudad}';
    destino = '${mandado.destino.direccion} ${mandado.destino.ciudad}';
    convertirUbicacionOrigen();
    convertirUbicacionDestino();
    super.initState();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kBlackColor,
        appBar: CupertinoNavigationBar(
          backgroundColor: kBlackColor,
          leading: GestureDetector(
              onTap: () {
                if (!mandado.isTomado) {
                  Navigator.push(context, SlideRightRoute(page: Home()));
                } else {
                  Navigator.push(
                      context, SlideRightRoute(page: MandadosTomados()));
                }
              },
              child: Image.asset(
                'images/atras.png',
                color: kWhiteColor,
                width: 25,
              )),
          middle: Text(
            mandado.isTomado && mandado.isRecogido
                ? "Entrega el mandado"
                : mandado.isTomado
                    ? "Recoge el mandado"
                    : "Toma el mandado",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kWhiteColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          border: Border.all(color: kBlackColor),
        ),
        body: Stack(
          children: [
            Padding(
              padding:
                  EdgeInsets.fromLTRB(17, 0, 17, mandado.isTomado ? 296 : 252),
              child: CatapultaScrollView(
                child: Column(
                  children: <Widget>[
                    /// CLIENTE ESTÁ SOLICITANDO
                    mandado.isTomado
                        ? SizedBox(
                            height: 20,
                          )
                        : Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(37, 10, 37, 44),
                              child: Text(
                                '${mandado.cliente.name} solicitó un mandado de ${mandado.categoria.title} ${mandado.categoria.emoji}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 14, color: kWhiteColor)),
                              ),
                            ),
                          ),

                    /// TOMA
                    mandado.isTomado
                        ? Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 67,
                                    child: ContainerNum(
                                      num: 1,
                                      color: mandado.isTomado
                                          ? kColorDeFondo
                                          : kGreenManda2Color,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 17),
                                    height: 48,
                                    width: 1,
                                    color: kColorDeFondo,
                                  ),
                                ],
                              ),
                              mandado.isTomado
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${dateFormattedFromDateTime(DateTime.fromMillisecondsSinceEpoch(mandado.tomadoDateTimeMSE))}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: kColorDeFondo,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Tomado',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: kColorDeFondo,
                                          ),
                                        ),
                                        SizedBox(height: 48),
                                      ],
                                    )
                                  : Container(
                                      key: globalKey,
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Tomar el\nmandado',
                                            style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                color: kGreenManda2Color),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Recogerás en',
                                            style: GoogleFonts.poppins(
                                                color: kWhiteColor,
                                                fontSize: 15),
                                          ),
                                          SizedBox(height: 4),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.65,
                                            child: Text(
                                                '${mandado.origen.direccion}, ${mandado.origen.ciudad}',
                                                style: GoogleFonts.poppins(
                                                    color: kBlackColorOpacity,
                                                    fontSize: 12)),
                                          ),
                                          SizedBox(height: 4),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isEntrega = false;
                                              });
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      RecogidaEntregaHome(
                                                    isEntrega: isEntrega,
                                                    mandado: mandado,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Ver detalles de recogida',
                                              style: GoogleFonts.poppins(
                                                color: kGreenManda2Color,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            'Entregarás en',
                                            style: GoogleFonts.poppins(
                                              color: kWhiteColor,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.65,
                                            child: Text(
                                              '${mandado.destino.direccion}, ${mandado.destino.ciudad}',
                                              style: GoogleFonts.poppins(
                                                color: kBlackColorOpacity,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isEntrega = true;
                                              });
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      RecogidaEntregaHome(
                                                    isEntrega: isEntrega,
                                                    mandado: mandado,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Ver detalles de entrega',
                                              style: GoogleFonts.poppins(
                                                color: kGreenManda2Color,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height: mandado.descripcion ==
                                                          null ||
                                                      mandado.descripcion == ''
                                                  ? 0
                                                  : 12),
                                          mandado.descripcion == null ||
                                                  mandado.descripcion == ''
                                              ? Container(height: 0)
                                              : Text(
                                                  'Notas',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: kWhiteColor,
                                                  ),
                                                ),
                                          SizedBox(
                                              height: mandado.descripcion ==
                                                          null ||
                                                      mandado.descripcion == ''
                                                  ? 0
                                                  : 4),
                                          mandado.descripcion == null ||
                                                  mandado.descripcion == ''
                                              ? Container(height: 0)
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  child: Text(
                                                    '${mandado.descripcion}',
                                                    style: GoogleFonts.poppins(
                                                      color: kBlackColorOpacity,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(height: 24),
                                        ],
                                      ),
                                    ),
                            ],
                          )
                        : Expanded(
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      width: 67,
                                      child: ContainerNum(
                                        num: 1,
                                        color: mandado.isTomado
                                            ? kColorDeFondo
                                            : kGreenManda2Color,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 17),
                                        width: 1,
                                        color: kColorDeFondo,
                                      ),
                                    ),
                                  ],
                                ),
                                mandado.isTomado
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${dateFormattedFromDateTime(DateTime.fromMillisecondsSinceEpoch(mandado.tomadoDateTimeMSE))}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: kColorDeFondo,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'Tomado',
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: kColorDeFondo,
                                            ),
                                          ),
                                          SizedBox(height: 24),
                                        ],
                                      )
                                    : Container(
                                        key: globalKey,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.65,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tomar el\nmandado',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  color: kGreenManda2Color),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Recogerás en',
                                              style: GoogleFonts.poppins(
                                                  color: kWhiteColor,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(height: 4),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: Text(
                                                  '${mandado.origen.direccion}, ${mandado.origen.ciudad}',
                                                  style: GoogleFonts.poppins(
                                                      color: kBlackColorOpacity,
                                                      fontSize: 12)),
                                            ),
                                            SizedBox(height: 4),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isEntrega = false;
                                                });
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        RecogidaEntregaHome(
                                                      isEntrega: isEntrega,
                                                      mandado: mandado,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Ver detalles de recogida',
                                                style: GoogleFonts.poppins(
                                                  color: kGreenManda2Color,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              'Entregarás en',
                                              style: GoogleFonts.poppins(
                                                color: kWhiteColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: Text(
                                                '${mandado.destino.direccion}, ${mandado.destino.ciudad}',
                                                style: GoogleFonts.poppins(
                                                  color: kBlackColorOpacity,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isEntrega = true;
                                                });
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        RecogidaEntregaHome(
                                                      isEntrega: isEntrega,
                                                      mandado: mandado,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Ver detalles de entrega',
                                                style: GoogleFonts.poppins(
                                                  color: kGreenManda2Color,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: mandado.descripcion ==
                                                            null ||
                                                        mandado.descripcion ==
                                                            ''
                                                    ? 0
                                                    : 12),
                                            mandado.descripcion == null ||
                                                    mandado.descripcion == ''
                                                ? Container(height: 0)
                                                : Text(
                                                    'Notas',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color: kWhiteColor,
                                                    ),
                                                  ),
                                            SizedBox(
                                                height: mandado.descripcion ==
                                                            null ||
                                                        mandado.descripcion ==
                                                            ''
                                                    ? 0
                                                    : 4),
                                            mandado.descripcion == null ||
                                                    mandado.descripcion == ''
                                                ? Container(height: 0)
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.65,
                                                    child: Text(
                                                      '${mandado.descripcion}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color:
                                                            kBlackColorOpacity,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                            SizedBox(height: 24),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),

                    /// RECOGE
                    mandado.isTomado && !mandado.isRecogido
                        ? Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 17),
                                      height: 5,
                                      width: 1,
                                      color: kColorDeFondo,
                                    ),
                                    ContainerNum(
                                      num: 2,
                                      color: mandado.isTomado &&
                                              !mandado.isRecogido
                                          ? kGreenManda2Color
                                          : kColorDeFondo,
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 17),
                                        width: 1,
                                        color: kColorDeFondo,
                                      ),
                                    ),
                                  ],
                                ),
                                mandado.isTomado == false
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Recoge el\nmandado',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              color: kColorDeFondo,
                                            ),
                                          ),
                                        ],
                                      )
                                    : mandado.isRecogido
                                        ? Padding(
                                            padding: EdgeInsets.only(right: 17),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${dateFormattedFromDateTime(DateTime.fromMillisecondsSinceEpoch(mandado.recogidoDateTimeMSE))}',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: kColorDeFondo,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  'Recogido',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: kColorDeFondo,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Recoge el\nmandado',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  color: kGreenManda2Color,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.65,
                                                child: Text(
                                                  '${mandado.origen.direccion}, ${mandado.origen.ciudad}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: kWhiteColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.65,
                                                child: Text(
                                                  mandado.tipoPago ==
                                                          'Efectivo contra entrega'
                                                      ? "Cobra ${formattedMoneyValue(mandado.total)} cuando\nrecojas el mandado."
                                                      : "No debes cobrar este mandado, ya está pago.",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: kBlackColorOpacity,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isEntrega = false;
                                                  });
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          RecogidaEntregaHome(
                                                        isEntrega: isEntrega,
                                                        mandado: mandado,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Ver detalles de recogida',
                                                  style: GoogleFonts.poppins(
                                                    color: kGreenManda2Color,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: mandado.descripcion ==
                                                              null ||
                                                          mandado.descripcion ==
                                                              ''
                                                      ? 0
                                                      : 12),
                                              mandado.descripcion == null ||
                                                      mandado.descripcion == ''
                                                  ? Container(height: 0)
                                                  : Text(
                                                      'Notas',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        color: kWhiteColor,
                                                      ),
                                                    ),
                                              SizedBox(
                                                  height: mandado.descripcion ==
                                                              null ||
                                                          mandado.descripcion ==
                                                              ''
                                                      ? 0
                                                      : 4),
                                              mandado.descripcion == null ||
                                                      mandado.descripcion == ''
                                                  ? Container(height: 0)
                                                  : Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.65,
                                                      child: Text(
                                                        '${mandado.descripcion}',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color:
                                                              kBlackColorOpacity,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                              SizedBox(height: 24),
                                            ],
                                          )
                              ],
                            ),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 17),
                                    height: 5,
                                    width: 1,
                                    color: kColorDeFondo,
                                  ),
                                  ContainerNum(
                                    num: 2,
                                    color:
                                        mandado.isTomado && !mandado.isRecogido
                                            ? kGreenManda2Color
                                            : kColorDeFondo,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 17),
                                    height: 48,
                                    width: 1,
                                    color: kColorDeFondo,
                                  ),
                                ],
                              ),
                              mandado.isTomado == false
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Recoge el\nmandado',
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: kColorDeFondo,
                                          ),
                                        ),
                                      ],
                                    )
                                  : mandado.isRecogido
                                      ? Padding(
                                          padding: EdgeInsets.only(right: 17),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 5),
                                              Text(
                                                '${dateFormattedFromDateTime(DateTime.fromMillisecondsSinceEpoch(mandado.recogidoDateTimeMSE))}',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: kColorDeFondo,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                'Recogido',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: kColorDeFondo),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Recoge el\nmandado',
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                color: kGreenManda2Color,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: Text(
                                                '${mandado.origen.direccion}, ${mandado.origen.ciudad}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: kWhiteColor,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: Text(
                                                mandado.tipoPago ==
                                                        'Efectivo contra entrega'
                                                    ? "Cobra ${formattedMoneyValue(mandado.total)} cuando\nrecojas el mandado."
                                                    : "No debes cobrar este mandado, ya está pago.",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: kBlackColorOpacity,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isEntrega = false;
                                                });
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        RecogidaEntregaHome(
                                                      isEntrega: isEntrega,
                                                      mandado: mandado,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Ver detalles de recogida',
                                                style: GoogleFonts.poppins(
                                                  color: kGreenManda2Color,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: mandado.descripcion ==
                                                            null ||
                                                        mandado.descripcion ==
                                                            ''
                                                    ? 0
                                                    : 12),
                                            mandado.descripcion == null ||
                                                    mandado.descripcion == ''
                                                ? Container(height: 0)
                                                : Text(
                                                    'Notas',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color: kWhiteColor,
                                                    ),
                                                  ),
                                            SizedBox(
                                                height: mandado.descripcion ==
                                                            null ||
                                                        mandado.descripcion ==
                                                            ''
                                                    ? 0
                                                    : 4),
                                            mandado.descripcion == null ||
                                                    mandado.descripcion == ''
                                                ? Container(height: 0)
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.65,
                                                    child: Text(
                                                      '${mandado.descripcion}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color:
                                                            kBlackColorOpacity,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                            SizedBox(height: 24),
                                          ],
                                        )
                            ],
                          ),

                    /// ENTREGA
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 17),
                              height: 5,
                              width: 1,
                              color: kColorDeFondo,
                            ),
                            ContainerNum(
                              num: 3,
                              color: mandado.isRecogido
                                  ? kGreenManda2Color
                                  : kColorDeFondo,
                            ),
                          ],
                        ),
                        mandado.isRecogido
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Entrega el\nmandado',
                                    style: GoogleFonts.poppins(
                                        fontSize: 20, color: kGreenManda2Color),
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Text(
                                      '${mandado.destino.direccion}, ${mandado.destino.ciudad}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 15, color: kWhiteColor),
                                    ),
                                  ),
                                  mandado.tipoPago == 'Efectivo contra entrega'
                                      ? Container()
                                      : SizedBox(height: 4),
                                  mandado.tipoPago == 'Efectivo contra entrega'
                                      ? Container()
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          child: Text(
                                            "No debes cobrar este mandado, ya está pago.",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: kBlackColorOpacity,
                                            ),
                                          ),
                                        ),
                                  SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isEntrega = true;
                                      });
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              RecogidaEntregaHome(
                                            isEntrega: isEntrega,
                                            mandado: mandado,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Ver detalles de entrega',
                                      style: GoogleFonts.poppins(
                                        color: kGreenManda2Color,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: mandado.descripcion == null ||
                                              mandado.descripcion == ''
                                          ? 0
                                          : 12),
                                  mandado.descripcion == null ||
                                          mandado.descripcion == ''
                                      ? Container()
                                      : Text(
                                          'Notas',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: kWhiteColor,
                                          ),
                                        ),
                                  SizedBox(
                                      height: mandado.descripcion == null ||
                                              mandado.descripcion == ''
                                          ? 0
                                          : 4),
                                  mandado.descripcion == null ||
                                          mandado.descripcion == ''
                                      ? Container()
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          child: Text(
                                            '${mandado.descripcion}',
                                            style: GoogleFonts.poppins(
                                              color: kBlackColorOpacity,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                  SizedBox(height: 28)
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Entrega el',
                                    style: GoogleFonts.poppins(
                                        fontSize: 20, color: kColorDeFondo),
                                  ),
                                  Text(
                                    'mandado',
                                    style: GoogleFonts.poppins(
                                        fontSize: 20, color: kColorDeFondo),
                                  ),
                                  SizedBox(height: 17),
                                ],
                              )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            mandado.isTomado && mandado.isRecogido
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 296,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 17),
                        color: kColorDeFondo,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: [
                              Text('Mandado solicitado',
                                  style: GoogleFonts.poppins(
                                      color: kBlackColorOpacity,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300)),
                              Expanded(
                                child: Container(),
                              ),
                              Text('${mandado.categoria.title}',
                                  style: GoogleFonts.poppins(
                                      color: kBlackColorOpacity,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500))
                            ]),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('Fecha límite',
                                    style: GoogleFonts.poppins(
                                        color: kBlackColorOpacity,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300)),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                    '${dateFormattedFromDateTime(mandado.fechaMaxEntrega)}',
                                    style: GoogleFonts.poppins(
                                        color: mandado.fechaMaxEntrega
                                                .isBefore(DateTime.now())
                                            ? kRedColor
                                            : kBlackColorOpacity,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('Identificador del mandado',
                                    style: GoogleFonts.poppins(
                                        color: kBlackColorOpacity,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300)),
                                Expanded(
                                  child: Container(),
                                ),
                                Text('${mandado.identificador}',
                                    style: GoogleFonts.poppins(
                                        color: kBlackColorOpacity,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                            SizedBox(
                              height: 31,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconoEstado(
                                  imageRoute: 'images/brujula.png',
                                  text1: 'Ver en',
                                  text2: 'mapa',
                                  onTap: _handleVerMapa,
                                ),
                                IconoEstado(
                                  imageRoute: 'images/contactar.png',
                                  text1: 'Contactar',
                                  text2: 'al cliente',
                                  onTap: () {
                                    llamar(context,
                                        mandado.destino.contactoPhoneNumber);
                                  },
                                ),
                                IconoEstado(
                                  imageRoute: 'images/soporte.png',
                                  text1: 'Escribir',
                                  text2: 'a soporte',
                                  onTap: () {
                                    launchWhatsApp(context, contactoSoporte);
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                              child: M2Button(
                                  width: MediaQuery.of(context).size.width,
                                  backgroundColor: kGreenManda2Color,
                                  title: 'Ya entregué el mandado',
                                  isLoading: isLoadingBtn,
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    showAlertaTomar(
                                      context,
                                      '¿Quieres continuar?',
                                      'Estás a punto de indicar que entregaste el mandado.',
                                      _yaEntregueElMandadoBack,
                                    );
                                  }),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : mandado.isTomado
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 296,
                            color: kColorDeFondo,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 17),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(children: [
                                  Text(
                                    'Mandado solicitado',
                                    style: GoogleFonts.poppins(
                                      color: kBlackColorOpacity,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Text(
                                    '${mandado.categoria.title}',
                                    style: GoogleFonts.poppins(
                                      color: kBlackColorOpacity,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ]),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Fecha límite',
                                      style: GoogleFonts.poppins(
                                        color: kBlackColorOpacity,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Text(
                                      '${dateFormattedFromDateTime(mandado.fechaMaxEntrega)}',
                                      style: GoogleFonts.poppins(
                                        color: mandado.fechaMaxEntrega.isBefore(
                                          DateTime.now(),
                                        )
                                            ? kRedColor
                                            : kBlackColorOpacity,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Identificador del mandado',
                                      style: GoogleFonts.poppins(
                                        color: kBlackColorOpacity,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Text(
                                      '${mandado.identificador}',
                                      style: GoogleFonts.poppins(
                                        color: kBlackColorOpacity,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 31,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconoEstado(
                                      imageRoute: 'images/brujula.png',
                                      text1: 'Ver en',
                                      text2: 'mapa',
                                      onTap: _handleVerMapa,
                                    ),
                                    IconoEstado(
                                      imageRoute: 'images/contactar.png',
                                      text1: 'Contactar',
                                      text2: 'al cliente',
                                      onTap: () {
                                        llamar(
                                            context,
                                            mandado
                                                .destino.contactoPhoneNumber);
                                      },
                                    ),
                                    IconoEstado(
                                      imageRoute: 'images/soporte.png',
                                      text1: 'Escribir',
                                      text2: 'a soporte',
                                      onTap: () {
                                        launchWhatsApp(
                                            context, contactoSoporte);
                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                                  child: M2Button(
                                      width: MediaQuery.of(context).size.width,
                                      backgroundColor: kGreenManda2Color,
                                      title: 'Ya tengo el mandado',
                                      isLoading: isLoadingBtn,
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        showAlertaTomar(
                                          context,
                                          '¿Quieres continuar?',
                                          'Estás a punto de indicar que recogiste el mandado.',
                                          _yaTengoElMandadoBack,
                                        );
                                      }),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 252,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 17),
                            color: kColorDeFondo,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text('Fecha límite',
                                        style: GoogleFonts.poppins(
                                            color: kBlackColorOpacity,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300)),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Text(
                                      '${dateFormattedFromDateTime(mandado.fechaMaxEntrega)}',
                                      style: GoogleFonts.poppins(
                                        color: kBlackColorOpacity,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconoEstado(
                                      imageRoute: 'images/brujula.png',
                                      text1: 'Ver en',
                                      text2: 'mapa',
                                      color: kWhiteColor.withOpacity(0.25),
                                    ),
                                    IconoEstado(
                                      imageRoute: 'images/contactar.png',
                                      text1: 'Contactar',
                                      text2: 'al cliente',
                                      color: kWhiteColor.withOpacity(0.25),
                                    ),
                                    IconoEstado(
                                      imageRoute: 'images/soporte.png',
                                      text1: 'Escribir',
                                      text2: 'a soporte',
                                      color: kWhiteColor.withOpacity(0.25),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                                  child: M2Button(
                                    width: MediaQuery.of(context).size.width,
                                    backgroundColor: kGreenManda2Color,
                                    title: 'Tomar mandado',
                                    isLoading: isLoadingBtn,
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      showAlertaTomar(
                                        context,
                                        '¿Quieres continuar?',
                                        'Estás a punto de tomar este mandado.',
                                        _tomarMandadoBack,
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
            Column(
              children: <Widget>[
                M2AnimatedContainer(
                  height: successContainerIsHidden ? 0 : 50,
                  backgroundColor: kGreenManda2Color.withOpacity(0.7),
                  text: successContainerMessage ?? "",
                ),
                M2AnimatedContainer(
                  height: failureContainerIsHidden ? 0 : 50,
                  text: failureContainerMessage ?? "",
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///Obtiene la ubicación del usuario
  void obtenerUbicacion() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitudInicial = (position.latitude);
    longitudInicial = (position.longitude);
  }

  ///Reemplaza los espacios del destino que el usuario proporciona por %20
  void convertirUbicacionDestino() async {
    setState(() {
      destinoSinEspacios = destino.replaceAll(" ", "%20");
    });
  }

  ///Inicia waze con los datos obtenidos por covertirUbicacion y obtenerUbicacion
  _launchURLDestino() async {
    String url =
        'https://waze.com/ul?q=$destinoSinEspacios&ll=$latitudInicial,$longitudInicial';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ///Reemplaza los espacios del destino que el usuario proporciona por %20
  void convertirUbicacionOrigen() async {
    setState(() {
      origenSinEspacios = origen.replaceAll(" ", "%20");
    });
  }

  ///Inicia waze con los datos obtenidos por covertirUbicacion y obtenerUbicacion
  _launchURLOrigen() async {
    String url =
        'https://waze.com/ul?q=$origenSinEspacios&ll=$latitudInicial,$longitudInicial';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _handleVerMapa() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Ver en Waze"),
            onPressed: () {
              if (mandado.isTomado && mandado.isRecogido) {
                _launchURLDestino();
              } else {
                _launchURLOrigen();
              }
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Ver en Google Maps"),
            onPressed: () async {
              String url =
                  "https://www.google.com/maps/dir/?api=1&destination=${mandado.isTomado && mandado.isRecogido ? destino.replaceAll("#", "No. ").replaceAll(" ", "+").replaceAll("á", "a").replaceAll("Á", "A").replaceAll("é", "e").replaceAll("É", "E").replaceAll("í", "i").replaceAll("Í", "I").replaceAll("ó", "o").replaceAll("Ó", "O").replaceAll("ú", "u").replaceAll("Ú", "U") : origen.replaceAll("#", "No. ").replaceAll(" ", "+").replaceAll("á", "a").replaceAll("Á", "A").replaceAll("é", "e").replaceAll("É", "E").replaceAll("í", "i").replaceAll("Í", "I").replaceAll("ó", "o").replaceAll("Ó", "O").replaceAll("ú", "u").replaceAll("Ú", "U")}&travelmode=driving";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                showBasicAlert(
                  context,
                  "Hubo un error.",
                  "Por favor, intenta más tarde",
                );
                print("NIGGA: $url");
                throw 'Could not launch $url';
              }
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Copiar dirección"),
            onPressed: () {
              print("PORTA PAPELES");
              if (mandado.isTomado && mandado.isRecogido) {
                Clipboard.setData(ClipboardData(text: destino)).then((r) {
                  print("DIRECCIÓN COPIADA");
                  setState(() {
                    failureContainerIsHidden = true;
                    successContainerIsHidden = false;
                    successContainerMessage =
                        "${mandado.isTomado && mandado.isRecogido ? "Punto de entrega" : "Punto de recogida"} copiado en portapapeles";
                  });
                  Future.delayed(Duration(seconds: 3)).then((r) {
                    setState(() {
                      failureContainerIsHidden = true;
                      successContainerIsHidden = true;
                    });
                  });
                }).catchError((e) {
                  print("ERROR AL COPIAR DIRECCIÓN: $e");
                  setState(() {
                    successContainerIsHidden = true;
                    failureContainerIsHidden = false;
                    failureContainerMessage =
                        "Error al copiar dirección ${mandado.isTomado && mandado.isRecogido ? "de entrega" : "de recogida"}";
                  });
                  Future.delayed(Duration(seconds: 3)).then((r) {
                    setState(() {
                      successContainerIsHidden = true;
                      failureContainerIsHidden = true;
                    });
                  });
                });
              } else {
                Clipboard.setData(ClipboardData(text: origen)).then((r) {
                  print("DIRECCIÓN COPIADA");
                  setState(() {
                    failureContainerIsHidden = true;
                    successContainerIsHidden = false;
                    successContainerMessage =
                        "${mandado.isTomado && mandado.isRecogido ? "Punto de entrega" : "Punto de recogida"} copiado en portapapeles";
                  });
                  Future.delayed(Duration(seconds: 3)).then((r) {
                    setState(() {
                      failureContainerIsHidden = true;
                      successContainerIsHidden = true;
                    });
                  });
                }).catchError((e) {
                  print("ERROR AL COPIAR DIRECCIÓN: $e");
                  setState(() {
                    successContainerIsHidden = true;
                    failureContainerIsHidden = false;
                    failureContainerMessage =
                        "Error al copiar dirección ${mandado.isTomado && mandado.isRecogido ? "de entrega" : "de recogida"}";
                  });
                  Future.delayed(Duration(seconds: 3)).then((r) {
                    setState(() {
                      successContainerIsHidden = true;
                      failureContainerIsHidden = true;
                    });
                  });
                });
              }
              Navigator.pop(context);
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

  void _tomarMandadoBack() {
    setState(() {
      isLoadingBtn = true;
    });

    Map<String, dynamic> mandadoMap = {
      "estados.isTomado": true,
      "estados.dates.tomado": DateTime.now().millisecondsSinceEpoch,
      "domiciliarioId": domi.user.objectId,
    };

    print("TOMARÉ MANDADO");
    Firestore.instance
        .document("mandadosDesarrollo/${mandado.id}")
        .updateData(mandadoMap)
        .then((r) {
      print("MANDADO TOMADO");
      Map<String, dynamic> domiMap = {
        "estadisticaParcial": {
          "mandados": domi.estadisticaParcial.mandados + 1,
          "efectivo": mandado.tipoPago == "Efectivo contra entrega"
              ? domi.estadisticaParcial.efectivo + mandado.total
              : domi.estadisticaParcial.efectivo,
          "envios": mandado.tipoPago == "Envíos redimibles"
              ? domi.estadisticaParcial.envios + 1
              : domi.estadisticaParcial.envios,
          "tarjeta": mandado.tipoPago == "Tarjeta de crédito"
              ? domi.estadisticaParcial.tarjeta + mandado.total
              : domi.estadisticaParcial.tarjeta,
          "fecha": domi.estadisticaParcial.fecha,
        },
        "estadisticaTotal": {
          "mandados": domi.estadisticaTotal.mandados + 1,
          "efectivo": mandado.tipoPago == "Efectivo contra entrega"
              ? domi.estadisticaTotal.efectivo + mandado.total
              : domi.estadisticaTotal.efectivo,
          "envios": mandado.tipoPago == "Envíos redimibles"
              ? domi.estadisticaTotal.envios + 1
              : domi.estadisticaTotal.envios,
          "tarjeta": mandado.tipoPago == "Tarjeta de crédito"
              ? domi.estadisticaTotal.tarjeta + mandado.total
              : domi.estadisticaTotal.tarjeta,
        },
      };
      print("ACTUALIZARÉ ESTADÍSTICAS");
      Firestore.instance
          .document("domiciliarios/${domi.user.objectId}")
          .updateData(domiMap)
          .then((r) {
        print("ESTADÍSTICAS TOMADAS");
        setState(() {
          mandado.tomadoDateTimeMSE = DateTime.now().millisecondsSinceEpoch;
          mandado.isTomado = true;
          isLoadingBtn = false;
        });
      }).catchError((e) {
        print("MANDADO ACTUALIZADO Y ERROR EN ESTADÍSTICAS");
        setState(() {
          mandado.tomadoDateTimeMSE = DateTime.now().millisecondsSinceEpoch;
          mandado.isTomado = true;
          isLoadingBtn = false;
        });
      });
    }).catchError((e) {
      setState(() {
        isLoadingBtn = false;
      });
      print("ERROR AL ACTUALIZAR MANDADO: $e");
      showBasicAlert(
        context,
        "Hubo un error.",
        "Por favor, intenta más tarde.",
      );
    });
  }

  void _yaTengoElMandadoBack() {
    setState(() {
      isLoadingBtn = true;
    });

    Map<String, dynamic> mandadoMap = {
      "estados.isRecogido": true,
      "estados.dates.recogido": DateTime.now().millisecondsSinceEpoch,
    };

    print("RECOGERÉ MANDADO");
    Firestore.instance
        .document("mandadosDesarrollo/${mandado.id}")
        .updateData(mandadoMap)
        .then((r) {
      print("MANDADO RECOGIDO");
      setState(() {
        mandado.recogidoDateTimeMSE = DateTime.now().millisecondsSinceEpoch;
        mandado.isRecogido = true;
        isLoadingBtn = false;
      });
    }).catchError((e) {
      setState(() {
        isLoadingBtn = false;
      });
      print("ERROR AL ACTUALIZAR MANDADO: $e");
      showBasicAlert(
        context,
        "Hubo un error.",
        "Por favor, intenta más tarde.",
      );
    });
  }

  void _yaEntregueElMandadoBack() {
    setState(() {
      isLoadingBtn = true;
    });

    Map<String, dynamic> mandadoMap = {
      "estados.isEntregado": true,
      "estados.dates.entregado": DateTime.now().millisecondsSinceEpoch,
    };

    print("ENTREGARÉ MANDADO");
    Firestore.instance
        .document("mandadosDesarrollo/${mandado.id}")
        .updateData(mandadoMap)
        .then((r) {
      print("MANDADO ENTREGADO");

      _createTransaccion();

      setState(() {
        mandado.entregadoDateTimeMSE = DateTime.now().millisecondsSinceEpoch;
        mandado.isEntregado = true;
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => MandadoEntregado(),
          ),
        );
        isLoadingBtn = false;
      });
    }).catchError((e) {
      setState(() {
        isLoadingBtn = false;
      });
      print("ERROR AL ACTUALIZAR MANDADO: $e");
      showBasicAlert(
        context,
        "Hubo un error.",
        "Por favor, intenta más tarde.",
      );
    });
  }

  void _createTransaccion() async {
    Map<String, dynamic> transaccionMap = {
      "concepto": "efectivo",
      "valor": mandado.total,
      "userId": mandado.cliente.objectId,
      "created": DateTime.now().millisecondsSinceEpoch,
    };
    print("⏳ GUARDARÉ TRANSACCIÓN");
    Firestore.instance
        .collection("transacciones")
        .add(transaccionMap)
        .then((r) {
      print("✔️ TRANSACCIÓN GUARDADA");
    }).catchError((e) {
      print("💩 ERROR AL GUARDAR TRANSACCIÓN: $e");
    });
  }
}
