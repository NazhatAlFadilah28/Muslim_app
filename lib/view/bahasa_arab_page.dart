import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BahasaArabPage extends StatefulWidget {
  const BahasaArabPage({super.key});

  @override
  State<BahasaArabPage> createState() => _BahasaArabPageState();
}

class _BahasaArabPageState extends State<BahasaArabPage> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  int _currentIndex = 0;

  final List<Map<String, String>> _bahasaArabVideos = [
    {
      'title': 'Belajar Bahasa Arab Part 1',
      'videoId': 'bj7T1SfdhMY',
      'description': 'Pembelajaran bahasa arab untuk pemula - Bagian 1',
    },
    {
      'title': 'Belajar Bahasa Arab Part 2',
      'videoId': 'wcJdsxbB1VI',
      'description': 'Pembelajaran bahasa arab untuk pemula - Bagian 2',
    },
    {
      'title': 'Belajar Bahasa Arab Part 3',
      'videoId': '9cms6PN8LGY',
      'description': 'Pembelajaran bahasa arab untuk pemula - Bagian 3',
    },
    {
      'title': 'Belajar Bahasa Arab Part 4',
      'videoId': 'PMTLBS3KylU',
      'description': 'Pembelajaran bahasa arab untuk pemula - Bagian 4',
    },
    {
      'title': 'Belajar Bahasa Arab Part 5',
      'videoId': 'QcplL7ykuJE',
      'description': 'Pembelajaran bahasa arab untuk pemula - Bagian 5',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializePlayer(_bahasaArabVideos[_currentIndex]['videoId']!);
  }

  void _initializePlayer(String videoId) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        enableCaption: false,
      ),
    );
  }

  void _changeVideo(int index) {
    setState(() {
      _currentIndex = index;
    });
    _controller.load(_bahasaArabVideos[index]['videoId']!);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
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
          'Belajar Bahasa Arab',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // YouTube Player with Zoom
          InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0,
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: const Color(0xFF1B7D6F),
                onReady: () {
                  _isPlayerReady = true;
                },
              ),
              onEnterFullScreen: () {},
              onExitFullScreen: () {},
              builder: (context, player) {
                return Column(
                  children: [
                    Container(
                      color: Colors.black,
                      child: AspectRatio(aspectRatio: 16 / 9, child: player),
                    ),
                    // Video Info
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _bahasaArabVideos[_currentIndex]['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _bahasaArabVideos[_currentIndex]['description']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Video List
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Daftar Video',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _bahasaArabVideos.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == _currentIndex;
                        return GestureDetector(
                          onTap: () => _changeVideo(index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1B7D6F)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(
                                            0xFF1B7D6F,
                                          ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      isSelected
                                          ? Icons.play_arrow
                                          : Icons.play_circle_outline,
                                      color: isSelected
                                          ? const Color(0xFF1B7D6F)
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _bahasaArabVideos[index]['title']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _bahasaArabVideos[index]['description']!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isSelected
                                              ? Colors.white70
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
