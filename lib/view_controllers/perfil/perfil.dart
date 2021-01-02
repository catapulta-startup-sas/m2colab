import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_container_perfil.dart';
import 'package:manda2domis/firebase/start_databases/get_constantes.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:manda2domis/functions/pop.dart';
import 'package:manda2domis/view_controllers/Home/Home.dart';
import 'package:manda2domis/view_controllers/perfil/configuracion/Soporte.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import 'calificaciones/calificacion.dart';
import 'completar_registro/registro.dart';
import 'configuracion/configuracion.dart';
import 'editar_perfil/informacion_personal.dart';
import 'mandados_tomados/madados_tomados.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  bool successContainerIsHidden = true;
  String successContainerMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      appBar: CupertinoNavigationBar(
        actionsForegroundColor: kWhiteColor,
        backgroundColor: kBlackColor,
        border: Border.all(color: kBlackColor),
        leading: GestureDetector(
            onTap: () {
              Navigator.push(context, SlideRightRoute(page: Home()));
            },
            child: Image.asset(
              'images/atras.png',
              color: kWhiteColor,
              width: 25,
            )),
        middle: Text(
          "Perfil",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 17, color: kWhiteColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: CatapultaScrollView(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 31),
              child: Image.asset("images/cuadrosPerfil.png"),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: kTransparent),
                          borderRadius: kRadiusAll,
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Color(0x15D1D1D1),
                          highlightColor: Color(0x01D1D1D1),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kTransparent),
                              borderRadius: kRadiusAll,
                              color: Colors.lightBlue[100],
                            ),
                            height: MediaQuery.of(context).size.width * 0.2,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Image(
                                image: NetworkImage(domi.user.fotoPerfilURL ??
                                    "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png"),
                              ),
                            ),
                          ),
                        ),
                        height: MediaQuery.of(context).size.width * 0.2,
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: kTransparent),
                          borderRadius: kRadiusAll,
                          image: DecorationImage(
                            image: NetworkImage(domi.user.fotoPerfilURL ??
                                "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: MediaQuery.of(context).size.width * 0.2,
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                Center(
                  child: Text(
                    '${domi.user.name}',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 15), color: kWhiteColor),
                  ),
                ),

                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => InfoPersonal(),
                      ),
                    );
                    if (result != null && result == "Cambios guardados") {
                      setState(() {
                        successContainerIsHidden = false;
                        successContainerMessage = "Cambios guardados";
                      });
                      Future.delayed(Duration(seconds: 3)).then((r) {
                        setState(() {
                          successContainerIsHidden = true;
                        });
                      });
                    }
                  },
                  child: Center(
                    child: Text(
                      'Editar perfil',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: kGreenManda2Color),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),

                /// Mandados
                ContainerPerfil(
                  imageRoute1: 'images/mandados.png',
                  text: 'Mandados tomados',
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => MandadosTomados()));
                  },
                ),

                /// Calificaciones
                !domi.user.isDomi
                    ? Container()
                    : ContainerPerfil(
                        imageRoute1: 'images/calificarApp.png',
                        text: 'Calificaciones y reseñas',
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Calificacion()));
                        },
                      ),

                /// Modificar datos
                ContainerPerfil(
                  imageRoute1: 'images/recogido.png',
                  text: domi.user.docsSent != 1
                      ? 'Completar datos colaborador'
                      : 'Modificar datos colaborador',
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Registro(
                            isModificando:
                                domi.user.docsSent != 1 ? true : false),
                      ),
                    );
                  },
                ),

                /// SOPORTE
                ContainerPerfil(
                  imageRoute1: 'images/soporte.png',
                  text: 'Soporte',
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => Soporte()));
                  },
                ),

                /// CONFI
                ContainerPerfil(
                  imageRoute1: 'images/configuracion.png',
                  text: 'Configuración',
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Configuracion(),
                      ),
                    );
                  },
                ),

                Expanded(
                  flex: 8,
                  child: Container(),
                ),
                Text(
                  "v$vLocal.\0",
                  textAlign: TextAlign.left,
                  style: estilo.copyWith(
                    color: kBlackColorOpacity,
                    fontSize: 14,
                  ),
                ),
                isUpdated
                    ? Text(
                        'Última versión',
                        textAlign: TextAlign.left,
                        style: estilo.copyWith(
                          color: kBlackColorOpacity,
                          fontSize: 14,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: _handleDescargaApp,
                            child: Text(
                              'Actualizar app',
                              textAlign: TextAlign.left,
                              style: estilo.copyWith(
                                color: kGreenManda2Color,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleDescargaApp() async {
    await canLaunch(updateURL)
        ? launch(updateURL)
        : showBasicAlert(
            context,
            'No pudimos actualizar el app',
            'Por favor, vuelve a intentar.',
          );
  }

  void _uploadReviewedDomis() async {
    Map<String, dynamic> userMap = {
      "hasReviewedDomis": true,
    };
  }
}
