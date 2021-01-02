import 'package:flutter/cupertino.dart';
import 'package:manda2domis/functions/m2_alert.dart';

void handleSignOutError(BuildContext context) {
  showBasicAlert(
    context,
    "Error desconocido.",
    "Por favor, intenta de nuevo más tarde.",
  );
}
