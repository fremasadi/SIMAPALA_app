class AppUrl {
  static const String baseUrl = 'https://mapala.underdog.my.id/api';
  static const String imageUrl = 'https://mapala.underdog.my.id/storage';

  // 🧩 Auth Endpoints
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String register = '$baseUrl/register';

  // alat
  static const String alat = '$baseUrl/alats';

  // sewa
  static const String pinjam = '$baseUrl/transaksi/pinjam';

  //kas
  static const String kas = '$baseUrl/kas-bulanan';
  static const String kasOption = '$baseUrl/kas-bulanan/options';
  static const String totalKas = '$baseUrl/kas-bulanan/total/summary';

  //pembayaran kas
  static const String kasPembayaran = '$baseUrl/kas-pembayaran';

  //dana masuk
  static const String danaMasuk = '$baseUrl/dana-masuk';
  static const String danaMasukSummary = '$baseUrl/dana-masuk/summary';

  //dashboard
  static const String dashboard = '$baseUrl/dashboard';

  // profile
  static const String profileImage = '$baseUrl/profile/image';
  static const String changePassword = '$baseUrl/profile/change-password';
}
