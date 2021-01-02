import 'package:flutter/cupertino.dart';
import 'package:manda2domis/functions/m2_alert.dart';
import 'package:url_launcher/url_launcher.dart';

llamar(BuildContext context, String phone) async {
  phone.replaceAll("+", "");
  String url = "tel:$phone";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    showBasicAlert(
        context,
        "No es posible llamar al $phone",
        "Por favor, intenta más tarde."
    );
  }
}