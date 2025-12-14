import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../style/app_color.dart';
import '../controllers/peminjaman_controller.dart';

// Peminjaman Page
class PeminjamanView extends StatelessWidget {
  const PeminjamanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.secondary,
            AppColor.secondary.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Peminjaman Alat',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_circle,
                      color: AppColor.primary,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildPeminjamanCard(
                    namaAlat: 'Tenda Kapasitas 4 Orang',
                    tanggalPinjam: '10 Des 2024',
                    tanggalKembali: '15 Des 2024',
                    status: 'Dipinjam',
                    statusColor: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildPeminjamanCard(
                    namaAlat: 'Carrier 60L',
                    tanggalPinjam: '8 Des 2024',
                    tanggalKembali: '14 Des 2024',
                    status: 'Dipinjam',
                    statusColor: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildPeminjamanCard(
                    namaAlat: 'Sleeping Bag',
                    tanggalPinjam: '5 Des 2024',
                    tanggalKembali: '10 Des 2024',
                    status: 'Dikembalikan',
                    statusColor: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeminjamanCard({
    required String namaAlat,
    required String tanggalPinjam,
    required String tanggalKembali,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  namaAlat,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: AppColor.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Pinjam: $tanggalPinjam',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.event,
                color: AppColor.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Kembali: $tanggalKembali',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}