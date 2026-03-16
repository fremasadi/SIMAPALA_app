class DanaMasukUser {
  final int id;
  final String name;

  DanaMasukUser({required this.id, required this.name});

  factory DanaMasukUser.fromJson(Map<String, dynamic> json) => DanaMasukUser(
        id: json['id'],
        name: json['name'],
      );
}

class DanaMasuk {
  final int id;
  final String jenis;
  final String jenisLabel;
  final double nominal;
  final String keterangan;
  final String tanggal;
  final DanaMasukUser? user;
  final String? status;

  DanaMasuk({
    required this.id,
    required this.jenis,
    required this.jenisLabel,
    required this.nominal,
    required this.keterangan,
    required this.tanggal,
    this.user,
    this.status,
  });

  factory DanaMasuk.fromJson(Map<String, dynamic> json) => DanaMasuk(
        id: json['id'],
        jenis: json['jenis'],
        jenisLabel: json['jenis_label'],
        nominal: (json['nominal'] as num).toDouble(),
        keterangan: json['keterangan'] ?? '',
        tanggal: json['tanggal'],
        user: json['user'] != null
            ? DanaMasukUser.fromJson(json['user'])
            : null,
        status: json['status'],
      );
}

class DanaMasukSummaryItem {
  final String jenis;
  final String jenisLabel;
  final double total;
  final int count;

  DanaMasukSummaryItem({
    required this.jenis,
    required this.jenisLabel,
    required this.total,
    required this.count,
  });

  factory DanaMasukSummaryItem.fromJson(Map<String, dynamic> json) =>
      DanaMasukSummaryItem(
        jenis: json['jenis'],
        jenisLabel: json['jenis_label'],
        total: (json['total'] as num).toDouble(),
        count: json['count'],
      );
}
