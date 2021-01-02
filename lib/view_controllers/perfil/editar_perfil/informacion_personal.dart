import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manda2domis/components/catapulta_scroll_view.dart';
import 'package:manda2domis/components/m2_button.dart';
import 'package:manda2domis/components/m2_editar.dart';
import 'package:manda2domis/components/m2_sin_conexion_container.dart';
import 'package:manda2domis/constants.dart';
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:manda2domis/functions/slide_right_route.dart';
import 'package:provider/provider.dart';
import 'package:manda2domis/internet_connection.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';
import 'package:shimmer/shimmer.dart';

class InfoPersonal extends StatefulWidget {
  @override
  _InfoPersonalState createState() => _InfoPersonalState();
}

class _InfoPersonalState extends State<InfoPersonal> {
  String name;
  String phoneNumber;

  bool isSavingChanges = false;

  Color buttonBackgroundColor = kBlackColorOpacity;
  Color buttonShadowColor = kTransparent;
  Color passwordIconColor = kBlackColor;

  bool fotoChanged = false;
  File newFotoPerfilFile;
  bool deleteProfilePicPending = false;
  bool updateProfilePicPending = false;
  String newFotoPerfilURL;
  ImageProvider imageProvider = NetworkImage(domi.user.fotoPerfilURL);

  @override
  void initState() {
    name = domi.user.name;
    phoneNumber = domi.user.phoneNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool hasConnection = Provider.of<InternetStatus>(context).connected;
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
            )),
        border: Border(
          bottom: BorderSide(
            color: kBlackColor,
            width: 1.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        middle: FittedBox(
          child: Text(
            "Cuenta",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kWhiteColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: CatapultaScrollView(
          child: Column(
            children: <Widget>[
              M2AnimatedContainer(
                height: hasConnection ? 0 : 50,
              ),
              SizedBox(
                height: 45,
              ),
              Center(
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
                              image: imageProvider,
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
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: MediaQuery.of(context).size.width * 0.2,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ],
                ),
              ),
              Center(
                child: CupertinoButton(
                  child: Text(
                    'Cambiar foto de perfil',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: kGreenManda2Color,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                  onPressed: _handleProfilePicture,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              M2Editar(
                titulo: 'Nombre completo',
                initialValue: '${domi.user.name}',
                capitalization: TextCapitalization.words,
                imageRoute: 'images/user.png',
                onChanged: (text) {
                  name = text;
                  setState(() {
                    if ((name != domi.user.name ||
                            phoneNumber != domi.user.phoneNumber ||
                            fotoChanged) &&
                        (name != null &&
                            name != "" &&
                            phoneNumber != null &&
                            phoneNumber != "")) {
                      buttonBackgroundColor = kGreenManda2Color;
                      buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                    } else {
                      buttonBackgroundColor = kBlackColorOpacity;
                      buttonShadowColor = kTransparent;
                    }
                  });
                },
              ),
              M2Editar(
                titulo: 'Celular',
                initialValue: '${domi.user.phoneNumber}',
                imageRoute: 'images/celular.png',
                onChanged: (text) {
                  phoneNumber = text;
                  setState(() {
                    if ((name != domi.user.name ||
                            phoneNumber != domi.user.phoneNumber ||
                            fotoChanged) &&
                        (name != null &&
                            name != "" &&
                            phoneNumber != null &&
                            phoneNumber != "")) {
                      buttonBackgroundColor = kGreenManda2Color;
                      buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                    } else {
                      buttonBackgroundColor = kBlackColorOpacity;
                      buttonShadowColor = kTransparent;
                    }
                  });
                },
              ),
              Expanded(
                child: Container(),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 48),
                child: M2Button(
                  title: "Guardar cambios",
                  isLoading: isSavingChanges,
                  backgroundColor: buttonBackgroundColor,
                  shadowColor: buttonShadowColor,
                  onPressed: () async {
                    if (hasConnection &&
                        buttonBackgroundColor == kGreenManda2Color) {
                      setState(() {
                        isSavingChanges = true;
                      });

                      Map<String, dynamic> userMap = {};
                      if (deleteProfilePicPending) {
                        userMap = {
                          "phoneNumber": phoneNumber,
                          "name": name,
                          "fotoPerfilURL":
                              "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png",
                        };
                        updateUser(userMap);
                      } else if (updateProfilePicPending) {
                        print("⏳ GUARDARÉ FOTO PERFIL");
                        Random random = Random();
                        StorageTaskSnapshot snapshot = await FirebaseStorage
                            .instance
                            .ref()
                            .child(
                                "fotosPerfil/${domi.user.objectId}${random.nextInt(1000000000)}")
                            .putFile(newFotoPerfilFile)
                            .onComplete;

                        if (snapshot.error == null) {
                          print("✔️ FOTO PERFIL GUARDADA");

                          newFotoPerfilURL =
                              await snapshot.ref.getDownloadURL();

                          userMap = {
                            "phoneNumber": phoneNumber,
                            "name": name,
                            "fotoPerfilURL": newFotoPerfilURL,
                          };

                          updateUser(userMap);
                        } else {
                          print(
                              "💩 ERROR AL OBTENER RESPONSE: ${snapshot.error}");
                        }
                      } else {
                        userMap = {
                          "phoneNumber": phoneNumber,
                          "name": name,
                        };
                        updateUser(userMap);
                      }
                    } else {
                      if (name == null || name == "") {
                        showBasicAlert(
                            context, "Por favor, ingresa tu nombre.", "");
                      } else if (phoneNumber == null || phoneNumber == "") {
                        showBasicAlert(
                            context, "Por favor, ingresa tu teléfono.", "");
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateUser(Map<String, dynamic> userMap) {
    print("⏳ ACTUALIZARÉ USER");
    Firestore.instance
        .document("users/${domi.user.objectId}")
        .updateData(userMap)
        .then((r) {
      print("✔️ USER ACTUALIZADO");
      setState(() {
        domi.user.phoneNumber = phoneNumber;
        domi.user.name = name;
        if (deleteProfilePicPending) {
          domi.user.fotoPerfilURL =
              "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png";
        } else if (updateProfilePicPending) {
          domi.user.fotoPerfilURL = newFotoPerfilURL;
        }
        isSavingChanges = false;
      });
      Navigator.pop(context, "Cambios guardados");
    }).catchError((e) {
      print("💩 ERROR AL ACTUALIZAR USER: $e");
      setState(() {
        isSavingChanges = false;
      });
      showBasicAlert(
        context,
        "Hubo un error.",
        "Por favor, intenta más tarde.",
      );
    });
  }

  void pushWithPopAnimation(BuildContext context, Widget widget) {
    Navigator.push(context, SlideRightRoute(page: widget));
  }

  /// Funciones para tomar la nueva foto, eliminarla, y guardarla en la base de datos, también la guarda en shared:
  Future _openCamera() async {
    var img = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    setState(() {
      fotoChanged = true;
      buttonBackgroundColor = kGreenManda2Color;
      buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
      newFotoPerfilFile = img;
      imageProvider = FileImage(newFotoPerfilFile);
      updateProfilePicPending = true;
    });
    Navigator.pop(context);
  }

  Future _openGallery() async {
    var img = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    setState(() {
      fotoChanged = true;
      buttonBackgroundColor = kGreenManda2Color;
      buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
      newFotoPerfilFile = img;
      imageProvider = FileImage(newFotoPerfilFile);
      updateProfilePicPending = true;
    });
    Navigator.pop(context);
  }

  void _handleProfilePicture() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              "Tomar foto",
            ),
            onPressed: _openCamera,
          ),
          CupertinoActionSheetAction(
            child: Text("Seleccionar de galería"),
            onPressed: _openGallery,
          ),
          domi.user.fotoPerfilURL !=
                  "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png"
              ? CupertinoActionSheetAction(
                  child: Text("Eliminar imagen"),
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      deleteProfilePicPending = true;
                      imageProvider = AssetImage("images/fotoPerfil.png");
                      fotoChanged = true;
                      buttonBackgroundColor = kGreenManda2Color;
                      buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                    });
                  },
                )
              : Container(),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Volver"),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, "Volver");
          },
        ),
      ),
    );
  }
}
