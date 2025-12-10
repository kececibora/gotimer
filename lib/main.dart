// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GoTimerApp());
}

const Color kBgColor = Color(0xFF181920); // Ana arka plan
const Color kCardColor = Color(0xFF22252F); // Kart arka planı
const Color kTextSecondary = Color(0xFFB2B5C3);

// ================== DİL YÖNETİMİ ==================

class AppLanguage {
  static final ValueNotifier<String> notifier = ValueNotifier<String>('tr');

  static String get current => notifier.value;

  static void set(String code) {
    if (AppStrings.supportedLanguages.contains(code)) {
      notifier.value = code;
    }
  }
}

class AppStrings {
  // 5 dil: Türkçe, İngilizce, Japonca, Korece, Çince
  static const supportedLanguages = ['tr', 'en', 'ja', 'ko', 'zh'];

  static const Map<String, Map<String, String>> _values = {
    'tr': {
      'appSubtitle': 'ESGO Maç Saati',
      'timeSystemTitle': 'Zaman Sistemi',
      'byoyomiTitle': 'Byoyomi',
      'byoyomiDesc': 'Ana Süre + Döngü Sayısı x Süre',
      'canadaTitle': 'Kanada Byoyomi',
      'canadaDesc': 'Ana Süre + Süre/Hamle Sayısı',
      'simpleTitle': 'Basit Zaman',
      'simpleDesc': 'Ana Süre (Ek süre yok)',

      'settingsDifferent': 'Farklı Ayar Kullan',
      'settingsBlack': 'Siyah',
      'settingsWhite': 'Beyaz',
      'mainTime': 'Ana Süre',
      'byoyomiTime': 'Byoyomi Süresi',
      'canadaMoveCount': 'Hamle Sayısı (Kanada Byoyomi)',
      'japanByoCount': 'Byoyomi Hakkı (Adet)',
      'btnStart': 'Başlat',

      'dialogPickTime': 'Süre Seç',
      'dialogPick': 'Seç',
      'cancel': 'İptal',
      'ok': 'Tamam',

      'moves': 'Hamle',
      'won': 'Kazandı!',
      'backToHome': 'Ana Sayfaya Dön',

      // Info bottom sheet
      'infoTitle': 'Hakkında',
      'infoSoftware': 'Yazılım:',
      'infoDesign': 'Tasarım:',
      'infoThanks': 'Destekleri için teşekkürler:',
    },
    'en': {
      'appSubtitle': 'ESGO Game Clock',
      'timeSystemTitle': 'Time System',
      'byoyomiTitle': 'Byoyomi',
      'byoyomiDesc': 'Main Time + Cycles x Time',
      'canadaTitle': 'Canadian Byoyomi',
      'canadaDesc': 'Main Time + Time / Moves',
      'simpleTitle': 'Simple Time',
      'simpleDesc': 'Main Time (no extra period)',

      'settingsDifferent': 'Use Different Settings',
      'settingsBlack': 'Black',
      'settingsWhite': 'White',
      'mainTime': 'Main Time',
      'byoyomiTime': 'Byoyomi Time',
      'canadaMoveCount': 'Move Count (Canadian)',
      'japanByoCount': 'Byoyomi Periods',
      'btnStart': 'Start',

      'dialogPickTime': 'Pick Time',
      'dialogPick': 'Pick',
      'cancel': 'Cancel',
      'ok': 'OK',

      'moves': 'Moves',
      'won': 'Won!',
      'backToHome': 'Back to Home',

      'infoTitle': 'About',
      'infoSoftware': 'Software:',
      'infoDesign': 'Design:',
      'infoThanks': 'Special thanks to:',
    },
    'ja': {
      'appSubtitle': 'ESGO 対局時計',
      'timeSystemTitle': '時間設定',
      'byoyomiTitle': '秒読み',
      'byoyomiDesc': '持ち時間 ＋ 秒読み回数 × 秒数',
      'canadaTitle': 'カナダ秒読み',
      'canadaDesc': '持ち時間 ＋ 手数／時間',
      'simpleTitle': '単純時間',
      'simpleDesc': '持ち時間のみ（追加時間なし）',

      'settingsDifferent': '別の設定を使用',
      'settingsBlack': '黒番',
      'settingsWhite': '白番',
      'mainTime': '持ち時間',
      'byoyomiTime': '秒読み時間',
      'canadaMoveCount': '手数（カナダ秒読み）',
      'japanByoCount': '秒読み回数',
      'btnStart': '開始',

      'dialogPickTime': '時間を選択',
      'dialogPick': '選択',
      'cancel': 'キャンセル',
      'ok': 'OK',

      'moves': '手数',
      'won': '勝ち！',
      'backToHome': 'ホームに戻る',

      'infoTitle': '情報',
      'infoSoftware': 'ソフトウェア:',
      'infoDesign': 'デザイン:',
      'infoThanks': 'ご協力ありがとうございます：',
    },
    'ko': {
      'appSubtitle': 'ESGO 대국 시계',
      'timeSystemTitle': '시간 설정',
      'byoyomiTitle': '초읽기',
      'byoyomiDesc': '기본 시간 + 초읽기 횟수 × 시간',
      'canadaTitle': '캐나다 초읽기',
      'canadaDesc': '기본 시간 + 일정 수의 수 / 시간',
      'simpleTitle': '단순 시간',
      'simpleDesc': '기본 시간만 사용 (추가 시간 없음)',

      'settingsDifferent': '흑/백 다른 설정 사용',
      'settingsBlack': '흑',
      'settingsWhite': '백',
      'mainTime': '기본 시간',
      'byoyomiTime': '초읽기 시간',
      'canadaMoveCount': '수(캐나다 초읽기)',
      'japanByoCount': '초읽기 횟수',
      'btnStart': '시작',

      'dialogPickTime': '시간 선택',
      'dialogPick': '선택',
      'cancel': '취소',
      'ok': '확인',

      'moves': '수',
      'won': '승리!',
      'backToHome': '처음 화면으로',

      'infoTitle': '정보',
      'infoSoftware': '소프트웨어:',
      'infoDesign': '디자인:',
      'infoThanks': '도움에 감사드립니다:',
    },
    'zh': {
      'appSubtitle': 'ESGO 对局计时器',
      'timeSystemTitle': '时间设置',
      'byoyomiTitle': '读秒',
      'byoyomiDesc': '基本时间 + 读秒次数 × 秒数',
      'canadaTitle': '加拿大读秒',
      'canadaDesc': '基本时间 + 每若干手用时',
      'simpleTitle': '简单计时',
      'simpleDesc': '只有基本时间（无追加时间）',

      'settingsDifferent': '黑白使用不同设置',
      'settingsBlack': '黑方',
      'settingsWhite': '白方',
      'mainTime': '基本时间',
      'byoyomiTime': '读秒时间',
      'canadaMoveCount': '手数（加拿大读秒）',
      'japanByoCount': '读秒次数',
      'btnStart': '开始',

      'dialogPickTime': '选择时间',
      'dialogPick': '选择',
      'cancel': '取消',
      'ok': '确定',

      'moves': '手数',
      'won': '获胜！',
      'backToHome': '返回首页',

      'infoTitle': '关于',
      'infoSoftware': '软件：',
      'infoDesign': '设计：',
      'infoThanks': '特别感谢：',
    },
  };

  static String t(String lang, String key) {
    final langMap = _values[lang] ?? _values['en']!;
    return langMap[key] ?? _values['en']![key] ?? key;
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton();

  String _label(String code) {
    switch (code) {
      case 'tr':
        return 'TR';
      case 'en':
        return 'EN';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文';
      default:
        return code.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.notifier,
      builder: (context, lang, _) {
        return Container(
          decoration: BoxDecoration(color: kCardColor, borderRadius: BorderRadius.circular(20)),
          child: PopupMenuButton<String>(
            initialValue: lang,
            offset: const Offset(0, 40),
            color: kCardColor,
            onSelected: (code) => AppLanguage.set(code),
            itemBuilder: (context) {
              return AppStrings.supportedLanguages.map((code) {
                return PopupMenuItem<String>(
                  value: code,
                  child: Text(_label(code), style: const TextStyle(color: Colors.white)),
                );
              }).toList();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _label(lang),
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.language_rounded, size: 32, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> _launchExternal(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class _InfoButton extends StatelessWidget {
  final String languageCode;
  const _InfoButton({required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _showInfo(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: kCardColor, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [Icon(Icons.info_outline_rounded, size: 32, color: kTextSecondary)],
        ),
      ),
    );
  }

  void _showInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(999)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.t(languageCode, 'infoTitle'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 16),
              _buildLinkRow(label: AppStrings.t(languageCode, 'infoSoftware'), name: 'rbkececi', url: 'https://www.linkedin.com/in/borakececi/'),
              const SizedBox(height: 10),
              _buildLinkRow(label: AppStrings.t(languageCode, 'infoDesign'), name: 'mkrst', url: 'https://www.linkedin.com/in/m-kursat-elitok/'),
              const SizedBox(height: 16),
              Text(AppStrings.t(languageCode, 'infoThanks'), style: const TextStyle(fontSize: 13, color: kTextSecondary)),
              const SizedBox(height: 8),
              _buildLinkRow(label: '', name: 'Eskişehir Go Oyuncuları Derneği', url: 'https://www.instagram.com/eskisehirgooyunculari/'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLinkRow({required String label, required String name, required String url}) {
    return InkWell(
      onTap: () => _launchExternal(url),
      child: Row(
        children: [
          if (label.isNotEmpty) Text(label, style: const TextStyle(fontSize: 13, color: kTextSecondary)),
          if (label.isNotEmpty) const SizedBox(width: 4),
          Flexible(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14, color: Colors.white, decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.open_in_new_rounded, size: 14, color: kTextSecondary),
        ],
      ),
    );
  }
}

// ================== APP ==================

class GoTimerApp extends StatelessWidget {
  const GoTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark);

    return MaterialApp(
      title: 'EsGo Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: kBgColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: kBgColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.4),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.white),
          displayMedium: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.8, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
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
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.notifier,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: kBgColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Üst: sağda dil seçimi
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: const [_LanguageButton()]),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.t(lang, 'appSubtitle'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: kTextSecondary),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.t(lang, 'timeSystemTitle'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 1, color: Colors.white),
                  ),
                  const SizedBox(height: 32),

                  _timeSystemButton(
                    context,
                    'Byoyomi', // iç mantık için string olduğu gibi kalsın
                    AppStrings.t(lang, 'byoyomiTitle'),
                    AppStrings.t(lang, 'byoyomiDesc'),
                  ),
                  const SizedBox(height: 16),
                  _timeSystemButton(context, 'Kanada Byoyomi', AppStrings.t(lang, 'canadaTitle'), AppStrings.t(lang, 'canadaDesc')),
                  const SizedBox(height: 16),
                  _timeSystemButton(context, 'Basit Zaman', AppStrings.t(lang, 'simpleTitle'), AppStrings.t(lang, 'simpleDesc')),
                  const Spacer(),

                  // Sağ altta info butonu
                  Align(
                    alignment: Alignment.bottomRight,
                    child: _InfoButton(languageCode: lang),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _timeSystemButton(
    BuildContext context,
    String systemId, // TimerSettingsScreen'e giden ID
    String title,
    String description,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TimerSettingsScreen(timeSystem: systemId)));
      },
      child: Ink(
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 18, offset: Offset(0, 8))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            const Icon(Icons.timer_rounded, color: Colors.white, size: 32),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 13, color: kTextSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ Timer Screen ============
class TimerScreen extends StatefulWidget {
  final String timeSystem;

  final int blackMainTime;
  final int whiteMainTime;
  final int blackByoyomi;
  final int whiteByoyomi;
  final int blackByoyomiCount;
  final int whiteByoyomiCount;

  const TimerScreen({
    super.key,
    required this.timeSystem,
    required this.blackMainTime,
    required this.whiteMainTime,
    required this.blackByoyomi,
    required this.whiteByoyomi,
    required this.blackByoyomiCount,
    required this.whiteByoyomiCount,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  bool _isRunning = false;

  bool _isBlackTurn = true;

  // Siyah
  late int _blackMainTime;
  late int _blackByoyomiRemaining;
  late int _blackByoyomiCount;
  int _blackMoves = 0;

  // Beyaz
  late int _whiteMainTime;
  late int _whiteByoyomiRemaining;
  late int _whiteByoyomiCount;
  int _whiteMoves = 0;

  bool _gameEnded = false;
  String? _winner;

  bool _soundOn = true;
  bool _blackTenSecWarned = false;
  bool _whiteTenSecWarned = false;

  bool get _isSimple => widget.timeSystem == 'Basit Zaman';

  @override
  void initState() {
    super.initState();

    _blackMainTime = widget.blackMainTime;
    _whiteMainTime = widget.whiteMainTime;

    _blackByoyomiRemaining = widget.blackByoyomi;
    _whiteByoyomiRemaining = widget.whiteByoyomi;

    _blackByoyomiCount = widget.blackByoyomiCount;
    _whiteByoyomiCount = widget.whiteByoyomiCount;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _playBeep() async {
    await SystemSound.play(SystemSoundType.alert);
  }

  void _createTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_isBlackTurn) {
          _tickBlack();
        } else {
          _tickWhite();
        }
      });
    });
  }

  void _startTimer() {
    if (_isRunning || _gameEnded) return;

    if (_soundOn) {
      _playBeep();
    }

    _createTimer();

    setState(() {
      _isRunning = true;
    });
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

  void _tickBlack() {
    final currentPhaseRemaining = _blackMainTime > 0 ? _blackMainTime : _blackByoyomiRemaining;

    if (_soundOn && !_blackTenSecWarned && currentPhaseRemaining == 10) {
      _playBeep();
      _blackTenSecWarned = true;
    }

    if (_blackMainTime > 0) {
      _blackMainTime--;
    } else {
      if (_isSimple) {
        _gameEnded = true;
        _winner = 'Beyaz';
        _stopGame();
        return;
      }

      if (_blackByoyomiRemaining > 0) {
        _blackByoyomiRemaining--;
      } else if (_blackByoyomiCount > 0) {
        _blackByoyomiCount--;
        _blackByoyomiRemaining = widget.blackByoyomi;
        _blackTenSecWarned = false;
      } else {
        _gameEnded = true;
        _winner = 'Beyaz';
        _stopGame();
      }
    }
  }

  void _tickWhite() {
    final currentPhaseRemaining = _whiteMainTime > 0 ? _whiteMainTime : _whiteByoyomiRemaining;

    if (_soundOn && !_whiteTenSecWarned && currentPhaseRemaining == 10) {
      _playBeep();
      _whiteTenSecWarned = true;
    }

    if (_whiteMainTime > 0) {
      _whiteMainTime--;
    } else {
      if (_isSimple) {
        _gameEnded = true;
        _winner = 'Siyah';
        _stopGame();
        return;
      }

      if (_whiteByoyomiRemaining > 0) {
        _whiteByoyomiRemaining--;
      } else if (_whiteByoyomiCount > 0) {
        _whiteByoyomiCount--;
        _whiteByoyomiRemaining = widget.whiteByoyomi;
        _whiteTenSecWarned = false;
      } else {
        _gameEnded = true;
        _winner = 'Siyah';
        _stopGame();
      }
    }
  }

  void _stopGame() {
    _timer?.cancel();
    _isRunning = false;
  }

  void _passTurn() {
    if (_gameEnded) return;

    if (_isRunning) {
      _timer?.cancel();
    }

    setState(() {
      if (_isBlackTurn) {
        _blackMoves++;
        _blackTenSecWarned = false;
      } else {
        _whiteMoves++;
        _whiteTenSecWarned = false;
      }
      _isBlackTurn = !_isBlackTurn;
    });

    if (_isRunning) {
      _createTimer();
    }
  }

  void _toggleSound() {
    setState(() {
      _soundOn = !_soundOn;
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
                  textAlign: TextAlign.center,
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

    return Scaffold(
      body: Column(
        children: [
          // ÜST: Beyaz
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _passTurn,
              child: _buildPlayerArea(
                isTop: true,
                isBlack: false,
                mainTime: _whiteMainTime,
                byoyomiRemaining: _whiteByoyomiRemaining,
                byoyomiCount: _whiteByoyomiCount,
                initialByo: widget.whiteByoyomi,
                initialCount: widget.whiteByoyomiCount,
                moves: _whiteMoves,
                isActive: _isRunning && !_isBlackTurn,
              ),
            ),
          ),

          _buildControlBar(),

          // ALT: Siyah
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _passTurn,
              child: _buildPlayerArea(
                isTop: false,
                isBlack: true,
                mainTime: _blackMainTime,
                byoyomiRemaining: _blackByoyomiRemaining,
                byoyomiCount: _blackByoyomiCount,
                initialByo: widget.blackByoyomi,
                initialCount: widget.blackByoyomiCount,
                moves: _blackMoves,
                isActive: _isRunning && _isBlackTurn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    const barColor = Color(0xFF202020);

    Widget button(IconData icon, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 72,
          height: 48,
          decoration: BoxDecoration(color: const Color(0xFF303030), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      );
    }

    return Container(
      color: barColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [button(_soundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded, _toggleSound), button(_isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, _toggleRunPause)],
      ),
    );
  }

  Widget _buildPlayerArea({
    required bool isTop,
    required bool isBlack,
    required int mainTime,
    required int byoyomiRemaining,
    required int byoyomiCount,
    required int initialByo,
    required int initialCount,
    required int moves,
    required bool isActive,
  }) {
    const activeColor = Color(0xFFA4D7FF);

    const blackBaseColor = Color(0xFF111111); // siyah için
    const whiteBaseColor = Color(0xFFF4F5FB); // beyaz için

    final Color backgroundColor = isActive ? activeColor : (isBlack ? blackBaseColor : whiteBaseColor);

    final Color textColor = isActive ? const Color(0xFF222222) : (isBlack ? Colors.white : const Color(0xFF111111));

    final currentDisplayTime = mainTime > 0 ? mainTime : byoyomiRemaining;

    String byoyomiInfo = '';
    if (!_isSimple && initialByo > 0 && initialCount > 0) {
      byoyomiInfo = '${initialCount}x$initialByo';
    }

    Widget content = Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SafeArea(
        top: isTop,
        bottom: !isTop,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text('Hamle: $moves', style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.8))),
            ),
            const SizedBox(height: 8),
            Text(
              _formatTime(currentDisplayTime),
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.w800, letterSpacing: 2, color: textColor),
            ),
            if (byoyomiInfo.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                byoyomiInfo,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textColor.withOpacity(0.9)),
              ),
            ],
          ],
        ),
      ),
    );

    if (isTop) {
      content = Transform.rotate(angle: pi, child: content);
    }

    return content;
  }

  String _formatTime(int seconds) {
    if (seconds < 0) seconds = 0;
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
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
  bool _useDifferentSettings = false;

  // --- SİYAH AYARLARI ---
  int _blackMainH = 0;
  int _blackMainM = 15;
  int _blackMainS = 0;

  int _blackByoH = 0;
  int _blackByoM = 0;
  int _blackByoS = 30;

  int _blackByoCount = 3;

  // --- BEYAZ AYARLARI ---
  int _whiteMainH = 0;
  int _whiteMainM = 15;
  int _whiteMainS = 0;

  int _whiteByoH = 0;
  int _whiteByoM = 0;
  int _whiteByoS = 30;

  int _whiteByoCount = 3;

  bool get _isSimple => widget.timeSystem == 'Basit Zaman';
  bool get _isJapan => widget.timeSystem == 'Byoyomi';
  bool get _isCanada => widget.timeSystem == 'Kanada Byoyomi';

  @override
  void initState() {
    super.initState();

    // Japon byoyomi için default 5 adet
    if (_isJapan) {
      _blackByoCount = 5;
      _whiteByoCount = 5;
    } else if (_isCanada) {
      // Kanada için default 25 hamle diyebiliriz (isteğe göre değişir)
      _blackByoCount = 25;
      _whiteByoCount = 25;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.timeSystem} Ayarları')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Siyah / Beyaz farklı ayar
            SwitchListTile(
              value: _useDifferentSettings,
              onChanged: (val) {
                setState(() {
                  _useDifferentSettings = val;
                  if (val) {
                    _whiteMainH = _blackMainH;
                    _whiteMainM = _blackMainM;
                    _whiteMainS = _blackMainS;

                    _whiteByoH = _blackByoH;
                    _whiteByoM = _blackByoM;
                    _whiteByoS = _blackByoS;

                    _whiteByoCount = _blackByoCount;
                  }
                });
              },
              title: const Text(
                'Farklı Ayar Kullan',
                style: TextStyle(fontFamily: 'SF Pro Text', fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            const SizedBox(height: 16),

            if (!_useDifferentSettings)
              _buildCommonBlock()
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Siyah',
                    style: TextStyle(fontFamily: 'SF Pro Display', fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _buildPlayerBlock(
                    mainH: _blackMainH,
                    mainM: _blackMainM,
                    mainS: _blackMainS,
                    byoH: _blackByoH,
                    byoM: _blackByoM,
                    byoS: _blackByoS,
                    byoCount: _blackByoCount,
                    onMainChanged: (h, m, s) {
                      setState(() {
                        _blackMainH = h;
                        _blackMainM = m;
                        _blackMainS = s;
                      });
                    },
                    onByoChanged: (h, m, s) {
                      setState(() {
                        _blackByoH = h;
                        _blackByoM = m;
                        _blackByoS = s;
                      });
                    },
                    onCountChanged: (c) {
                      setState(() {
                        _blackByoCount = c;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Beyaz',
                    style: TextStyle(fontFamily: 'SF Pro Display', fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _buildPlayerBlock(
                    mainH: _whiteMainH,
                    mainM: _whiteMainM,
                    mainS: _whiteMainS,
                    byoH: _whiteByoH,
                    byoM: _whiteByoM,
                    byoS: _whiteByoS,
                    byoCount: _whiteByoCount,
                    onMainChanged: (h, m, s) {
                      setState(() {
                        _whiteMainH = h;
                        _whiteMainM = m;
                        _whiteMainS = s;
                      });
                    },
                    onByoChanged: (h, m, s) {
                      setState(() {
                        _whiteByoH = h;
                        _whiteByoM = m;
                        _whiteByoS = s;
                      });
                    },
                    onCountChanged: (c) {
                      setState(() {
                        _whiteByoCount = c;
                      });
                    },
                  ),
                ],
              ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: _onStartPressed,
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

  // Ortak ayar (iki renk aynı)
  Widget _buildCommonBlock() {
    return _buildPlayerBlock(
      mainH: _blackMainH,
      mainM: _blackMainM,
      mainS: _blackMainS,
      byoH: _blackByoH,
      byoM: _blackByoM,
      byoS: _blackByoS,
      byoCount: _blackByoCount,
      onMainChanged: (h, m, s) {
        setState(() {
          _blackMainH = h;
          _blackMainM = m;
          _blackMainS = s;
        });
      },
      onByoChanged: (h, m, s) {
        setState(() {
          _blackByoH = h;
          _blackByoM = m;
          _blackByoS = s;
        });
      },
      onCountChanged: (c) {
        setState(() {
          _blackByoCount = c;
        });
      },
    );
  }

  // Bir oyuncu için ayar bloğu
  Widget _buildPlayerBlock({
    required int mainH,
    required int mainM,
    required int mainS,
    required int byoH,
    required int byoM,
    required int byoS,
    required int byoCount,
    required void Function(int, int, int) onMainChanged,
    required void Function(int, int, int) onByoChanged,
    required void Function(int) onCountChanged,
  }) {
    return Column(
      children: [
        _buildTimeTile(
          label: 'Ana Süre',
          subtitle: _formatHms(mainH, mainM, mainS),
          onTap: () async {
            final result = await _showTimePicker(context: context, initialH: mainH, initialM: mainM, initialS: mainS);
            if (result != null) {
              onMainChanged(result.h, result.m, result.s);
            }
          },
        ),
        const SizedBox(height: 16),
        if (!_isSimple)
          Column(
            children: [
              _buildTimeTile(
                label: 'Byoyomi Süresi',
                subtitle: _formatHms(byoH, byoM, byoS),
                onTap: () async {
                  final result = await _showTimePicker(context: context, initialH: byoH, initialM: byoM, initialS: byoS);
                  if (result != null) {
                    onByoChanged(result.h, result.m, result.s);
                  }
                },
              ),
              const SizedBox(height: 16),
              if (_isCanada || _isJapan)
                _buildIntTile(
                  label: _isCanada ? 'Hamle Sayısı (Kanada Byoyomi)' : 'Byoyomi Hakkı (Adet)',
                  value: byoCount,
                  onTap: () async {
                    final value = await _showIntPicker(context: context, initial: byoCount, min: 1, max: 40);
                    if (value != null) {
                      onCountChanged(value);
                    }
                  },
                ),
            ],
          ),
      ],
    );
  }

  void _onStartPressed() {
    final blackMainSec = _toSeconds(_blackMainH, _blackMainM, _blackMainS);
    final whiteMainSec = _useDifferentSettings ? _toSeconds(_whiteMainH, _whiteMainM, _whiteMainS) : blackMainSec;

    int blackByoSec = 0;
    int whiteByoSec = 0;
    int blackCount = 0;
    int whiteCount = 0;

    if (!_isSimple) {
      blackByoSec = _toSeconds(_blackByoH, _blackByoM, _blackByoS);
      blackCount = _blackByoCount;

      if (_useDifferentSettings) {
        whiteByoSec = _toSeconds(_whiteByoH, _whiteByoM, _whiteByoS);
        whiteCount = _whiteByoCount;
      } else {
        whiteByoSec = blackByoSec;
        whiteCount = blackCount;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimerScreen(
          timeSystem: widget.timeSystem,
          blackMainTime: blackMainSec,
          whiteMainTime: whiteMainSec,
          blackByoyomi: blackByoSec,
          whiteByoyomi: whiteByoSec,
          blackByoyomiCount: blackCount,
          whiteByoyomiCount: whiteCount,
        ),
      ),
    );
  }

  Widget _buildTimeTile({required String label, required String subtitle, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(color: kCardColor, borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: kTextSecondary)),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.mode_edit_outline_rounded, size: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildIntTile({required String label, required int value, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(color: kCardColor, borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        subtitle: Text('$value', style: const TextStyle(fontSize: 13, color: kTextSecondary)),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.edit_outlined, size: 20, color: Colors.white),
        ),
      ),
    );
  }

  Future<_Hms?> _showTimePicker({required BuildContext context, required int initialH, required int initialM, required int initialS}) async {
    int selectedH = initialH;
    int selectedM = initialM;
    int selectedS = initialS;

    return showModalBottomSheet<_Hms>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 260,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
                  const Text(
                    'Süre Seç',
                    style: TextStyle(fontFamily: 'SF Pro Text', fontWeight: FontWeight.w600),
                  ),
                  TextButton(onPressed: () => Navigator.pop(ctx, _Hms(selectedH, selectedM, selectedS)), child: const Text('Tamam')),
                ],
              ),
              const Divider(height: 1),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(initialItem: initialH),
                        onSelectedItemChanged: (value) {
                          selectedH = value;
                        },
                        children: List.generate(10, (index) => Center(child: Text('$index sa'))),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(initialItem: initialM),
                        onSelectedItemChanged: (value) {
                          selectedM = value;
                        },
                        children: List.generate(60, (index) => Center(child: Text('$index dk'))),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(initialItem: initialS),
                        onSelectedItemChanged: (value) {
                          selectedS = value;
                        },
                        children: List.generate(60, (index) => Center(child: Text('$index sn'))),
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

  Future<int?> _showIntPicker({required BuildContext context, required int initial, required int min, required int max}) async {
    int selected = initial.clamp(min, max);
    final itemCount = max - min + 1;
    final initialIndex = (selected - min).clamp(0, itemCount - 1);

    return showModalBottomSheet<int>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 240,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
                  const Text(
                    'Seç',
                    style: TextStyle(fontFamily: 'SF Pro Text', fontWeight: FontWeight.w600),
                  ),
                  TextButton(onPressed: () => Navigator.pop(ctx, selected), child: const Text('Tamam')),
                ],
              ),
              const Divider(height: 1),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(initialItem: initialIndex),
                  onSelectedItemChanged: (index) {
                    selected = min + index;
                  },
                  children: List.generate(itemCount, (index) => Center(child: Text('${min + index}'))),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _toSeconds(int h, int m, int s) => h * 3600 + m * 60 + s;

  String _formatHms(int h, int m, int s) {
    final hh = h.toString().padLeft(2, '0');
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }
}

// Saat/dk/sn için küçük helper class
class _Hms {
  final int h;
  final int m;
  final int s;
  _Hms(this.h, this.m, this.s);
}
