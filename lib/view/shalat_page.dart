import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/shalat_view_model.dart';

class ShalatPage extends StatefulWidget {
  static const routeName = '/shalat';
  const ShalatPage({super.key});

  @override
  State<ShalatPage> createState() => _ShalatPageState();
}

class _ShalatPageState extends State<ShalatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShalatViewModel>().fetchSchedule();
    });
  }

  void _showCitySelector(BuildContext context) {
    final vm = context.read<ShalatViewModel>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Kota',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // GPS button
              ListTile(
                leading: vm.isLoadingLocation
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location, color: Color(0xFF1B7D6F)),
                title: const Text('Gunakan Lokasi GPS'),
                subtitle: Text(vm.currentLocation),
                onTap: vm.isLoadingLocation
                    ? null
                    : () {
                        Navigator.pop(context);
                        vm.getCurrentLocation();
                      },
              ),
              const Divider(),
              const Text(
                'Pilih Kota Manual:',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: vm.availableCities.length,
                  itemBuilder: (context, index) {
                    final city = vm.availableCities[index];
                    final isSelected = vm.currentLocation == city;

                    return ListTile(
                      leading: Icon(
                        Icons.location_city,
                        color: isSelected
                            ? const Color(0xFF1B7D6F)
                            : Colors.grey,
                      ),
                      title: Text(
                        city,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? const Color(0xFF1B7D6F) : null,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Color(0xFF1B7D6F))
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        vm.setCity(city);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShalatViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B7D6F),
        foregroundColor: Colors.white,
        title: const Text(
          'Jadwal Shalat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () => vm.getCurrentLocation(),
            tooltip: 'Cari Lokasi GPS',
          ),
          IconButton(
            icon: const Icon(Icons.location_city),
            onPressed: () => _showCitySelector(context),
            tooltip: 'Pilih Kota',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF1B7D6F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () => _showCitySelector(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        vm.currentLocation,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _getCurrentMonth(),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: Builder(
              builder: (_) {
                if (vm.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1B7D6F)),
                  );
                }

                if (vm.error != null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text('Error: ${vm.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => vm.fetchSchedule(),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (vm.schedules.isEmpty) {
                  return const Center(child: Text('Data kosong'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: vm.schedules.length,
                  itemBuilder: (context, index) {
                    final d = vm.schedules[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B7D6F),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                d['tanggal'] ?? '',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                _PrayerTimeChip('Subuh', d['subuh'] ?? '-'),
                                _PrayerTimeChip('Terbit', d['terbit'] ?? '-'),
                                _PrayerTimeChip('Dhuha', d['dhuha'] ?? '-'),
                                _PrayerTimeChip('Dzuhur', d['dzuhur'] ?? '-'),
                                _PrayerTimeChip('Ashar', d['ashar'] ?? '-'),
                                _PrayerTimeChip('Maghrib', d['maghrib'] ?? '-'),
                                _PrayerTimeChip('Isya', d['isya'] ?? '-'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentMonth() {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final now = DateTime.now();
    return '${months[now.month - 1]} ${now.year}';
  }
}

class _PrayerTimeChip extends StatelessWidget {
  final String label;
  final String time;

  const _PrayerTimeChip(this.label, this.time);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1B7D6F),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            time,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B7D6F),
            ),
          ),
        ],
      ),
    );
  }
}
