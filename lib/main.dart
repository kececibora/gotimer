// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gotimer/translate/translate.dart';
import 'package:gotimer/view/info_page.dart';
import 'package:gotimer/widgets/background_widget.dart';
import 'package:gotimer/widgets/change_lang_widgets.dart';

import 'ui/app_colors.dart';
import 'ui/app_dimens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GoTimerApp());
}

// ================== APP ==================

class GoTimerApp extends StatelessWidget {
  const GoTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Match Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: AppColors.bg),
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
          backgroundColor: AppColors.bg,
          body: AppBackground(
            imagePath1: 'assets/background/background_2.png',
            imagePath2: 'assets/background/background_1.png',
            child: Padding(
              padding: AppDimens.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: const [LanguageButton()]),

                  // Başlığı biraz daha aşağıya aldık
                  const SizedBox(height: 120),

                  Text(
                    AppStrings.t(lang, 'appSubtitle'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppDimens.gap12),
                  Text(
                    AppStrings.t(lang, 'timeSystemTitle'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 1, color: Colors.white),
                  ),
                  const SizedBox(height: AppDimens.gap32),

                  _timeSystemButton(context, 'Byoyomi', AppStrings.t(lang, 'byoyomiTitle'), AppStrings.t(lang, 'byoyomiDesc')),
                  const SizedBox(height: AppDimens.gap16),
                  _timeSystemButton(context, 'Kanada Byoyomi', AppStrings.t(lang, 'canadaTitle'), AppStrings.t(lang, 'canadaDesc')),
                  const SizedBox(height: AppDimens.gap16),
                  _timeSystemButton(context, 'Basit Zaman', AppStrings.t(lang, 'simpleTitle'), AppStrings.t(lang, 'simpleDesc')),

                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InfoButton(languageCode: lang),
                  ),
                  const SizedBox(height: AppDimens.gap8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _timeSystemButton(BuildContext context, String systemId, String title, String description) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.radius24),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TimerSettingsScreen(timeSystem: systemId))),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppDimens.radius24),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 18, offset: Offset(0, 8))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            const Icon(Icons.timer_rounded, color: Colors.white, size: 32),
            const SizedBox(width: AppDimens.gap18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: AppDimens.gap4),
                  Text(description, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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

  late int _blackMainTime;
  late int _blackByoyomiRemaining;
  late int _blackByoyomiCount;
  int _blackMoves = 0;

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

  Future<void> _playBeep() async => SystemSound.play(SystemSoundType.alert);

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
    if (_soundOn) _playBeep();
    _createTimer();
    setState(() => _isRunning = true);
  }

  void _pauseTimer() {
    if (!_isRunning) return;
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _toggleRunPause() => _isRunning ? _pauseTimer() : _startTimer();

  void _tickBlack() {
    final currentPhaseRemaining = _blackMainTime > 0 ? _blackMainTime : _blackByoyomiRemaining;

    if (_soundOn && !_blackTenSecWarned && currentPhaseRemaining == 10) {
      _playBeep();
      _blackTenSecWarned = true;
    }

    if (_blackMainTime > 0) {
      _blackMainTime--;
      return;
    }

    if (_isSimple) {
      _endGame('Beyaz');
      return;
    }

    if (_blackByoyomiRemaining > 0) {
      _blackByoyomiRemaining--;
    } else if (_blackByoyomiCount > 0) {
      _blackByoyomiCount--;
      _blackByoyomiRemaining = widget.blackByoyomi;
      _blackTenSecWarned = false;
    } else {
      _endGame('Beyaz');
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
      return;
    }

    if (_isSimple) {
      _endGame('Siyah');
      return;
    }

    if (_whiteByoyomiRemaining > 0) {
      _whiteByoyomiRemaining--;
    } else if (_whiteByoyomiCount > 0) {
      _whiteByoyomiCount--;
      _whiteByoyomiRemaining = widget.whiteByoyomi;
      _whiteTenSecWarned = false;
    } else {
      _endGame('Siyah');
    }
  }

  void _endGame(String winner) {
    _timer?.cancel();
    _isRunning = false;
    _gameEnded = true;
    _winner = winner;
  }

  void _passTurn() {
    if (_gameEnded) return;

    if (_isRunning) _timer?.cancel();

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

    if (_isRunning) _createTimer();
  }

  void _toggleSound() => setState(() => _soundOn = !_soundOn);

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
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
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
                moves: _whiteMoves,
                isActive: _isRunning && !_isBlackTurn,
              ),
            ),
          ),
          _buildControlBar(),
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
    Widget button(IconData icon, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.gap12),
        child: Container(
          width: AppDimens.controlButtonWidth,
          height: AppDimens.controlButtonHeight,
          decoration: BoxDecoration(color: AppColors.controlButton, borderRadius: BorderRadius.circular(AppDimens.radius12)),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      );
    }

    return Container(
      color: AppColors.controlBar,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [button(_soundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded, _toggleSound), button(_isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, _toggleRunPause)],
      ),
    );
  }

  Widget _buildPlayerArea({required bool isTop, required bool isBlack, required int mainTime, required int byoyomiRemaining, required int byoyomiCount, required int moves, required bool isActive}) {
    final Color backgroundColor = isActive ? AppColors.active : (isBlack ? AppColors.blackBase : AppColors.whiteBase);
    final Color textColor = isActive ? const Color(0xFF222222) : (isBlack ? Colors.white : const Color(0xFF111111));

    final currentDisplayTime = mainTime > 0 ? mainTime : byoyomiRemaining;

    // ✅ DİNAMİK BYOYOMI BİLGİSİ (kalan hak + kalan süre)
    String byoyomiInfo = '';

    if (!_isSimple && byoyomiCount > 0) {
      if (widget.timeSystem == 'Byoyomi') {
        // 🇯🇵 Japon Byoyomi
        byoyomiInfo = 'Byo: $byoyomiCount hak | ${byoyomiRemaining} sn';
      } else if (widget.timeSystem == 'Kanada Byoyomi') {
        // 🇨🇦 Kanada Byoyomi
        byoyomiInfo = 'Kalan hamle: $byoyomiCount | ${byoyomiRemaining} sn';
      }
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
            const SizedBox(height: AppDimens.gap8),
            Text(
              _formatTime(currentDisplayTime),
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.w800, letterSpacing: 2, color: textColor),
            ),
            if (byoyomiInfo.isNotEmpty) ...[
              const SizedBox(height: AppDimens.gap8),
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

  int _blackMainH = 0;
  int _blackMainM = 15;
  int _blackMainS = 0;

  int _blackByoH = 0;
  int _blackByoM = 0;
  int _blackByoS = 30;
  int _blackByoCount = 3;

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
    if (_isJapan) {
      _blackByoCount = 5;
      _whiteByoCount = 5;
    } else if (_isCanada) {
      _blackByoCount = 25;
      _whiteByoCount = 25;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.timeSystem} Ayarları')),
      body: AppBackground(
        imagePath1: 'assets/background/background_2.png',
        imagePath2: null,
        child: SingleChildScrollView(
          padding: AppDimens.screenPadding,
          child: Column(
            children: [
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
              const SizedBox(height: AppDimens.gap16),
              if (!_useDifferentSettings) _buildCommonBlock() else _buildDifferentBlock(),
              const SizedBox(height: AppDimens.gap32),
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
      ),
    );
  }

  Widget _buildDifferentBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Siyah',
          style: TextStyle(fontFamily: 'SF Pro Display', fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppDimens.gap8),
        _buildPlayerBlock(
          mainH: _blackMainH,
          mainM: _blackMainM,
          mainS: _blackMainS,
          byoH: _blackByoH,
          byoM: _blackByoM,
          byoS: _blackByoS,
          byoCount: _blackByoCount,
          onMainChanged: (h, m, s) => setState(() {
            _blackMainH = h;
            _blackMainM = m;
            _blackMainS = s;
          }),
          onByoChanged: (h, m, s) => setState(() {
            _blackByoH = h;
            _blackByoM = m;
            _blackByoS = s;
          }),
          onCountChanged: (c) => setState(() => _blackByoCount = c),
        ),
        const SizedBox(height: AppDimens.gap24),
        const Text(
          'Beyaz',
          style: TextStyle(fontFamily: 'SF Pro Display', fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppDimens.gap8),
        _buildPlayerBlock(
          mainH: _whiteMainH,
          mainM: _whiteMainM,
          mainS: _whiteMainS,
          byoH: _whiteByoH,
          byoM: _whiteByoM,
          byoS: _whiteByoS,
          byoCount: _whiteByoCount,
          onMainChanged: (h, m, s) => setState(() {
            _whiteMainH = h;
            _whiteMainM = m;
            _whiteMainS = s;
          }),
          onByoChanged: (h, m, s) => setState(() {
            _whiteByoH = h;
            _whiteByoM = m;
            _whiteByoS = s;
          }),
          onCountChanged: (c) => setState(() => _whiteByoCount = c),
        ),
      ],
    );
  }

  Widget _buildCommonBlock() {
    return _buildPlayerBlock(
      mainH: _blackMainH,
      mainM: _blackMainM,
      mainS: _blackMainS,
      byoH: _blackByoH,
      byoM: _blackByoM,
      byoS: _blackByoS,
      byoCount: _blackByoCount,
      onMainChanged: (h, m, s) => setState(() {
        _blackMainH = h;
        _blackMainM = m;
        _blackMainS = s;
      }),
      onByoChanged: (h, m, s) => setState(() {
        _blackByoH = h;
        _blackByoM = m;
        _blackByoS = s;
      }),
      onCountChanged: (c) => setState(() => _blackByoCount = c),
    );
  }

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
            if (result != null) onMainChanged(result.h, result.m, result.s);
          },
        ),
        const SizedBox(height: AppDimens.gap16),
        if (!_isSimple)
          Column(
            children: [
              _buildTimeTile(
                label: 'Byoyomi Süresi',
                subtitle: _formatHms(byoH, byoM, byoS),
                onTap: () async {
                  final result = await _showTimePicker(context: context, initialH: byoH, initialM: byoM, initialS: byoS);
                  if (result != null) onByoChanged(result.h, result.m, result.s);
                },
              ),
              const SizedBox(height: AppDimens.gap16),
              if (_isCanada || _isJapan)
                _buildIntTile(
                  label: _isCanada ? 'Hamle Sayısı (Kanada Byoyomi)' : 'Byoyomi Hakkı (Adet)',
                  value: byoCount,
                  onTap: () async {
                    final value = await _showIntPicker(context: context, initial: byoCount, min: 1, max: 40);
                    if (value != null) onCountChanged(value);
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
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(AppDimens.radius20)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(AppDimens.radius12)),
          child: const Icon(Icons.mode_edit_outline_rounded, size: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildIntTile({required String label, required int value, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(AppDimens.radius20)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        subtitle: Text('$value', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(AppDimens.radius12)),
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
                        onSelectedItemChanged: (value) => selectedH = value,
                        children: List.generate(10, (index) => Center(child: Text('$index sa'))),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(initialItem: initialM),
                        onSelectedItemChanged: (value) => selectedM = value,
                        children: List.generate(60, (index) => Center(child: Text('$index dk'))),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(initialItem: initialS),
                        onSelectedItemChanged: (value) => selectedS = value,
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
                  onSelectedItemChanged: (index) => selected = min + index,
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

class _Hms {
  final int h;
  final int m;
  final int s;
  _Hms(this.h, this.m, this.s);
}
