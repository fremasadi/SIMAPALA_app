import 'kas_pembayaran_model.dart';

class KasBulananOption {
  final int id;
  final String nama;
  final String status;

  KasBulananOption({
    required this.id,
    required this.nama,
    required this.status,
  });

  factory KasBulananOption.fromJson(Map<String, dynamic> json) =>
      KasBulananOption(
        id: json['id'],
        nama: json['nama'],
        status: json['status'],
      );

  void operator [](String other) {}
}

class KasBulanan {
  int id;
  int userId;
  int bulan;
  int tahun;
  int nominal;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  List<Pembayaran> pembayarans;

  KasBulanan({
    required this.id,
    required this.userId,
    required this.bulan,
    required this.tahun,
    required this.nominal,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.pembayarans,
  });

  /// 🔁 FROM JSON
  factory KasBulanan.fromJson(Map<String, dynamic> json) => KasBulanan(
    id: json['id'],
    userId: json['user_id'],
    bulan: json['bulan'],
    tahun: json['tahun'],
    nominal: json['nominal'],
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    pembayarans: json['pembayarans'] != null
        ? List<Pembayaran>.from(
            json['pembayarans'].map((x) => Pembayaran.fromJson(x)),
          )
        : [],
  );

  /// 🔁 TO JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'bulan': bulan,
    'tahun': tahun,
    'nominal': nominal,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'pembayarans': List<dynamic>.from(pembayarans.map((x) => x.toJson())),
  };
}
