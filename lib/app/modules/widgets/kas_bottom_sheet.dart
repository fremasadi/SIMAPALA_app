import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/model/kas_pembayaran_model.dart';

void showPembayaranListBottomSheet(
  BuildContext context,
  List<Pembayaran> pembayarans,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HANDLE
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const Text(
              'Riwayat Pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: pembayarans.isEmpty
                  ? const Center(child: Text('Belum ada pembayaran'))
                  : ListView.separated(
                      itemCount: pembayarans.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final pembayaran = pembayarans[index];

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: _statusColor(pembayaran.status),
                            child: const Icon(
                              Icons.payments,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            _formatRupiah(pembayaran.nominal),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${(pembayaran.metode ?? 'Midtrans').toUpperCase()} • ${_formatDate(pembayaran.createdAt)}',
                          ),
                          trailing: Text(
                            pembayaran.status,
                            style: TextStyle(
                              color: _statusColor(pembayaran.status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

String _formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy').format(date);
}

String _formatRupiah(int value) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(value);
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'diterima':
    case 'settlement':
    case 'capture':
      return Colors.green;
    case 'menunggu':
    case 'pending':
      return Colors.orange;
    case 'ditolak':
    case 'expire':
    case 'cancel':
    case 'failure':
    case 'deny':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
