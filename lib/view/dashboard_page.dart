import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/hijri_calendar_view_model.dart';
import '../viewmodel/location_view_model.dart';
import 'shalat_page.dart';
import 'al-quraan_page.dart';
import 'tasbih_page.dart';
import 'doa_page.dart';
import 'qibla_page.dart';
import 'asmaul_husna_page.dart';
import 'ceramah_page.dart';
import 'hadist_page.dart';
import 'jurnal_ramadhan_page.dart';
import 'bahasa_arab_page.dart';
import 'shalawat_nabi_page.dart';

class DashboardPage extends StatefulWidget {
  final String? userName;

  const DashboardPage({super.key, this.userName});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HijriCalendarViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFE8F5E9),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      icon: const Icon(Icons.menu, color: Color(0xFF1B7D6F)),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B7D6F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.mosque,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName != null
                                ? 'Halo, ${widget.userName}'
                                : 'Assalamu\'alaikum',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const Text(
                            'Muslim App',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B7D6F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Greeting Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B7D6F), Color(0xFF2E8B57)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assalamu\'alaikum',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Semoga hari Anda diberkahi',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // GPS Clock Card
                _buildGPSClockCard(context),
                const SizedBox(height: 20),

                // Hijri Calendar Card
                _buildHijriCalendarCard(context),
                const SizedBox(height: 20),

                // Prayer Times Card
                _buildPrayerTimesCard(),
                const SizedBox(height: 20),

                // Menu Title
                const Text(
                  'Menu Utama',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),

                // Menu Cards
                SizedBox(
                  height: 280,
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.85,
                    children: [
                      _buildMenuCard(
                        context,
                        'Jadwal Shalat',
                        'Waktu solat hari ini',
                        const Color(0xFF1B7D6F),
                        Icons.schedule,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ShalatPage()),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        'Al-Quran',
                        'Baca & tafsir Quran',
                        const Color(0xFF6366F1),
                        Icons.menu_book,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AlQuranPage(),
                          ),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        'Tasbih',
                        'Dzikir & hitungan',
                        const Color(0xFF8B5CF6),
                        Icons.track_changes,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TasbihPage()),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        'Doa Harian',
                        'Kumpulan doa islam',
                        const Color(0xFFE91E63),
                        Icons.auto_stories,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DoaPage()),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        'Arah Kiblat',
                        'Indicator kiblat',
                        const Color(0xFFFF9800),
                        Icons.explore,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const QiblaPage()),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        'Asmaul Husna',
                        '99 nama Allah',
                        const Color(0xFF9C27B0),
                        Icons.star,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AsmaulHusnaPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Additional Menu Title
                const Text(
                  'Menu Tambahan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),

                // Additional Menu Cards
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildAdditionalMenuCard(
                        context,
                        'Ceramah',
                        'Khotbah Ustadz',
                        const Color(0xFF1B7D6F),
                        Icons.record_voice_over,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CeramahPage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildAdditionalMenuCard(
                        context,
                        'Hadist',
                        'Hadist Nabi',
                        const Color(0xFF1B7D6F),
                        Icons.menu_book_rounded,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HadistPage()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildAdditionalMenuCard(
                        context,
                        'Shalawat Nabi',
                        'Kumpulan Shalawat',
                        const Color(0xFF9C27B0),
                        Icons.favorite,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ShalawatNabiPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const JurnalRamadhanPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CeramahPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HadistPage()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BahasaArabPage()),
              );
              break;
            case 5:
              _scaffoldKey.currentState?.openDrawer();
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1B7D6F),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        iconSize: 22,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Jurnal Ramadhan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.record_voice_over),
            label: 'Ceramah',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Hadist'),
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: 'Bahasa Arab',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Lainnya'),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(icon, size: 24, color: color)),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 8, color: Colors.grey[600]),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(icon, size: 24, color: color)),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 9, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature akan segera hadir!'),
        backgroundColor: const Color(0xFF1B7D6F),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildGPSClockCard(BuildContext context) {
    return Consumer<LocationViewModel>(
      builder: (context, vm, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B7D6F), Color(0xFF2E8B57)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B7D6F).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      vm.isLoading ? 'Mendapatkan lokasi...' : vm.locationName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                vm.formattedTime,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                vm.formattedDate,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHijriCalendarCard(BuildContext context) {
    return Consumer<HijriCalendarViewModel>(
      builder: (context, vm, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B7D6F), Color(0xFF2E8B57)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: () => vm.changeMonth(-1),
                  ),
                  Column(
                    children: [
                      Text(
                        vm.getMonthName(vm.selectedMonth),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${vm.selectedYear} H',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: () => vm.changeMonth(1),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Kalender Hijriyah',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Prayer Times Card Widget
  Widget _buildPrayerTimesCard() {
    return Container(
      width: double.infinity,
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
          const Row(
            children: [
              Icon(Icons.schedule, color: Color(0xFF1B7D6F), size: 20),
              SizedBox(width: 8),
              Text(
                'Waktu Shalat Hari Ini',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B7D6F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPrayerTime('Subuh', '04:30'),
              _buildPrayerTime('Dzuhur', '12:00'),
              _buildPrayerTime('Ashar', '15:15'),
              _buildPrayerTime('Maghrib', '18:22'),
              _buildPrayerTime('Isya', '19:35'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTime(String name, String time) {
    return Column(
      children: [
        Text(name, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B7D6F),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1B7D6F)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.mosque, color: Colors.white, size: 48),
                SizedBox(height: 8),
                Text(
                  'Muslim App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Apps for Muslim',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Beranda'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Jadwal Shalat'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShalatPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Al-Quran'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AlQuranPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_stories),
            title: const Text('Doa Harian'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DoaPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Asmaul Husna'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AsmaulHusnaPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
