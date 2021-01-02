class EstadisticaDomi {
  EstadisticaDomi({
    this.domiciliarioId,
    this.nombre,
    this.fecha,
    this.mandados,
    this.efectivo,
    this.tarjeta,
    this.envios,
    this.numeroCuentaBancaria,
    this.fotoPerfilURL,
    this.phoneNumber,
    this.dniNumber,
    this.banco,
    this.tipoCuentaBanco,
    this.dniType,
    this.vehiculo,
  });

  String domiciliarioId;
  String fecha;
  String nombre;
  String phoneNumber;
  String banco;
  String numeroCuentaBancaria;
  String tipoCuentaBanco;
  String dniNumber;
  String dniType;
  int mandados;
  double efectivo;
  double tarjeta;
  int envios;
  String fotoPerfilURL;
  String vehiculo;
}
