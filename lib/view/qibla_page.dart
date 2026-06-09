import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  // Kaaba coordinates
  static const double _kaabaLatitude = 21.4225;
  static const double _kaabaLongitude = 39.8262;

  double? _currentLatitude;
  double? _currentLongitude;
  double? _qiblaDirection;
  bool _isLoading = true;
  String _errorMessage = '';
  double _deviceHeading = 0;
  bool _hasCompass = false;

  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  double _smoothedHeading = 0;
  List<double> _headingBuffer = [];
  static const int _bufferSize = 10;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _initMagnetometer();
  }

  void _initMagnetometer() {
    _magnetometerSubscription = magnetometerEventStream().listen((
      MagnetometerEvent event,
    ) {
      // Calculate heading from magnetometer data
      double heading = math.atan2(event.y, event.x) * 180 / math.pi;

      // Normalize heading to 0-360
      heading = (heading + 360) % 360;

      // Add to buffer for smoothing
      _headingBuffer.add(heading);
      if (_headingBuffer.length > _bufferSize) {
        _headingBuffer.removeAt(0);
      }

      // Calculate smoothed heading
      double sumX = 0;
      double sumY = 0;
      for (double h in _headingBuffer) {
        double rad = h * math.pi / 180;
        sumX += math.cos(rad);
        sumY += math.sin(rad);
      }
      _smoothedHeading = math.atan2(sumY, sumX) * 180 / math.pi;
      _smoothedHeading = (_smoothedHeading + 360) % 360;

      setState(() {
        _deviceHeading = _smoothedHeading;
        _hasCompass = true;
      });
    });
  }

  @override
  void dispose() {
    _magnetometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Izin lokasi ditolak';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Izin lokasi dinonaktifkan permanen';
          _isLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Calculate Qibla direction
      double qibla = _calculateQiblaDirection(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
        _qiblaDirection = qibla;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mendapatkan lokasi: $e';
        _isLoading = false;
      });
    }
  }

  double _calculateQiblaDirection(double lat, double lon) {
    double dLon = _kaabaLongitude - lon;
    double dLat = _kaabaLatitude - lat;

    double y = math.sin(dLon * math.pi / 180);
    double x =
        math.cos(lat * math.pi / 180) *
            math.tan(_kaabaLatitude * math.pi / 180) -
        math.sin(lat * math.pi / 180) * math.cos(dLon * math.pi / 180);

    double qibla = math.atan2(y, x) * 180 / math.pi;
    return (qibla + 360) % 360;
  }

  String _getCompassDirection(double heading) {
    if (heading >= 337.5 || heading < 22.5) return 'Utara';
    if (heading >= 22.5 && heading < 67.5) return 'Timur Laut';
    if (heading >= 67.5 && heading < 112.5) return 'Timur';
    if (heading >= 112.5 && heading < 157.5) return 'Tenggara';
    if (heading >= 157.5 && heading < 202.5) return 'Selatan';
    if (heading >= 202.5 && heading < 247.5) return 'Barat Daya';
    if (heading >= 247.5 && heading < 292.5) return 'Barat';
    return 'Barat Laut';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: const Text('Arah Kiblat'),
        backgroundColor: const Color(0xFF1B7D6F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF1B7D6F)),
                  SizedBox(height: 16),
                  Text('Mendapatkan lokasi...'),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = '';
                        });
                        _initializeLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B7D6F),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Compass Display
                    Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF1B7D6F,
                            ).withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Compass Circle
                          CustomPaint(
                            size: const Size(280, 280),
                            painter: CompassPainter(
                              qiblaDirection: _qiblaDirection ?? 0,
                              currentHeading: _deviceHeading,
                            ),
                          ),
                          // Center Info
                          Positioned(
                            bottom: 40,
                            child: Column(
                              children: [
                                Text(
                                  '${_deviceHeading.toStringAsFixed(0)}°',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B7D6F),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getCompassDirection(_deviceHeading),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Hint
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.screen_rotation,
                            color: Colors.blue,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Gerakkan perangkat untuk mengikuti arah kiblat',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Qibla Info Card
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B7D6F), Color(0xFF2E8B57)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF1B7D6F,
                            ).withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Informasi Kiblat',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow(
                            'Arah Kiblat',
                            '${_qiblaDirection?.toStringAsFixed(1)}°',
                            Icons.explore,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'Lokasi Anda',
                            _currentLatitude != null
                                ? '${_currentLatitude?.toStringAsFixed(4)}, ${_currentLongitude?.toStringAsFixed(4)}'
                                : '-',
                            Icons.my_location,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'Status',
                            _hasCompass ? 'Aktif' : 'Gunakan tombol di atas',
                            Icons.check_circle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Custom Compass Painter
class CompassPainter extends CustomPainter {
  final double qiblaDirection;
  final double currentHeading;

  CompassPainter({required this.qiblaDirection, required this.currentHeading});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Draw outer circle
    final outerCirclePaint = Paint()
      ..color = const Color(0xFF1B7D6F).withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius + 10, outerCirclePaint);

    // Draw compass circle
    final circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, circlePaint);

    // Draw border
    final borderPaint = Paint()
      ..color = const Color(0xFF1B7D6F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, borderPaint);

    // Draw direction markers
    final markerPaint = Paint()
      ..color = const Color(0xFF1B7D6F)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Draw cardinal directions
    _drawText(
      canvas,
      'U',
      center.dx,
      center.dy - radius + 25,
      const Color(0xFF1B7D6F),
      16,
      FontWeight.bold,
    );
    _drawText(
      canvas,
      'S',
      center.dx,
      center.dy + radius - 15,
      Colors.grey,
      14,
      FontWeight.normal,
    );
    _drawText(
      canvas,
      'T',
      center.dx + radius - 15,
      center.dy,
      Colors.grey,
      14,
      FontWeight.normal,
    );
    _drawText(
      canvas,
      'B',
      center.dx - radius + 15,
      center.dy,
      Colors.grey,
      14,
      FontWeight.normal,
    );

    // Draw tick marks
    for (int i = 0; i < 360; i += 15) {
      double tickLength = 10;
      if (i % 90 == 0) tickLength = 15;

      double angle = i * math.pi / 180;
      Offset start = Offset(
        center.dx + (radius - tickLength) * math.sin(angle),
        center.dy - (radius - tickLength) * math.cos(angle),
      );
      Offset end = Offset(
        center.dx + radius * math.sin(angle),
        center.dy - radius * math.cos(angle),
      );

      markerPaint.strokeWidth = i % 90 == 0 ? 3 : 1;
      canvas.drawLine(start, end, markerPaint);
    }

    // Draw Qibla indicator arrow (rotates based on qibla direction)
    final arrowPaint = Paint()
      ..color = const Color(0xFFE91E63)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-qiblaDirection * math.pi / 180);
    canvas.translate(-center.dx, -center.dy);

    Path arrowPath = Path();
    arrowPath.moveTo(center.dx, center.dy - radius + 35);
    arrowPath.lineTo(center.dx - 12, center.dy - radius + 55);
    arrowPath.lineTo(center.dx + 12, center.dy - radius + 55);
    arrowPath.close();
    canvas.drawPath(arrowPath, arrowPaint);
    canvas.restore();

    _drawText(
      canvas,
      'KIBLAT',
      center.dx,
      center.dy - radius + 75,
      const Color(0xFFE91E63),
      12,
      FontWeight.bold,
    );

    // Draw center dot
    final centerDotPaint = Paint()
      ..color = const Color(0xFF1B7D6F)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8, centerDotPaint);

    // Save canvas state for needle rotation
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-currentHeading * math.pi / 180);
    canvas.translate(-center.dx, -center.dy);

    // Draw compass needle
    final needlePaint = Paint()..style = PaintingStyle.fill;

    // North needle (red)
    needlePaint.color = const Color(0xFFE91E63);
    Path northNeedle = Path();
    northNeedle.moveTo(center.dx, center.dy - 60);
    northNeedle.lineTo(center.dx - 8, center.dy);
    northNeedle.lineTo(center.dx + 8, center.dy);
    northNeedle.close();
    canvas.drawPath(northNeedle, needlePaint);

    // South needle (grey)
    needlePaint.color = Colors.grey.shade400;
    Path southNeedle = Path();
    southNeedle.moveTo(center.dx, center.dy + 60);
    southNeedle.lineTo(center.dx - 8, center.dy);
    southNeedle.lineTo(center.dx + 8, center.dy);
    southNeedle.close();
    canvas.drawPath(southNeedle, needlePaint);

    canvas.restore();
  }

  void _drawText(
    Canvas canvas,
    String text,
    double x,
    double y,
    Color color,
    double fontSize,
    FontWeight fontWeight,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CompassPainter oldDelegate) {
    return oldDelegate.currentHeading != currentHeading ||
        oldDelegate.qiblaDirection != qiblaDirection;
  }
}
