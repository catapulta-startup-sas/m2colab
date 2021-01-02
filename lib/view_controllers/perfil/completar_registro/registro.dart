import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_data_picker/flutter_cupertino_data_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_button.dart';
import 'package:manda2domis/components/m2_datos_entrega_o_recogida.dart';
import 'package:manda2domis/components/m2_text_field_registro.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:manda2domis/model/registro_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';

FormularioRegistro formulario = FormularioRegistro();

class Registro extends StatefulWidget {
  Registro({this.isModificando});
  bool isModificando;

  @override
  _RegistroState createState() => _RegistroState(isModificando: isModificando);
}

class _RegistroState extends State<Registro> {
  _RegistroState({this.isModificando});
  bool isModificando;

  String tipo = '';
  bool isGuardando = false;

  int selectedPosition = 0;
  bool isEditingPicker = false;
  List<String> pickerOptions = [];

  List<String> vehiculosList = <String>[
    "MATT",
    "Scooter",
    "Scooter eléctrico",
    "Bicicleta eléctrica",
    "Moto eléctrica",
    "Carro eléctrico",
    "Metro",
    "Caminando"
  ];

  List<String> bancosList = <String>[
    "BBVA Colombia",
    "Bancambia S.A.",
    "Banco AV Villas",
    "Banco Agrario",
    "Banco Caja Social BCSC SA",
    "Banco Cooperativo Coopcentral",
    "Banco Davivienda SA",
    "Banco Falabella SA",
    "Banco GNB Sudameris",
    "Banco Pichincha",
    "Banco Popular",
    "Banco Procredit Colombia",
    "Banco Santander",
    "Banco Serfinanza",
    "Banco W S.A.",
    "Banco de Bogotá",
    "Banco de Occidente",
    "Bancoldex S.A.",
    "Bancolombia",
    "Bancoomeva",
    "Confiar Cooperativa Financiera",
    "Daviplata",
    "Nequi",
    "Itaú",
    "Itaú antes Corpbanca",
    "Rappipay",
    "Scotiabank Colpatria S.A."
  ];

  List<String> tipoCuentaList = <String>[
    "Ahorros",
    "Corriente",
  ];

  List<String> tipoDocumentoList = <String>[
    "Cédula de ciudadanía",
    "Cédula de extranjería",
    "NIT",
    "Tarjeta de identidad",
    "Pasaporte"
  ];

  Color cardColor = kWhiteColor;
  Color idColor = kWhiteColor;

  MaskTextInputFormatter tkFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    if (isModificando == null) {
      isModificando = false;
    }
    formulario.vehiculo = domi.vehiculo;
    formulario.banco = domi.banco;
    formulario.tipoCuentaBancaria = domi.tipoCuentaBancaria;
    formulario.numeroCuentaBancaria = domi.numeroCuentaBancaria;
    formulario.dniType = domi.dniType;
    formulario.dniNumber = domi.dniNumber;

    if (formulario.numeroCuentaBancaria == null ||
        formulario.numeroCuentaBancaria == '') {
      cardColor = kWhiteColor;
    } else {
      cardColor = kGreenManda2Color;
    }
    if (formulario.dniNumber == null || formulario.dniNumber == '') {
      idColor = kWhiteColor;
    } else {
      idColor = kGreenManda2Color;
    }

    super.initState();
  }

  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Scaffold(
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
                  )),
              backgroundColor: kBlackColor,
              middle: Text(
                isModificando ? "Completar datos" : "Modificar datos",
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
            body: CatapultaScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ///Vehiculo
                  Padding(
                    padding: EdgeInsets.fromLTRB(17, 36, 17, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditingPicker = true;
                          pickerOptions = vehiculosList;
                        });
                      },
                      child: Container(
                        color: kBlackColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TituloSubTitulo(
                              title: 'Vehículo de entrega',
                              text: formulario.vehiculo ?? "No indicado",
                              noInicado: formulario.vehiculo == null,
                            ),
                            Text(
                              formulario.vehiculo != null
                                  ? "Cambiar"
                                  : "Seleccionar",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  color: kGreenManda2Color,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  ///Banco
                  Padding(
                    padding: EdgeInsets.fromLTRB(17, 10, 17, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditingPicker = true;
                          pickerOptions = bancosList;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TituloSubTitulo(
                            title: 'Banco',
                            text: formulario.banco ?? "No indicado",
                            noInicado: formulario.banco == null,
                          ),
                          Text(
                            formulario.banco != null
                                ? "Cambiar"
                                : "Seleccionar",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: kGreenManda2Color,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///Tipo cuenta
                  Padding(
                    padding: EdgeInsets.fromLTRB(17, 10, 17, 16),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditingPicker = true;
                          pickerOptions = tipoCuentaList;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TituloSubTitulo(
                            title: 'Tipo de cuenta',
                            text:
                                formulario.tipoCuentaBancaria ?? "No indicado",
                            noInicado: formulario.tipoCuentaBancaria == null,
                          ),
                          Text(
                            formulario.tipoCuentaBancaria != null
                                ? "Cambiar"
                                : "Seleccionar",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: kGreenManda2Color,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  ///No cuenta
                  Padding(
                    padding: EdgeInsets.only(left: 17),
                    child: Text(
                      'Número de cuenta bancaria',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: kBlackColorOpacity,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  M2TextFielIdAgregarTarjeta(
                    text: "",
                    imageRoute: "images/card.png",
                    keyboardType: TextInputType.number,
                    iconColor: cardColor,
                    initialValue: formulario.numeroCuentaBancaria,
                    onChanged: (text) {
                      setState(() {
                        formulario.numeroCuentaBancaria = text;
                        if (formulario.numeroCuentaBancaria.length > 0) {
                          cardColor = kGreenManda2Color;
                        } else if (formulario.numeroCuentaBancaria == '') {
                          cardColor = kWhiteColor;
                        } else {
                          cardColor = kRedColor;
                        }
                      });
                    },
                  ),

                  ///Tipo documento
                  isModificando
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(17, 10, 17, 16),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditingPicker = true;
                                pickerOptions = tipoDocumentoList;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                TituloSubTitulo(
                                  title: 'Tipo de documento',
                                  text: formulario.dniType ?? "No indicado",
                                  noInicado: formulario.dniType == null,
                                ),
                                Text(
                                  formulario.dniType != null
                                      ? "Cambiar"
                                      : "Seleccionar",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      color: kGreenManda2Color,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),

                  ///No documento
                  isModificando
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
                          child: Text(
                            'Número de documento',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: kBlackColorOpacity,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  isModificando
                      ? M2TextFielIdAgregarTarjeta(
                          text: "",
                          imageRoute: "images/id.png",
                          keyboardType: TextInputType.number,
                          iconColor: idColor,
                          initialValue: formulario.dniNumber,
                          onChanged: (text) {
                            setState(() {
                              formulario.dniNumber = text;
                              if (formulario.dniNumber.length > 0) {
                                idColor = kGreenManda2Color;
                              } else if (formulario.dniNumber == '') {
                                idColor = kWhiteColor;
                              } else {
                                idColor = kRedColor;
                              }
                            });
                          },
                        )
                      : Container(),

                  Expanded(child: Container()),

                  /// Boton
                  Padding(
                    padding: EdgeInsets.fromLTRB(17, 40, 17, 36),
                    child: M2Button(
                      title: isModificando ? "Completar" : "Modificar",
                      width: MediaQuery.of(context).size.width - 34,
                      backgroundColor: (isModificando
                              ? formulario.vehiculo != 'No indicado' &&
                                  formulario.vehiculo != null &&
                                  formulario.banco != "No indicado" &&
                                  formulario.banco != null &&
                                  formulario.numeroCuentaBancaria != "" &&
                                  formulario.numeroCuentaBancaria != null &&
                                  formulario.tipoCuentaBancaria !=
                                      "No indicado" &&
                                  formulario.tipoCuentaBancaria != null &&
                                  formulario.dniType != "No indicado" &&
                                  formulario.dniType != null &&
                                  formulario.dniNumber != null &&
                                  formulario.dniNumber != ''
                              : formulario.vehiculo != 'No indicado' &&
                                  formulario.vehiculo != null &&
                                  formulario.banco != "No indicado" &&
                                  formulario.banco != null &&
                                  formulario.numeroCuentaBancaria != "" &&
                                  formulario.numeroCuentaBancaria != null &&
                                  formulario.tipoCuentaBancaria !=
                                      "No indicado" &&
                                  formulario.tipoCuentaBancaria != null)
                          ? kGreenManda2Color
                          : kBlackColorOpacity,
                      isLoading: isGuardando,
                      onPressed: () {
                        print('Vehículo: ${formulario.vehiculo}');
                        print('Banco: ${formulario.banco}');
                        print(
                            'Tipo de cuenta: ${formulario.tipoCuentaBancaria}');
                        print('noCuenta: ${formulario.numeroCuentaBancaria}');
                        print('Tipo de documento: ${formulario.dniType}');
                        print('Número de documento: ${formulario.dniNumber}');

                        if (isModificando) {
                          if (formulario.vehiculo == null ||
                              formulario.vehiculo == "" ||
                              formulario.vehiculo == 'No indicado') {
                            showBasicAlert(
                                context,
                                "Por favor, ingresa tu vehículo de entrega.",
                                "");
                          } else {
                            if (formulario.banco == null ||
                                formulario.banco == "" ||
                                formulario.banco == "No indicado") {
                              showBasicAlert(
                                  context, "Por favor, ingresa tu banco.", "");
                            } else if (formulario.tipoCuentaBancaria == null ||
                                formulario.tipoCuentaBancaria == "" ||
                                formulario.tipoCuentaBancaria ==
                                    "No indicado") {
                              showBasicAlert(context,
                                  "Por favor, ingresa tu tipo de cuenta.", "");
                            } else if (formulario.numeroCuentaBancaria ==
                                    null ||
                                formulario.numeroCuentaBancaria == "") {
                              showBasicAlert(
                                  context,
                                  "Por favor, ingresa tu número de cuenta.",
                                  "");
                            } else if (formulario.dniType == null ||
                                formulario.dniType == "" ||
                                formulario.dniType == "No indicado") {
                              showBasicAlert(
                                  context,
                                  "Por favor, ingresa tu tipo de documento.",
                                  "");
                            } else if (formulario.dniNumber == null ||
                                formulario.dniNumber == "") {
                              showBasicAlert(
                                  context,
                                  "Por favor, ingresa tu número de documento.",
                                  "");
                            } else {
                              _updateFormularioDomi();
                            }
                          }
                        } else {
                          if (formulario.vehiculo == null ||
                              formulario.vehiculo == "" ||
                              formulario.vehiculo == 'No indicado') {
                            showBasicAlert(
                                context,
                                "Por favor, ingresa tu vehículo de entrega.",
                                "");
                          } else {
                            if (formulario.banco == null ||
                                formulario.banco == "" ||
                                formulario.banco == "No indicado") {
                              showBasicAlert(
                                  context, "Por favor, ingresa tu banco.", "");
                            } else if (formulario.tipoCuentaBancaria == null ||
                                formulario.tipoCuentaBancaria == "" ||
                                formulario.tipoCuentaBancaria ==
                                    "No indicado") {
                              showBasicAlert(context,
                                  "Por favor, ingresa tu tipo de cuenta.", "");
                            } else if (formulario.numeroCuentaBancaria ==
                                    null ||
                                formulario.numeroCuentaBancaria == "") {
                              showBasicAlert(
                                  context,
                                  "Por favor, ingresa tu número de cuenta.",
                                  "");
                            } else {
                              _updateFormularioDomi();
                            }
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isEditingPicker = false;
                selectedPosition = 0;
                pickerOptions = [];
              });
            },
            child: Container(
              height: isEditingPicker ? MediaQuery.of(context).size.height : 0,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          isEditingPicker
              ? Container(
                  color: kColorDeFondo,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditingPicker = false;
                                selectedPosition = 0;
                                pickerOptions = [];
                              });
                            },
                            child: Container(
                              color: kColorDeFondo,
                              padding: EdgeInsets.fromLTRB(17, 17, 17, 0),
                              child: Text(
                                "Cancelar",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color: kWhiteColor.withOpacity(0.6),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (pickerOptions == vehiculosList) {
                                  print("ANTES: ${formulario.vehiculo}");
                                  formulario.vehiculo =
                                      pickerOptions[selectedPosition];
                                  print("DESPUÉS: ${formulario.vehiculo}");
                                } else if (pickerOptions == bancosList) {
                                  formulario.banco =
                                      pickerOptions[selectedPosition];
                                } else if (pickerOptions == tipoCuentaList) {
                                  formulario.tipoCuentaBancaria =
                                      pickerOptions[selectedPosition];
                                } else if (pickerOptions == tipoDocumentoList) {
                                  formulario.dniType =
                                      pickerOptions[selectedPosition];
                                }
                                isEditingPicker = false;
                                selectedPosition = 0;
                                pickerOptions = [];
                              });
                            },
                            child: Container(
                              color: kColorDeFondo,
                              padding: EdgeInsets.fromLTRB(17, 17, 17, 0),
                              child: Text(
                                "Confirmar",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color: kGreenManda2Color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: CupertinoPicker.builder(
                          childCount: pickerOptions.length,
                          onSelectedItemChanged: (position) {
                            setState(() {
                              selectedPosition = position;
                            });
                          },
                          itemBuilder: (context, position) {
                            return Center(
                              child: Text(
                                pickerOptions[position],
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 17,
                                    color: selectedPosition == position
                                        ? kWhiteColor
                                        : kWhiteColor.withOpacity(0.6),
                                    fontWeight: selectedPosition == position
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                          itemExtent: 50,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void _showDataPickerVehiculo() {
    final bool showTitleActions = true;
    DataPicker.showDatePicker(
      context,
      locale: null,
      showTitleActions: showTitleActions,
      datas: [
        "MATT",
        "Scooter",
        "Scooter eléctrico",
        "Bicicleta",
        "Bicicleta eléctrica",
        "Moto eléctrica",
        "Carro eléctrico",
        "Metro",
        "Caminando"
      ],
      onChanged: (data) {},
      onConfirm: (data) {
        setState(() {
          formulario.vehiculo = data;
        });
      },
    );
  }

  void _showDataPickerBanco() {
    final bool showTitleActions = true;
    DataPicker.showDatePicker(
      context,
      locale: null,
      showTitleActions: showTitleActions,
      datas: [
        "BBVA Colombia",
        "Bancambia S.A.",
        "Banco AV Villas",
        "Banco Agrario",
        "Banco Caja Social BCSC SA",
        "Banco Cooperativo Coopcentral",
        "Banco Davivienda SA",
        "Banco Falabella SA",
        "Banco GNB Sudameris",
        "Banco Pichincha",
        "Banco Popular",
        "Banco Procredit Colombia",
        "Banco Santander",
        "Banco Serfinanza",
        "Banco W S.A.",
        "Banco de Bogotá",
        "Banco de Occidente",
        "Bancoldex S.A.",
        "Bancolombia",
        "Bancoomeva",
        "Confiar Cooperativa Financiera",
        "Daviplata",
        "Nequi",
        "Itaú",
        "Itaú antes Corpbanca",
        "Rappipay",
        "Scotiabank Colpatria S.A."
      ],
      onChanged: (data) {},
      onConfirm: (data) {
        setState(() {
          formulario.banco = data;
        });
        print('onConfirm date: $data');
      },
    );
  }

  void _showDataPickerTipoCuenta() {
    final bool showTitleActions = true;
    DataPicker.showDatePicker(
      context,
      locale: null,
      showTitleActions: showTitleActions,
      datas: ["Ahorros", "Corriente"],
      onChanged: (data) {},
      onConfirm: (data) {
        setState(() {
          formulario.tipoCuentaBancaria = data;
        });
        print('onConfirm date: $data');
      },
    );
  }

  void _showDataPickerTipoDocumento() {
    final bool showTitleActions = true;
    DataPicker.showDatePicker(
      context,
      locale: null,
      showTitleActions: showTitleActions,
      datas: [
        "Cédula de ciudadanía",
        "Cédula de extranjería",
        "Tarjeta de identidad",
        "NIT",
        "Pasaporte"
      ],
      onChanged: (data) {},
      onConfirm: (data) {
        setState(() {
          formulario.dniType = data;
        });
        print('onConfirm date: $data');
      },
    );
  }

  void _updateFormularioDomi() async {
    setState(() {
      isGuardando = true;
    });

    Map<String, dynamic> domiMap = {
      "calificaciones": {
        "cantidad": 0,
        "promedio": 0,
      },
      "dni": {
        "numero": formulario.dniNumber,
        "tipo": formulario.dniType,
      },
      "cuentaBancaria": {
        "numero": formulario.numeroCuentaBancaria,
        "banco": formulario.banco,
        "tipo": formulario.tipoCuentaBancaria
      },
      "estadisticaParcial": {
        "mandados": 0,
        "efectivo": 0,
        "envios": 0,
        "tarjeta": 0,
        "fecha": DateTime.now().millisecondsSinceEpoch,
      },
      "estadisticaTotal": {
        "mandados": 0,
        "efectivo": 0,
        "envios": 0,
        "tarjeta": 0,
      },
      "vehiculo": formulario.vehiculo,
    };

    if (domi.user.docsSent == 0) {
      print("⏳ SUBIRÉ DOMI");
      Firestore.instance
          .document("domiciliarios/${domi.user.objectId}")
          .setData(domiMap)
          .then((r) {
        print("✔️ DOMI SUBIDO");

        Map<String, dynamic> userMap = {
          "roles.estadoRegistroDomi": 1,
        };
        print("⏳ ACTUALIZARÉ USER");
        Firestore.instance
            .document("users/${domi.user.objectId}")
            .updateData(userMap)
            .then((r) {
          print("✔️ USER ACTUALIZADO");
          setState(() {
            domi.vehiculo = formulario.vehiculo;
            domi.banco = formulario.banco;
            domi.tipoCuentaBancaria = formulario.tipoCuentaBancaria;
            domi.numeroCuentaBancaria = formulario.numeroCuentaBancaria;
            domi.dniType = formulario.dniType;
            domi.dniNumber = formulario.dniNumber;
            isGuardando = false;
          });
          Navigator.pop(context, 1);
        }).catchError((e) {
          print("💩 ERROR AL ACTUALIZAR USER: $e");
          domi.vehiculo = formulario.vehiculo;
          domi.banco = formulario.banco;
          domi.tipoCuentaBancaria = formulario.tipoCuentaBancaria;
          domi.numeroCuentaBancaria = formulario.numeroCuentaBancaria;
          domi.dniType = formulario.dniType;
          domi.dniNumber = formulario.dniNumber;
          showBasicAlert(
            context,
            "Hubo un error.",
            "Por favor, intente más tarde",
          );
          setState(() {
            isGuardando = false;
          });
        });
      }).catchError((e) {
        print("💩 ERROR AL SUBIR DOMI: $e");
        domi.vehiculo = formulario.vehiculo;
        domi.banco = formulario.banco;
        domi.tipoCuentaBancaria = formulario.tipoCuentaBancaria;
        domi.numeroCuentaBancaria = formulario.numeroCuentaBancaria;
        domi.dniType = formulario.dniType;
        domi.dniNumber = formulario.dniNumber;
        showBasicAlert(
          context,
          "Hubo un error.",
          "Por favor, intente más tarde",
        );
        setState(() {
          isGuardando = false;
        });
      });
    } else {
      print("⏳ SUBIRÉ DOMI");
      Firestore.instance
          .document("domiciliarios/${domi.user.objectId}")
          .updateData(domiMap)
          .then((r) {
        print("✔️ DOMI SUBIDO");

        Map<String, dynamic> userMap = {
          "roles.estadoRegistroDomi": 1,
        };
        print("⏳ ACTUALIZARÉ USER");
        Firestore.instance
            .document("users/${domi.user.objectId}")
            .updateData(userMap)
            .then((r) {
          print("✔️ USER ACTUALIZADO");
          setState(() {
            isGuardando = false;
            domi.vehiculo = formulario.vehiculo;
            domi.banco = formulario.banco;
            domi.tipoCuentaBancaria = formulario.tipoCuentaBancaria;
            domi.numeroCuentaBancaria = formulario.numeroCuentaBancaria;
            domi.dniType = formulario.dniType;
            domi.dniNumber = formulario.dniNumber;
          });
          Navigator.pop(context, 1);
        }).catchError((e) {
          print("💩 ERROR AL ACTUALIZAR USER: $e");
          domi.vehiculo = formulario.vehiculo;
          domi.banco = formulario.banco;
          domi.tipoCuentaBancaria = formulario.tipoCuentaBancaria;
          domi.numeroCuentaBancaria = formulario.numeroCuentaBancaria;
          domi.dniType = formulario.dniType;
          domi.dniNumber = formulario.dniNumber;
          showBasicAlert(
            context,
            "Hubo un error.",
            "Por favor, intente más tarde",
          );
          setState(() {
            isGuardando = false;
          });
        });
      }).catchError((e) {
        print("💩 ERROR AL SUBIR DOMI: $e");
        domi.vehiculo = formulario.vehiculo;
        domi.banco = formulario.banco;
        domi.tipoCuentaBancaria = formulario.tipoCuentaBancaria;
        domi.numeroCuentaBancaria = formulario.numeroCuentaBancaria;
        domi.dniType = formulario.dniType;
        domi.dniNumber = formulario.dniNumber;
        showBasicAlert(
          context,
          "Hubo un error.",
          "Por favor, intente más tarde",
        );
        setState(() {
          isGuardando = false;
        });
      });
    }
  }
}
