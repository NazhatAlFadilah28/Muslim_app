import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CeramahPage extends StatefulWidget {
  const CeramahPage({super.key});

  @override
  State<CeramahPage> createState() => _CeramahPageState();
}

class _CeramahPageState extends State<CeramahPage> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  // Sample ceramah videos (YouTube video IDs)
  final List<Map<String, String>> _ceramahVideos = [
    {
      'title': 'Khotbah Jumat: Hikmah Ramadan',
      'channel': 'Ustadz Abdul Somad',
      'videoId': 'izYUMrsvVDQ',
      'description': 'Khotbah Jumat tentang hikmah dan faidah bulan Ramadan',
    },
    {
      'title': 'Tausiyah Pagi: Dzikir Pagi',
      'channel': 'Ustadz Hanan Attaki',
      'videoId': 'dQw4w9WgXcQ',
      'description': 'Dzikir dan do\'a pagi hari',
    },
    {
      'title': 'Kajian Kitab: Al-Adzkar',
      'channel': 'Ustadz Yazid Jawas',
      'videoId': '9bZkp7q19f0',
      'description': 'Kajian kitab Al-Adzkar karya Imam Nawawi',
    },
    {
      'title': 'Ceramah Ramadan: Keistimewaan Bulan Suci',
      'channel': 'Ustadz Adi Hidayat',
      'videoId': 'JGwWNGJdvx8',
      'description': 'Penjelasan tentang keistimewaan bulan Ramadan',
    },
    {
      'title': 'Tausiyah Singkat: Sedekah',
      'channel': 'Ustadz Felix Siauw',
      'videoId': 'jNQXAC9IVRw',
      'description': 'Hikmah sedekah dalam kehidupan sehari-hari',
    },
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializePlayer(_ceramahVideos[_currentIndex]['videoId']!);
  }

  void _initializePlayer(String videoId) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        enableCaption: true,
      ),
    );
    _controller.addListener(_listener);
  }

  void _listener() {
    if (_controller.value.playerState == PlayerState.playing &&
        !_isPlayerReady) {
      setState(() {
        _isPlayerReady = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playVideo(int index) {
    setState(() {
      _currentIndex = index;
      _isPlayerReady = false;
    });
    _controller.load(_ceramahVideos[index]['videoId']!);
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B7D6F),
        foregroundColor: Colors.white,
        title: const Text(
          'Ceramah & Khotbah',
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
                            _ceramahVideos[_currentIndex]['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _ceramahVideos[_currentIndex]['channel']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1B7D6F),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _ceramahVideos[_currentIndex]['description']!,
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
                      'Daftar Ceramah',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _ceramahVideos.length,
                      itemBuilder: (context, index) {
                        final video = _ceramahVideos[index];
                        final isSelected = index == _currentIndex;

                        return GestureDetector(
                          onTap: () => _playVideo(index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(
                                      0xFF1B7D6F,
                                    ).withValues(alpha: 0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF1B7D6F)
                                    : Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Thumbnail placeholder
                                Container(
                                  width: 80,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.play_circle_fill,
                                    color: Color(0xFF1B7D6F),
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video['title']!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? const Color(0xFF1B7D6F)
                                              : const Color(0xFF333333),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        video['channel']!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.equalizer,
                                    color: Color(0xFF1B7D6F),
                                    size: 20,
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
