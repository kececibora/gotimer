import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Uygulama genelinde dik kullanım
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const GoTimerApp());
}

class GoTimerApp extends StatelessWidget {
  const GoTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: Colors.black, brightness: Brightness.light);

    return MaterialApp(
      title: 'EsGo Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontFamily: 'SF Pro Display', fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: Colors.black),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'SF Pro Display', fontWeight: FontWeight.bold, letterSpacing: 1.0),
          displayMedium: TextStyle(fontFamily: 'SF Pro Display', fontWeight: FontWeight.w600, letterSpacing: 0.8),
          bodyLarge: TextStyle(fontFamily: 'SF Pro Text', fontSize: 16),
          bodyMedium: TextStyle(fontFamily: 'SF Pro Text', fontSize: 14),
          labelLarge: TextStyle(fontFamily: 'SF Pro Text', fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      home: const TimeSystemScreen(),
    );
  }
}

// ============ Time System Selection Screen ============
class TimeSystemScreen extends StatelessWidget {
  const TimeSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // scheme değişkeni kullanılmadığı için kaldırdık

    return Scaffold(
      appBar: AppBar(title: Text('EsGo Timer')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Zaman Sistemi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1, fontFamily: 'SF Pro Display'),
            ),
            const SizedBox(height: 32),
            _timeSystemButton(context, 'Byoyomi', 'Japonya • Ana Süre + Her Hamle İçin Ek Süre'),
            const SizedBox(height: 16),
            _timeSystemButton(context, 'Kanada Byoyomi', 'Kanada • Ana Süre + Belirli Hamle Sayısında Ek Süre'),
            const SizedBox(height: 16),
            _timeSystemButton(context, 'Basit Zaman', 'Sadece Toplam Süre'),
            const Spacer(),
            const Text(
              'EsGo • Basit Ve Şık Turnuva Saati',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'SF Pro Text'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _timeSystemButton(BuildContext context, String title, String description) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TimerSettingsScreen(timeSystem: title)));
      },
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12, width: 1),
          boxShadow: [
            BoxShadow(
              // withOpacity deprecated → withValues
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            const Icon(Icons.timer_rounded, color: Colors.black, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'SF Pro Display'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 13, color: Colors.grey[800], fontFamily: 'SF Pro Text'),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 24, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}

// ============ Timer Settings Screen ============
class TimerSettingsScreen extends StatefulWidget {
  final String timeSystem;

  const TimerSettingsScreen({super.key, required this.timeSystem});

  @override
  State<TimerSettingsScreen> createState() => _TimerSettingsScreenState();
}

class _TimerSettingsScreenState extends State<TimerSettingsScreen> {
  late TextEditingController _mainTimeController;
  late TextEditingController _byoyomiController;
  late TextEditingController _byoyomiCountController;

  @override
  void initState() {
    super.initState();
    _mainTimeController = TextEditingController(text: '600'); // 10 Dakika
    _byoyomiController = TextEditingController(text: '30');
    _byoyomiCountController = TextEditingController(text: '3');
  }

  @override
  void dispose() {
    _mainTimeController.dispose();
    _byoyomiController.dispose();
    _byoyomiCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // scheme değişkeni kullanılmadığı için kaldırdık

    return Scaffold(
      appBar: AppBar(title: Text('${widget.timeSystem} Ayarları')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTimeInputField('Ana Süre (Saniye)', _mainTimeController),
            const SizedBox(height: 20),
            if (widget.timeSystem != 'Basit Zaman')
              Column(
                children: [
                  _buildTimeInputField('Byoyomi (Saniye)', _byoyomiController),
                  const SizedBox(height: 20),
                  if (widget.timeSystem == 'Kanada Byoyomi') _buildTimeInputField('Hamle Sayısı', _byoyomiCountController),
                ],
              ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  final mainTime = int.tryParse(_mainTimeController.text) ?? 600;
                  final byoyomi = int.tryParse(_byoyomiController.text) ?? 30;
                  final byoyomiCount = int.tryParse(_byoyomiCountController.text) ?? 3;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimerScreen(timeSystem: widget.timeSystem, mainTime: mainTime, byoyomi: byoyomi, byoyomiCount: byoyomiCount),
                    ),
                  );
                },
                child: const Text(
                  'Başlat',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'SF Pro Text'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'SF Pro Text'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            hintText: 'Değer Girin',
          ),
        ),
      ],
    );
  }
}

// ============ Timer Screen ============
class TimerScreen extends StatefulWidget {
  final String timeSystem;
  final int mainTime;
  final int byoyomi;
  final int byoyomiCount;

  const TimerScreen({super.key, required this.timeSystem, required this.mainTime, required this.byoyomi, required this.byoyomiCount});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  bool _isRunning = false;
  bool _isBlackTurn = true;

  // Siyah Oyuncu
  late int _blackMainTime;
  late int _blackByoyomiRemaining;
  late int _blackByoyomiCount;

  // Beyaz Oyuncu
  late int _whiteMainTime;
  late int _whiteByoyomiRemaining;
  late int _whiteByoyomiCount;

  bool _gameEnded = false;
  String? _winner;

  @override
  void initState() {
    super.initState();

    // Timer Ekranına Girince Yatay Moda Geç
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    _blackMainTime = widget.mainTime;
    _whiteMainTime = widget.mainTime;
    _blackByoyomiRemaining = widget.byoyomi;
    _whiteByoyomiRemaining = widget.byoyomi;
    _blackByoyomiCount = widget.byoyomiCount;
    _whiteByoyomiCount = widget.byoyomiCount;
  }

  @override
  void dispose() {
    _timer?.cancel();

    // Bu Ekrandan Çıkarken Tekrar Dikey Moda Dön
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.dispose();
  }

  void _startTimer() {
    if (_isRunning || _gameEnded) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_isBlackTurn) {
          _tickBlack();
        } else {
          _tickWhite();
        }
      });
    });

    setState(() {
      _isRunning = true;
    });
  }

  void _tickBlack() {
    if (_blackMainTime > 0) {
      _blackMainTime--;
    } else {
      if (widget.timeSystem == 'Basit Zaman') {
        _gameEnded = true;
        _winner = 'Beyaz';
        _timer?.cancel();
        _isRunning = false;
        return;
      }

      if (_blackByoyomiRemaining > 0) {
        _blackByoyomiRemaining--;
      } else if (_blackByoyomiCount > 0) {
        _blackByoyomiCount--;
        _blackByoyomiRemaining = widget.byoyomi;
      } else {
        _gameEnded = true;
        _winner = 'Beyaz';
        _timer?.cancel();
        _isRunning = false;
      }
    }
  }

  void _tickWhite() {
    if (_whiteMainTime > 0) {
      _whiteMainTime--;
    } else {
      if (widget.timeSystem == 'Basit Zaman') {
        _gameEnded = true;
        _winner = 'Siyah';
        _timer?.cancel();
        _isRunning = false;
        return;
      }

      if (_whiteByoyomiRemaining > 0) {
        _whiteByoyomiRemaining--;
      } else if (_whiteByoyomiCount > 0) {
        _whiteByoyomiCount--;
        _whiteByoyomiRemaining = widget.byoyomi;
      } else {
        _gameEnded = true;
        _winner = 'Siyah';
        _timer?.cancel();
        _isRunning = false;
      }
    }
  }

  void _pauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _toggleRunPause() {
    if (_isRunning) {
      _pauseTimer();
    } else {
      _startTimer();
    }
  }

  void _passTurn() {
    if (_gameEnded) return;
    setState(() {
      _isBlackTurn = !_isBlackTurn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_gameEnded) {
      return Scaffold(
        body: Container(
          color: Colors.red,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_winner Kazandı!',
                  style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'SF Pro Display'),
                ),
                const SizedBox(height: 40),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    'Ana Sayfaya Dön',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'SF Pro Text'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentPlayerTime = _isBlackTurn ? _blackMainTime : _whiteMainTime;
    final currentByoyomi = _isBlackTurn ? _blackByoyomiRemaining : _whiteByoyomiRemaining;
    final currentByoyomiCount = _isBlackTurn ? _blackByoyomiCount : _whiteByoyomiCount;

    final backgroundColor = _isBlackTurn ? Colors.black : Colors.white;
    final textColor = _isBlackTurn ? Colors.white : Colors.black;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        // Ekrana Tıklayınca Sıra Değiştir
        onTap: () {
          _passTurn();
        },
        child: Stack(
          children: [
            // Ana Sayaç Görünümü
            Container(
              color: backgroundColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isBlackTurn ? 'Siyah' : 'Beyaz',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400, color: textColor.withValues(alpha: 0.8), letterSpacing: 1, fontFamily: 'SF Pro Text'),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _formatTime(currentPlayerTime),
                      style: TextStyle(fontSize: 110, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'SF Pro Display', letterSpacing: 2),
                    ),
                    const SizedBox(height: 18),
                    if (widget.timeSystem != 'Basit Zaman' && currentPlayerTime == 0)
                      Text(
                        'Byoyomi: ${_formatTime(currentByoyomi)} '
                        '(${currentByoyomiCount}x)',
                        style: TextStyle(fontSize: 24, color: textColor.withValues(alpha: 0.9), fontFamily: 'SF Pro Text'),
                      ),
                  ],
                ),
              ),
            ),

            // Tek Kontrol: Durdur / Devam Et Butonu
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton.extended(
                backgroundColor: textColor,
                foregroundColor: backgroundColor,
                onPressed: _toggleRunPause,
                label: Text(
                  _isRunning ? 'Durdur' : 'Devam Et',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'SF Pro Text'),
                ),
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    if (seconds < 0) seconds = 0;
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }
}
