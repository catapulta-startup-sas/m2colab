import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:manda2domis/firebase/start_databases/get_user.dart';
import 'package:http/http.dart' as http;

class PushNotification {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _notificationsStream =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get mensaje => _notificationsStream.stream;

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token) {
      if (domi.user.dispositivos.isEmpty ||
          !domi.user.dispositivos.contains(token)) {
        print("ASIGNARÉ TOKEN A USER");
        assignTokenToUser(token, domi.user.objectId);
      } else {
        print("✔️ TOKEN IDENTIFICADO");
      }
    }).catchError((e) {
      print("ERROR AL OBTENER TOKEN: $e");
    });

    _firebaseMessaging.configure(
      onMessage: (data) {
        print("ON MESSAGE: $data");
        _notificationsStream.sink.add({});
      },
      onResume: (data) {
        print("ON RESUME: $data");
        _notificationsStream.sink.add({});
      },
      onLaunch: (data) {
        print("ON LAUNCH: $data");
        _notificationsStream.sink.add({});
      },
    );
  }

  assignTokenToUser(String token, String userId) {
    Map<String, dynamic> userMap = {
      "dispositivos": FieldValue.arrayUnion([token])
    };
    Firestore.instance
        .document("users/$userId")
        .updateData(userMap)
        .then((value) {
      domi.user.dispositivos.add(token);
      print("✔️ TOKEN ASIGNADO");
      _firebaseMessaging.subscribeToTopic("Colaborador").then((r) {
        print("✔️ SUSCRITO AL TOPIC");
      }).catchError((e) {
        print("ERROR AL SUSCRIBIR AL TOPIC: $e");
      });
    }).catchError((e) {
      print("ERROR AL ASIGNAR TOKEN: $e");
    });
  }

  dispose() {
    _notificationsStream?.close();
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    final String serverToken =
        "AAAAXT7rgtM:APA91bGWyeM45QExf2z-EnMeNlwg9AfRxF6HXxSfmnfwkv3cSaI7UmW_i2yiXXwdpo6ppLFxNz-q5tnBMzb__eOgnHvK0ol1hJkfv97kvvSyYxQmIRlBTTta27enco54qigJcV4XCE6K";

    await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
        provisional: false,
      ),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Hay un nuevo mandado disponible para ti.',
            'title': 'Mandado disponible'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': await _firebaseMessaging.getToken(),
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }
}
