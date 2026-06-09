import 'package:flutter/material.dart';
import '../data/static_hadist_data.dart';

class HadistPage extends StatefulWidget {
  const HadistPage({super.key});

  @override
  State<HadistPage> createState() => _HadistPageState();
}

class _HadistPageState extends State<HadistPage> {
  final List<Map<String, String>> _hadists = HadistData.hadists;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredHadists = [];

  @override
  void initState() {
    super.initState();
    _filteredHadists = _hadists;
  }

  void _filterHadists(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHadists = _hadists;
      } else {
        _filteredHadists = _hadists.where((hadist) {
          return hadist['title']!.toLowerCase().contains(query.toLowerCase()) ||
              hadist['category']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B7D6F),
        foregroundColor: Colors.white,
        title: const Text(
          'Kumpulan Hadist Shahih',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF1B7D6F),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterHadists,
                decoration: const InputDecoration(
                  hintText: 'Cari hadist...',
                  icon: Icon(Icons.search, color: Color.fromARGB(255, 35, 151, 134)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          // Category Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _buildCategoryChip('Semua', null),
                _buildCategoryChip('Iman', 'Iman'),
                _buildCategoryChip('Islam', 'Islam'),
                _buildCategoryChip('Ihsan', 'Ihsan'),
                _buildCategoryChip('Akhlak', 'Akhlak'),
                _buildCategoryChip('Sedekah', 'Sedekah'),
                _buildCategoryChip('Sabr', 'Sabr'),
                _buildCategoryChip('Ilmu', 'Ilmu'),
              ],
            ),
          ),
          // Hadist List
          Expanded(
            child: _filteredHadists.isEmpty
                ? const Center(
                    child: Text(
                      'Hadist tidak ditemukan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filteredHadists.length,
                    itemBuilder: (context, index) {
                      final hadist = _filteredHadists[index];
                      return _buildHadistCard(hadist);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String? category) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: false,
        onSelected: (selected) {
          setState(() {
            if (category == null) {
              _filteredHadists = _hadists;
              _searchController.clear();
            } else {
              _filteredHadists = _hadists
                  .where((h) => h['category'] == category)
                  .toList();
            }
          });
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF1B7D6F),
        labelStyle: const TextStyle(
          color: Color(0xFF333333),
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF1B7D6F)),
        ),
      ),
    );
  }

  Widget _buildHadistCard(Map<String, String> hadist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF1B7D6F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.bookmark, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hadist['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    hadist['category']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Arabic Text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              hadist['arabic']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
                height: 1.8,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          // Translation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                hadist['translation']!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF333333),
                  height: 1.5,
                ),
              ),
            ),
          ),
          // Source
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.source,
                  size: 14,
                  color: Color(0xFF1B7D6F),
                ),
                const SizedBox(width: 4),
                Text(
                  hadist['source']!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF1B7D6F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
