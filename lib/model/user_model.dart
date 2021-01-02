class User {
  String objectId;
  String name;
  String phoneNumber;
  String email;
  int docsSent;
  String historial;
  bool isAdmin;
  bool hasReviewedBuyers;
  bool isDomi;
  bool hasCreditCard;
  String favoriteCreditCard;
  int numTarjetas;
  Map userTks;
  int lastPaymentAmount;
  int payCount;
  int numEnvios;
  int numTomados;
  String fotoPerfilURL;
  List<dynamic> dispositivos;

  User({
    this.objectId,
    this.name,
    this.phoneNumber,
    this.numTomados,
    this.email,
    this.docsSent,
    this.historial,
    this.isAdmin,
    this.hasCreditCard,
    this.favoriteCreditCard,
    this.numTarjetas,
    this.userTks,
    this.lastPaymentAmount,
    this.payCount,
    this.numEnvios,
    this.fotoPerfilURL,
    this.dispositivos,
  });
}
