class Pembayaran {
  int id;
  int kasBulananId;
  int userId;
  int nominal;
  String metode;
  dynamic buktiBayar;
  String status;
  DateTime tanggalBayar;
  String keterangan;
  dynamic verifiedBy;
  dynamic verifiedAt;
  DateTime createdAt;
  DateTime updatedAt;

  Pembayaran({
    required this.id,
    required this.kasBulananId,
    required this.userId,
    required this.nominal,
    required this.metode,
    required this.buktiBayar,
    required this.status,
    required this.tanggalBayar,
    required this.keterangan,
    required this.verifiedBy,
    required this.verifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 🔁 FROM JSON
  factory Pembayaran.fromJson(Map<String, dynamic> json) => Pembayaran(
    id: json['id'],
    kasBulananId: int.parse(json['kas_bulanan_id'].toString()),
    userId: int.parse(json['user_id'].toString()),
    nominal: json['nominal'],
    metode: json['metode'],
    buktiBayar: json['bukti_bayar'],
    status: json['status'],
    tanggalBayar: DateTime.parse(json['tanggal_bayar']),
    keterangan: json['keterangan'] ?? '',
    verifiedBy: json['verified_by'],
    verifiedAt: json['verified_at'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  /// 🔁 TO JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'kas_bulanan_id': kasBulananId,
    'user_id': userId,
    'nominal': nominal,
    'metode': metode,
    'bukti_bayar': buktiBayar,
    'status': status,
    'tanggal_bayar': tanggalBayar.toIso8601String(),
    'keterangan': keterangan,
    'verified_by': verifiedBy,
    'verified_at': verifiedAt,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
