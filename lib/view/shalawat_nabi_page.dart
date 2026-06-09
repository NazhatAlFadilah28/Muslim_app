import 'package:flutter/material.dart';

class ShalawatNabiPage extends StatelessWidget {
  const ShalawatNabiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B7D6F),
        foregroundColor: Colors.white,
        title: const Text(
          'Shalawat Nabi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildShalawatCard(
            context,
            'Shalawat Nurul Anwar',
            'Allahumma shalli ala sayyidina Muhammad wa ala ali sayyidina Muhammad',
            'Ya Allah, limpahkanlah rahmat kepada Nabi Muhammad dan keluarga Nabi Muhammad',
          ),
          const SizedBox(height: 12),
          _buildShalawatCard(
            context,
            'Shalawat Ibrahimiyah',
            'Allahumma shalli ala Ibrahim wa ala ali Ibrahim innaka Hamidum Majid',
            'Ya Allah, limpahkanlah rahmat kepada Ibrahim dan keluarga Ibrahim, sesungguhnya Engkau Maha Terpuji lagi Maha Agung',
          ),
          const SizedBox(height: 12),
          _buildShalawatCard(
            context,
            'Shalawat Populer',
            'Shollallohu ala Muhammadin shollallohu alaihi wasallam',
            'Semoga Allah SWT memberikan kesejahteraan kepada Nabi Muhammad',
          ),
          const SizedBox(height: 12),
          _buildShalawatCard(
            context,
            'Shalawat Al-Busiri',
            'Ya Sayyidi ya Rosulallah...',
            'Shalawat panjang dari Imam Busiri yang terkenal dengan khasiatnya',
          ),
        ],
      ),
    );
  }

  Widget _buildShalawatCard(
    BuildContext context,
    String title,
    String arabic,
    String meaning,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B7D6F),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1B7D6F).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              arabic,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B7D6F),
                height: 1.8,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            meaning,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
