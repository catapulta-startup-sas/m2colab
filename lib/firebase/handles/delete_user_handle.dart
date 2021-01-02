import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:manda2domis/functions/m2_alert.dart';

void handleDeleteUserError(e, BuildContext context, Function cerrarSesionBack) {
  if (e is PlatformException && e.code == "ERROR_REQUIRES_RECENT_LOGIN") {
    showAlert(
      context: context,
      title: "Advertencia.",
      body:
          "Esta operación es sensible y requiere autenticación reciente. Por favor, inicia sesión de nuevo antes de eliminar tu cuenta.",
      actions: [
        AlertAction(text: "Volver"),
        AlertAction(text: "Cerrar sesión", onPressed: cerrarSesionBack),
      ],
    );
  } else {
    showBasicAlert(
      context,
      "Hubo un error.",
      "Por favor, intenta de nuevo más tarde",
    );
  }
}
