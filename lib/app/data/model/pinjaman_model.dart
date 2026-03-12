import 'alat_model.dart';

class Pinjaman {
  int id;
  int userId;
  String jenisTransaksi;
  DateTime tanggalAjuan;
  DateTime tanggalPinjam;
  DateTime tanggalKembali;
  String status;
  String totalBiaya;
  DateTime createdAt;
  DateTime updatedAt;
  List<DetailTransaksi> detailTransaksis;

  Pinjaman({
    required this.id,
    required this.userId,
    required this.jenisTransaksi,
    required this.tanggalAjuan,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.status,
    required this.totalBiaya,
    required this.createdAt,
    required this.updatedAt,
    required this.detailTransaksis,
  });

  factory Pinjaman.fromJson(Map<String, dynamic> json) => Pinjaman(
    id: json["id"],
    userId: int.parse(json["user_id"].toString()),
    jenisTransaksi: json['jenis_transaksi'],
    tanggalAjuan: DateTime.parse(json["tanggal_ajuan"]),
    tanggalPinjam: DateTime.parse(json["tanggal_pinjam"]),
    tanggalKembali: DateTime.parse(json["tanggal_kembali"]),
    status: json["status"],
    totalBiaya: json["total_biaya"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    detailTransaksis: List<DetailTransaksi>.from(
      json["detail_transaksis"].map((x) => DetailTransaksi.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "jenis_transaksi": jenisTransaksi,
    "tanggal_pinjam": tanggalPinjam.toIso8601String(),
    "tanggal_kembali": tanggalKembali.toIso8601String(),
    "status": status,
    "total_biaya": totalBiaya,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "detail_transaksis": List<dynamic>.from(
      detailTransaksis.map((x) => x.toJson()),
    ),
  };
}

class DetailTransaksi {
  int id;
  int transaksiId;
  int alatId;
  dynamic kondisiKembali;
  DateTime createdAt;
  DateTime updatedAt;
  Alat alat;

  DetailTransaksi({
    required this.id,
    required this.transaksiId,
    required this.alatId,
    required this.kondisiKembali,
    required this.createdAt,
    required this.updatedAt,
    required this.alat,
  });

  factory DetailTransaksi.fromJson(Map<String, dynamic> json) =>
      DetailTransaksi(
        id: json["id"],
        transaksiId: int.parse(json["transaksi_id"].toString()),
        alatId: int.parse(json["alat_id"].toString()),
        kondisiKembali: json["kondisi_kembali"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        alat: Alat.fromJson(json["alat"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transaksi_id": transaksiId,
    "alat_id": alatId,
    "kondisi_kembali": kondisiKembali,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "alat": alat.toJson(),
  };
}
