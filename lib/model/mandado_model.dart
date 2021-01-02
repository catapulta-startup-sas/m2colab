import 'package:manda2domis/model/user_model.dart';
import 'categoria_model.dart';
import 'lugar_model.dart';

class Mandado {
  String id;
  String identificador;
  Categoria categoria;

  User cliente;

  bool isTomado;
  bool isRecogido;
  bool isEntregado;
  bool isCalificado;
  bool hiddenByColab;

  Lugar origen;
  Lugar destino;

  String descripcion;

  String tipoPago;
  int total;

  DateTime fechaMaxEntrega;

  String fechaMaxEntregaStringFormatted;
  String horaMaxEntregaStringFormatted;

  int cuotas;
  String cardType;
  String lastFourDigits;

  int tomadoDateTimeMSE;
  int recogidoDateTimeMSE;
  int entregadoDateTimeMSE;
  int createdDateTimeMSE;

  Mandado(
      {this.id,
      this.total,
      this.fechaMaxEntrega,
      this.tomadoDateTimeMSE,
      this.recogidoDateTimeMSE,
      this.entregadoDateTimeMSE,
      this.createdDateTimeMSE,
      this.cliente,
      this.isCalificado,
      this.descripcion,
      this.tipoPago,
      this.fechaMaxEntregaStringFormatted,
      this.horaMaxEntregaStringFormatted,
      this.isEntregado,
      this.isTomado,
      this.cardType,
      this.cuotas,
      this.lastFourDigits,
      this.categoria,
      this.destino,
      this.identificador,
      this.isRecogido,
      this.origen,
      this.hiddenByColab});
}
