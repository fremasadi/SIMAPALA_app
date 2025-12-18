class Alat {
  int id;
  String kodeAlat;
  String namaAlat;
  String status;
  int hargaSewa;
  DateTime createdAt;
  DateTime updatedAt;

  Alat({
    required this.id,
    required this.kodeAlat,
    required this.namaAlat,
    required this.status,
    required this.hargaSewa,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Alat.fromJson(Map<String, dynamic> json) => Alat(
    id: json["id"],
    kodeAlat: json["kode_alat"],
    namaAlat: json["nama_alat"],
    status: json["status"],
    hargaSewa: json["harga_sewa"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kode_alat": kodeAlat,
    "nama_alat": namaAlat,
    "status": status,
    "harga_sewa": hargaSewa,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
