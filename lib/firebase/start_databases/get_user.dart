import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manda2domis/model/domiciliario_model.dart';
import 'package:manda2domis/model/user_model.dart';

Domiciliario domi = Domiciliario(user: User());

Future<void> getUser(FirebaseUser firebaseUser) async {
  Firestore.instance
      .document("users/${firebaseUser?.uid}")
      .get()
      .then((userDoc) {
    domi.user.docsSent = userDoc.data["roles.estadoRegistroDomi"] ?? 0;
    if (domi.user.docsSent == 0) {
      // No ha enviado documentos para ser domi
      domi.user.objectId = userDoc.documentID;
      domi.user.name = userDoc.data["name"];
      domi.hasReviewedDomis = userDoc.data['hasReviewedDomis'];
      domi.user.email = userDoc.data['email'];
      domi.user.phoneNumber = userDoc.data['phoneNumber'];
      domi.user.fotoPerfilURL = userDoc.data['fotoPerfilURL'];
      domi.user.isDomi = userDoc.data["roles.isDomi"];
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
        domi.califPromedio = domiDoc.data["calificaciones"]['promedio'];
        domi.vehiculo = domiDoc.data['vehiculo'];
        domi.dniType = domiDoc.data["dni"]['tipo'];
        domi.dniNumber = domiDoc.data["dni"]['numero'];
        domi.banco = domiDoc.data["cuentaBancaria"]['banco'];
        domi.tipoCuentaBancaria = domiDoc.data["cuentaBancaria"]['tipo'];
        domi.numeroCuentaBancaria = domiDoc.data["cuentaBancaria"]['numero'];
      });
    }

    print("✔️ DOMI DESCARGADO");
  }).catchError((e) {
    print("💩 ERROR AL OBTENER DOMI: $e");
  });
}
