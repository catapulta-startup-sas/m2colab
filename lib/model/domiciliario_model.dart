import 'package:manda2domis/model/estadistica_domi_model.dart';
import 'package:manda2domis/model/resena_model.dart';
import 'package:manda2domis/model/user_model.dart';

class Domiciliario {
  User user;
  int numPedidos;
  int cantidadCalificaciones;
  double califPromedio;
  bool hasReviewedDomis;
  String dniNumber;
  String dniType;
  String vehiculo;
  String banco;
  String numeroCuentaBancaria;
  String tipoCuentaBancaria;
  EstadisticaDomi estadisticaParcial;
  EstadisticaDomi estadisticaTotal;
  List<dynamic> resenas;

  Domiciliario({
    this.user,
    this.numPedidos,
    this.cantidadCalificaciones,
    this.califPromedio,
    this.hasReviewedDomis,
    this.dniNumber,
    this.dniType,
    this.vehiculo,
    this.banco,
    this.numeroCuentaBancaria,
    this.tipoCuentaBancaria,
    this.resenas,
  });
}
