class AppUrl {
  static const String baseUrl = 'http://192.168.3.131:8080/api';
  static const String imageUrl = 'http://192.168.3.131:8080/storage';

  // 🧩 Auth Endpoints
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String register = '$baseUrl/register';

  // alat
  static const String alat = '$baseUrl/alats';

  // sewa
  static const String sewa = '$baseUrl/transaksi/pinjam';
}
