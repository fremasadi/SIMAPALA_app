class DashboardModel {
  final DashboardStats stats;
  final List<DashboardAktivitas> aktivitas;

  DashboardModel({required this.stats, required this.aktivitas});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      stats: DashboardStats.fromJson(json['stats']),
      aktivitas: List<DashboardAktivitas>.from(
        json['aktivitas'].map((e) => DashboardAktivitas.fromJson(e)),
      ),
    );
  }
}

class DashboardStats {
  final int dipinjam;
  final int saldoKas;
  final String saldoKasFormatted;

  DashboardStats({
    required this.dipinjam,
    required this.saldoKas,
    required this.saldoKasFormatted,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      dipinjam: json['dipinjam'],
      saldoKas: json['saldo_kas'],
      saldoKasFormatted: json['saldo_kas_formatted'],
    );
  }
}

class DashboardAktivitas {
  final int id;
  final String judul;
  final String status;
  final String waktu;

  DashboardAktivitas({
    required this.id,
    required this.judul,
    required this.status,
    required this.waktu,
  });

  factory DashboardAktivitas.fromJson(Map<String, dynamic> json) {
    return DashboardAktivitas(
      id: json['id'],
      judul: json['judul'],
      status: json['status'],
      waktu: json['waktu'],
    );
  }
}
