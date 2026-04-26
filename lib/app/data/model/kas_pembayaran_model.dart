class Pembayaran {
  int id;
  int kasBulananId;
  int userId;
  int nominal;
  String? metode;
  String? paymentUrl;
  String? orderId;
  String? snapToken;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String? keterangan;

  Pembayaran({
    required this.id,
    required this.kasBulananId,
    required this.userId,
    required this.nominal,
    this.metode,
    this.paymentUrl,
    this.orderId,
    this.snapToken,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.keterangan,
  });

  /// 🔁 FROM JSON
  factory Pembayaran.fromJson(Map<String, dynamic> json) => Pembayaran(
    id: json['id'],
    kasBulananId: int.parse(json['kas_bulanan_id'].toString()),
    userId: int.parse(json['user_id'].toString()),
    nominal: json['nominal'],
    metode: json['metode'],
    paymentUrl: json['payment_url'],
    orderId: json['order_id'],
    snapToken: json['snap_token'],
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    keterangan: json['keterangan'],
  );

  /// 🔁 TO JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'kas_bulanan_id': kasBulananId,
    'user_id': userId,
    'nominal': nominal,
    'metode': metode,
    'payment_url': paymentUrl,
    'order_id': orderId,
    'snap_token': snapToken,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'keterangan': keterangan,
  };
}
