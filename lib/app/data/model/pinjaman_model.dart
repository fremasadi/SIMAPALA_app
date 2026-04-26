import 'alat_model.dart';

class Pinjaman {
  int id;
  String? jenisTransaksi;
  String? tanggalAjuan;
  DateTime tanggalPinjam;
  DateTime tanggalKembali;
  String status;
  String totalBiaya;
  int? jumlahAlat;
  
  // Detail fields
  Map<String, dynamic>? pembayaran;
  List<DetailPinjamAlat>? alats;

  Pinjaman({
    required this.id,
    this.jenisTransaksi,
    this.tanggalAjuan,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.status,
    required this.totalBiaya,
    this.jumlahAlat,
    this.pembayaran,
    this.alats,
  });

  factory Pinjaman.fromJson(Map<String, dynamic> json) => Pinjaman(
    id: json["id"],
    jenisTransaksi: json['jenis_transaksi'],
    tanggalAjuan: json["tanggal_ajuan"],
    tanggalPinjam: DateTime.parse(json["tanggal_pinjam"]),
    tanggalKembali: DateTime.parse(json["tanggal_kembali"]),
    status: json["status"],
    totalBiaya: json["total_biaya"]?.toString() ?? "0.00",
    jumlahAlat: json["jumlah_alat"],
    pembayaran: json["pembayaran"],
    alats: json["alats"] != null
        ? List<DetailPinjamAlat>.from(
            json["alats"].map((x) => DetailPinjamAlat.fromJson(x)),
          )
        : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "jenis_transaksi": jenisTransaksi,
    "tanggal_ajuan": tanggalAjuan,
    "tanggal_pinjam": tanggalPinjam.toIso8601String(),
    "tanggal_kembali": tanggalKembali.toIso8601String(),
    "status": status,
    "total_biaya": totalBiaya,
    "jumlah_alat": jumlahAlat,
    "pembayaran": pembayaran,
    "alats": alats != null ? List<dynamic>.from(alats!.map((x) => x.toJson())) : null,
  };
}

class DetailPinjamAlat {
  int detailId;
  int alatId;
  String kodeAlat;
  String namaAlat;
  String statusAlat;
  String? kondisiKembali;
  String? dendaTelat;
  String? dendaRusak;
  int totalDenda;

  DetailPinjamAlat({
    required this.detailId,
    required this.alatId,
    required this.kodeAlat,
    required this.namaAlat,
    required this.statusAlat,
    this.kondisiKembali,
    this.dendaTelat,
    this.dendaRusak,
    required this.totalDenda,
  });

  factory DetailPinjamAlat.fromJson(Map<String, dynamic> json) => DetailPinjamAlat(
    detailId: json["detail_id"],
    alatId: json["alat_id"],
    kodeAlat: json["kode_alat"],
    namaAlat: json["nama_alat"],
    statusAlat: json["status_alat"],
    kondisiKembali: json["kondisi_kembali"],
    dendaTelat: json["denda_telat"]?.toString(),
    dendaRusak: json["denda_rusak"]?.toString(),
    totalDenda: json["total_denda"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "detail_id": detailId,
    "alat_id": alatId,
    "kode_alat": kodeAlat,
    "nama_alat": namaAlat,
    "status_alat": statusAlat,
    "kondisi_kembali": kondisiKembali,
    "denda_telat": dendaTelat,
    "denda_rusak": dendaRusak,
    "total_denda": totalDenda,
  };
}
