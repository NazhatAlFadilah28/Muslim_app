import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key});

  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  int _count = 0;
  int _targetCount = 33;
  String _currentDhikr = 'Subhanallah';
  bool _isVibrating = false;
  bool _isCustomTarget = false;
  final TextEditingController _customTargetController = TextEditingController();

  // List of common dhikr
  final List<Map<String, dynamic>> _dhikrList = [
    {
      'text': 'Subhanallah',
      'arabic': 'سُبْحَانَ الله',
      'meaning': 'Maha Suci Allah',
      'target': 33,
    },
    {
      'text': 'Al hamdulillah',
      'arabic': 'الْحَمْدُ لِله',
      'meaning': 'Segala puji bagi Allah',
      'target': 33,
    },
    {
      'text': 'La ilaha illallah',
      'arabic': 'لَا إِلَهَ إِلَّا الله',
      'meaning': 'Tiada Tuhan selain Allah',
      'target': 100,
    },
    {
      'text': 'Allahu Akbar',
      'arabic': 'اللهُ أَكْبَرُ',
      'meaning': 'Allah Maha Besar',
      'target': 34,
    },
    {
      'text': 'Astaghfirullah',
      'arabic': 'أَسْتَغْفِرُ الله',
      'meaning': 'Aku memohon ampunan Allah',
      'target': 100,
    },
    {
      'text': 'Ya Rahman',
      'arabic': 'يَا رَحْمَنُ',
      'meaning': 'Wahai Yang Maha Pemurah',
      'target': 100,
    },
  ];

  void _incrementCount() {
    HapticFeedback.lightImpact();
    setState(() {
      _count++;
    });

    if (_count >= _targetCount && !_isVibrating) {
      _isVibrating = true;
      HapticFeedback.heavyImpact();
      _showCompletionDialog();
    }
  }

  void _resetCount() {
    setState(() {
      _count = 0;
      _isVibrating = false;
    });
    HapticFeedback.mediumImpact();
  }

  void _changeDhikr(Map<String, dynamic> dhikr) {
    setState(() {
      _currentDhikr = dhikr['text'];
      _targetCount = dhikr['target'];
      _count = 0;
      _isVibrating = false;
      _isCustomTarget = false;
      _customTargetController.clear();
    });
    HapticFeedback.mediumImpact();
  }

  void _setCustomTarget() {
    final customTarget = int.tryParse(_customTargetController.text);
    if (customTarget != null && customTarget > 0) {
      setState(() {
        _targetCount = customTarget;
        _count = 0;
        _isVibrating = false;
        _isCustomTarget = true;
      });
      HapticFeedback.mediumImpact();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan angka yang valid')),
      );
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B7D6F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text(
              'Mashallah!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Anda telah menyelesaikan $_targetCount kali $_currentDhikr',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetCount();
            },
            child: const Text('Ulangi', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetCount();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text(
              'Selesai',
              style: TextStyle(color: Color(0xFF1B7D6F)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customTargetController.dispose();
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
          'Tasbih Digital',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Dhikr Selector
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _dhikrList.length + 1, // +1 for custom
              itemBuilder: (context, index) {
                if (index == _dhikrList.length) {
                  // Custom target option
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCustomTarget = true;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _isCustomTarget
                            ? const Color(0xFF8B5CF6)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isCustomTarget
                              ? const Color(0xFF8B5CF6)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit,
                              size: 14,
                              color: _isCustomTarget
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Custom',
                              style: TextStyle(
                                color: _isCustomTarget
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: _isCustomTarget
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final dhikr = _dhikrList[index];
                final isSelected =
                    _currentDhikr == dhikr['text'] && !_isCustomTarget;
                return GestureDetector(
                  onTap: () => _changeDhikr(dhikr),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1B7D6F)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1B7D6F)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        dhikr['text'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Custom Target Input
          if (_isCustomTarget)
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text(
                    'Target:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _customTargetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan target...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _setCustomTarget,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text(
                      'Set',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Main Counter Area
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Arabic Text
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _isCustomTarget
                            ? _currentDhikr
                            : (_dhikrList.firstWhere(
                                (d) => d['text'] == _currentDhikr,
                              )['arabic']),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B7D6F),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isCustomTarget
                            ? 'Dzikir Custom'
                            : (_dhikrList.firstWhere(
                                (d) => d['text'] == _currentDhikr,
                              )['meaning']),
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Counter Circle Button
                GestureDetector(
                  onTap: _incrementCount,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1B7D6F), Color(0xFF2E8B57)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1B7D6F).withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_count',
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Target: $_targetCount',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Progress Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _targetCount > 0 ? _count / _targetCount : 0,
                          minHeight: 10,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF1B7D6F),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _targetCount > 0
                            ? '${((_count / _targetCount) * 100).toInt()}%'
                            : '0%',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Reset Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _resetCount,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1B7D6F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
