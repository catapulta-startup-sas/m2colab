import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'm2_alert.dart';

/// Abre WhatsApp con el número indicado
void launchWhatsApp(BuildContext context, String number) async {
  number.replaceAll("+", "");
  await canLaunch("https://wa.me/$number")
      ? launch("https://wa.me/$number")
      : showBasicAlert(
          context,
          "No pudimos abrir WhatsApp",
          "Por favor, instala WhatsApp e intenta de nuevo.",
        );
}
