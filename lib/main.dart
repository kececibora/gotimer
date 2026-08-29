// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gotimer/translate/translate.dart';
import 'package:gotimer/view/help_page.dart';
import 'package:gotimer/view/info_page.dart';
import 'package:gotimer/widgets/background_widget.dart';
import 'package:gotimer/widgets/change_lang_widgets.dart';

import 'ui/app_colors.dart';
import 'ui/app_dimens.dart';
import 'ui/app_text_styles.dart';
import 'ui/app_theme.dart';
import 'widgets/fantasy_components.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Uygulama her zaman dik kalsın
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppThemeController.loadTheme();
  await AppLanguage.load();

  runApp(const GoTimerApp());
}

class TimeSystemIds {
  static const byoyomi = 'byoyomi';
  static const canada = 'canada';
  static const simple = 'simple';
  static const fischer = 'fischer';
}

// ================== APP ==================

class GoTimerApp extends StatelessWidget {
  const GoTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<GoThemeId>(
      valueListenable: AppThemeController.notifier,
      builder: (context, themeId, child) {
        return MaterialApp(
          title: 'Go Match Timer',
          debugShowCheckedModeBanner: false,
          theme: AppThemeController.buildMaterialTheme(),
          home: const WarmTimeSystemScreen(),
        );
      },
    );
  }
}

// ============ Warm Dark-Fantasy Time System Selection ============
class WarmTimeSystemScreen extends StatelessWidget {
  const WarmTimeSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.notifier,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: AppColors.menuTop,
          body: AppBackground(
            child: Padding(
              padding: AppDimens.screenPadding,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Align(
                              alignment: Alignment.centerRight,
                              child: LanguageButton(),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Container(
                                width: 82,
                                height: 82,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.panelDeep,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: AppColors.brass.withValues(
                                      alpha: 0.64,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.brass.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 24,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(19),
                                  child: Image.asset(
                                    'assets/icon/app_icon_fantasy_go_wood_v2.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              AppStrings.t(lang, 'appSubtitle'),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.appSubtitle,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.t(lang, 'timeSystemTitle'),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.screenTitle,
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Container(
                                width: 72,
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppColors.brass,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _systemCard(
                              context: context,
                              systemId: TimeSystemIds.byoyomi,
                              title: AppStrings.t(lang, 'byoyomiTitle'),
                              description: AppStrings.t(lang, 'byoyomiDesc'),
                              hint: AppColors.slate,
                            ),
                            const SizedBox(height: AppDimens.gap16),
                            _systemCard(
                              context: context,
                              systemId: TimeSystemIds.canada,
                              title: AppStrings.t(lang, 'canadaTitle'),
                              description: AppStrings.t(lang, 'canadaDesc'),
                              hint: AppColors.moss,
                            ),
                            const SizedBox(height: AppDimens.gap16),
                            _systemCard(
                              context: context,
                              systemId: TimeSystemIds.simple,
                              title: AppStrings.t(lang, 'simpleTitle'),
                              description: AppStrings.t(lang, 'simpleDesc'),
                              hint: AppColors.brass,
                            ),
                            const SizedBox(height: AppDimens.gap16),
                            _systemCard(
                              context: context,
                              systemId: TimeSystemIds.fischer,
                              title: AppStrings.t(lang, 'fischerTitle'),
                              description: AppStrings.t(lang, 'fischerDesc'),
                              hint: AppColors.slate,
                            ),
                            const Spacer(),
                            const SizedBox(height: AppDimens.gap20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InfoButton(languageCode: lang),
                                Text(
                                  'v.2.2.0',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.72,
                                    ),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const HelpButton(),
                              ],
                            ),
                            const SizedBox(height: AppDimens.gap8),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _systemCard({
    required BuildContext context,
    required String systemId,
    required String title,
    required String description,
    required Color hint,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TimerSettingsScreen(timeSystem: systemId),
          ),
        ),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          decoration: FantasyDecorations.panel(accented: true, accent: hint),
          child: Row(
            children: [
              FantasyIconSurface(
                icon: _timeSystemIcon(systemId),
                color: hint,
                size: 26,
                padding: const EdgeInsets.all(12),
              ),
              const SizedBox(width: AppDimens.gap16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 5),
                    Text(description, style: AppTextStyles.cardDesc),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.brass,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _timeSystemIcon(String systemId) {
    switch (systemId) {
      case TimeSystemIds.byoyomi:
        return Icons.hourglass_bottom_rounded;
      case TimeSystemIds.canada:
        return Icons.format_list_numbered_rounded;
      case TimeSystemIds.fischer:
        return Icons.add_alarm_rounded;
      default:
        return Icons.timer_rounded;
    }
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
  AudioPlayer? _beepPlayer;
  bool _assetBeepReady = false;
  Timer? _timer;
  bool _isRunning = false;
  bool _isBlackTurn = true;

  late int _blackMainTime;
  late int _blackByoyomiRemaining;
  late int _blackByoyomiCount;
  int _blackMoves = 0;
  bool _controlsVisible = true;
  Timer? _controlsAutoHideTimer;

  // double get _controlBarHeight => 56; // mevcut bar yüksekliğine yakın

  late int _whiteMainTime;
  late int _whiteByoyomiRemaining;
  late int _whiteByoyomiCount;
  int _whiteMoves = 0;

  bool _gameEnded = false;
  String? _winnerKey;

  bool _soundOn = true;
  bool get _isSimple => widget.timeSystem == TimeSystemIds.simple;
  bool get _isFischer => widget.timeSystem == TimeSystemIds.fischer;

  @override
  void initState() {
    super.initState();
    _initBeepPlayer();
    _blackMainTime = widget.blackMainTime;
    _whiteMainTime = widget.whiteMainTime;
    _blackByoyomiRemaining = widget.blackByoyomi;
    _whiteByoyomiRemaining = widget.whiteByoyomi;
    _blackByoyomiCount = widget.blackByoyomiCount;
    _whiteByoyomiCount = widget.whiteByoyomiCount;
  }

  Widget _buildControlBarTapArea() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Silikse: 1 dokunuşla aktif yap
        if (!_controlsVisible) {
          _showControls(autoHide: true);
          return;
        }

        // Aktifse: istersen tekrar silikleştir (toggle mantığı kalsın)
        _hideControls();
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _controlsVisible ? 1.0 : 0.22, // 👈 siliklik seviyesi
        child: AbsorbPointer(
          absorbing: !_controlsVisible, // 👈 silikken butonlar tıklanamaz
          child: _buildControlBar(),
        ),
      ),
    );
  }

  Widget _buildControlBar() {
    Widget button(IconData icon, VoidCallback onTap) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.gap12),
          child: Ink(
            width: AppDimens.controlButtonWidth,
            height: AppDimens.controlButtonHeight,
            decoration: FantasyDecorations.wood(radius: AppDimens.radius12),
            child: Icon(
              icon,
              color:
                  icon == Icons.play_arrow_rounded ||
                      icon == Icons.pause_rounded
                  ? AppColors.brass
                  : AppColors.parchmentSoft,
              size: 27,
            ),
          ),
        ),
      );
    }

    return Container(
      key: ValueKey(_controlsVisible ? 'visible_bar' : 'hidden_bar'),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2B2119), Color(0xFF171411)],
        ),
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.hairline),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 16),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          button(
            _soundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
            _toggleSound,
          ),
          button(Icons.settings_rounded, _openLiveSettings),
          button(
            _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            _toggleRunPause,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controlsAutoHideTimer?.cancel();
    _timer?.cancel();
    _beepPlayer?.dispose();
    super.dispose();
  }

  Future<void> _initBeepPlayer() async {
    try {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.stop);
      if (!mounted) {
        await player.dispose();
        return;
      }
      _beepPlayer = player;
      _assetBeepReady = true;
    } catch (_) {
      _assetBeepReady = false;
      _beepPlayer = null;
    }
  }

  void _hideControls() {
    _controlsAutoHideTimer?.cancel();
    if (!_controlsVisible) return;
    setState(() => _controlsVisible = false);
  }

  void _showControls({bool autoHide = false}) {
    _controlsAutoHideTimer?.cancel();
    if (_controlsVisible == false) {
      setState(() => _controlsVisible = true);
    }

    // İstersen otomatik tekrar kaybolsun (opsiyonel)
    if (autoHide && _isRunning) {
      _controlsAutoHideTimer = Timer(const Duration(seconds: 2), () {
        if (mounted && _isRunning) _hideControls();
      });
    }
  }

  // void _toggleControls() {
  //   if (_controlsVisible) {
  //     _hideControls();
  //   } else {
  //     _showControls(autoHide: true);
  //   }
  // }

  Future<void> _playBeep() async {
    // Önce asset beep; plugin yoksa system sound/haptic fallback.
    if (_assetBeepReady && _beepPlayer != null) {
      try {
        await _beepPlayer!.stop();
        await _beepPlayer!.play(AssetSource('sounds/beep.wav'), volume: 1.0);
        return;
      } catch (_) {
        _assetBeepReady = false;
      }
    }
    try {
      await SystemSound.play(SystemSoundType.alert);
    } catch (_) {}
    try {
      await SystemSound.play(SystemSoundType.click);
    } catch (_) {}
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
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
    if (_soundOn) _playBeep();
    _createTimer();
    setState(() => _isRunning = true);

    // ✅ Sayaç başladı -> kontrol bar gizlensin
    _hideControls();
  }

  void _pauseTimer() {
    if (!_isRunning) return;
    _timer?.cancel();
    setState(() => _isRunning = false);

    // ✅ Durunca kontrol bar görünsün
    _showControls(autoHide: false);
  }

  void _toggleRunPause() => _isRunning ? _pauseTimer() : _startTimer();

  void _tickBlack() {
    final currentPhaseRemaining = _blackMainTime > 0
        ? _blackMainTime
        : _blackByoyomiRemaining;

    if (_soundOn && currentPhaseRemaining >= 1 && currentPhaseRemaining <= 10) {
      _playBeep();
    }

    if (_blackMainTime > 0) {
      _blackMainTime--;
      return;
    }

    // Fischer'da (Basit gibi) ana süre biterse oyun biter; ayrı periyot yok.
    if (_isSimple || _isFischer) {
      _endGame('settingsWhite');
      return;
    }

    if (widget.timeSystem == TimeSystemIds.canada) {
      if (_blackByoyomiRemaining > 0) {
        _blackByoyomiRemaining--;
      } else {
        _endGame('settingsWhite');
      }
      return;
    }

    if (_blackByoyomiRemaining > 0) {
      _blackByoyomiRemaining--;
    } else if (_blackByoyomiCount > 1) {
      // Mevcut periyot doldu → sonraki periyoda geç (hak içinde bulunulan dahil sayılır)
      _blackByoyomiCount--;
      _blackByoyomiRemaining = widget.blackByoyomi;
    } else {
      // Son periyot da doldu → süre aşımı
      _endGame('settingsWhite');
    }
  }

  void _tickWhite() {
    final currentPhaseRemaining = _whiteMainTime > 0
        ? _whiteMainTime
        : _whiteByoyomiRemaining;

    if (_soundOn && currentPhaseRemaining >= 1 && currentPhaseRemaining <= 10) {
      _playBeep();
    }

    if (_whiteMainTime > 0) {
      _whiteMainTime--;
      return;
    }

    // Fischer'da (Basit gibi) ana süre biterse oyun biter; ayrı periyot yok.
    if (_isSimple || _isFischer) {
      _endGame('settingsBlack');
      return;
    }

    if (widget.timeSystem == TimeSystemIds.canada) {
      if (_whiteByoyomiRemaining > 0) {
        _whiteByoyomiRemaining--;
      } else {
        _endGame('settingsBlack');
      }
      return;
    }

    if (_whiteByoyomiRemaining > 0) {
      _whiteByoyomiRemaining--;
    } else if (_whiteByoyomiCount > 1) {
      // Mevcut periyot doldu → sonraki periyoda geç (hak içinde bulunulan dahil sayılır)
      _whiteByoyomiCount--;
      _whiteByoyomiRemaining = widget.whiteByoyomi;
    } else {
      // Son periyot da doldu → süre aşımı
      _endGame('settingsBlack');
    }
  }

  void _endGame(String winnerKey) {
    _timer?.cancel();
    _isRunning = false;
    _gameEnded = true;
    _winnerKey = winnerKey;
  }

  void _passTurn() {
    if (_gameEnded || !_isRunning) return;

    if (_isRunning) _timer?.cancel();

    setState(() {
      if (_isBlackTurn) {
        _blackMoves++;

        if (_isFischer) {
          // 🔁 Fischer: her hamlede ana süreye sabit ek süre eklenir (sınırsız)
          _blackMainTime += widget.blackByoyomi;
        } else if (_blackMainTime <= 0) {
          if (widget.timeSystem == TimeSystemIds.canada) {
            _blackByoyomiCount--;

            // 🔁 Kanada: hamleler bitince YENİ PERİYOT
            if (_blackByoyomiCount <= 0) {
              _blackByoyomiCount = widget.blackByoyomiCount;
              _blackByoyomiRemaining = widget.blackByoyomi;
            }
          } else if (widget.timeSystem == TimeSystemIds.byoyomi) {
            // 🔁 Japon byoyomi: hamle zamanında yapıldı → süre tazelenir, hak korunur
            _blackByoyomiRemaining = widget.blackByoyomi;
          }
        }
      } else {
        _whiteMoves++;

        if (_isFischer) {
          // 🔁 Fischer: her hamlede ana süreye sabit ek süre eklenir (sınırsız)
          _whiteMainTime += widget.whiteByoyomi;
        } else if (_whiteMainTime <= 0) {
          if (widget.timeSystem == TimeSystemIds.canada) {
            _whiteByoyomiCount--;

            // 🔁 Kanada: hamleler bitince YENİ PERİYOT
            if (_whiteByoyomiCount <= 0) {
              _whiteByoyomiCount = widget.whiteByoyomiCount;
              _whiteByoyomiRemaining = widget.whiteByoyomi;
            }
          } else if (widget.timeSystem == TimeSystemIds.byoyomi) {
            // 🔁 Japon byoyomi: hamle zamanında yapıldı → süre tazelenir, hak korunur
            _whiteByoyomiRemaining = widget.whiteByoyomi;
          }
        }
      }

      _isBlackTurn = !_isBlackTurn;
    });

    if (_isRunning) _createTimer();
  }

  void _toggleSound() {
    final next = !_soundOn;

    setState(() => _soundOn = next);

    if (next) {
      _playBeep();
    }
  }

  void _openLiveSettings() async {
    if (_gameEnded) return;

    final lang = AppLanguage.current;
    final remainingLabel = AppStrings.t(lang, 'remaining');
    final mainTimeLabel = '${AppStrings.t(lang, 'mainTime')} ($remainingLabel)';
    final byoyomiTimeLabel =
        '${AppStrings.t(lang, 'byoyomiTime')} ($remainingLabel)';
    final countLabelBase = widget.timeSystem == TimeSystemIds.canada
        ? AppStrings.t(lang, 'canadaMoveCount')
        : AppStrings.t(lang, 'japanByoCount');
    final countLabel = '$countLabelBase ($remainingLabel)';
    final liveSettingsTitle = AppStrings.t(lang, 'liveSettingsTitle');
    final okLabel = AppStrings.t(lang, 'ok');
    final blackLabel = AppStrings.t(lang, 'settingsBlack');
    final whiteLabel = AppStrings.t(lang, 'settingsWhite');

    final wasRunning = _isRunning;
    if (wasRunning) _pauseTimer();

    await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: AppColors.panelDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radius24),
        ),
      ),
      builder: (sheetContext) {
        Widget timeTile(String title, int seconds, VoidCallback onTap) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: FantasyDecorations.panel(),
            child: ListTile(
              onTap: onTap,
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.parchment,
                ),
              ),
              subtitle: Text(
                _formatHmsFromSeconds(seconds),
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              trailing: Icon(Icons.edit_outlined, color: AppColors.brass),
            ),
          );
        }

        Widget intTile(
          String title,
          int value,
          int min,
          int max,
          void Function(int v) onChanged,
        ) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: FantasyDecorations.panel(),
            child: ListTile(
              onTap: () async {
                final picked = await _showIntPickerLive(
                  context: sheetContext,
                  initial: value,
                  min: min,
                  max: max,
                );
                if (picked != null) onChanged(picked);
              },
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.parchment,
                ),
              ),
              subtitle: Text(
                '$value',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              trailing: Icon(Icons.edit_outlined, color: AppColors.brass),
            ),
          );
        }

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: 24 + MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // üst bar + kapat
                // ✅ ŞIK ÜST BAR
                Column(
                  children: [
                    const SizedBox(height: 6),

                    // Drag indicator (ortada)
                    Container(
                      width: 46,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.brass.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Toolbar
                    Row(
                      children: [
                        // Sol: Ana sayfa butonu (pill)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            backgroundColor: Colors.white.withOpacity(0.06),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            foregroundColor: AppColors.accent,
                          ),
                          onPressed: () async {
                            final lang = AppLanguage.current;

                            final sureTitle = AppStrings.t(lang, 'sureTitle');
                            final sureMsg = AppStrings.t(lang, 'sureHomeMsg');
                            final cancel = AppStrings.t(lang, 'cancel');
                            final ok = AppStrings.t(lang, 'ok');

                            // ✅ await'ten önce navigator referanslarını al
                            final sheetNav = Navigator.of(
                              sheetContext,
                              rootNavigator: true,
                            );
                            final mainNav = Navigator.of(context);

                            final bool? confirmed = await showDialog<bool>(
                              context: sheetContext,
                              barrierDismissible: false,
                              builder: (dCtx) {
                                return Dialog(
                                  insetPadding: const EdgeInsets.symmetric(
                                    horizontal: 28,
                                  ),
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.panelDeep,
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.08),
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 26,
                                          offset: Offset(0, 12),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      20,
                                      20,
                                      16,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 38,
                                              height: 38,
                                              decoration: BoxDecoration(
                                                color: AppColors.accent
                                                    .withOpacity(0.18),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                Icons.home_rounded,
                                                color: AppColors.accent,
                                                size: 22,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                sureTitle,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 14),
                                        Text(
                                          sureMsg,
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 14,
                                            height: 1.35,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 18),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  side: BorderSide(
                                                    color: Colors.white
                                                        .withOpacity(0.24),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(dCtx, false),
                                                child: Text(cancel),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: FilledButton(
                                                style: FilledButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.accent,
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(dCtx, true),
                                                child: Text(ok),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );

                            if (!mounted) return;
                            if (confirmed != true) return;

                            sheetNav.pop(); // sheet kapat
                            mainNav.popUntil(
                              (route) => route.isFirst,
                            ); // ana sayfa
                          },

                          icon: const Icon(Icons.home_rounded, size: 18),
                          label: Text(
                            AppStrings.t(AppLanguage.current, 'backToHome'),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Orta: Başlık
                        Expanded(
                          child: Text(
                            AppStrings.t(
                              AppLanguage.current,
                              'liveSettingsTitle',
                            ),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Sağ: Kapat (mini rounded button)
                        IconButton(
                          onPressed: () => Navigator.of(
                            sheetContext,
                            rootNavigator: true,
                          ).pop(),
                          icon: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppDimens.gap8),
                // İçerik kaydırılabilir: küçük ekranlarda / büyük yazı tipinde
                // taşmasın, OK butonu her zaman altta erişilebilir kalsın.
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            liveSettingsTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.gap12),

                        // SİYAH
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            blackLabel,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        timeTile(mainTimeLabel, _blackMainTime, () async {
                          final hms = await _showTimePickerLive(
                            context: sheetContext,
                            initialSeconds: _blackMainTime,
                          );
                          if (hms != null) setState(() => _blackMainTime = hms);
                        }),
                        if (!_isSimple && !_isFischer) ...[
                          timeTile(
                            byoyomiTimeLabel,
                            _blackByoyomiRemaining,
                            () async {
                              final hms = await _showTimePickerLive(
                                context: sheetContext,
                                initialSeconds: _blackByoyomiRemaining,
                              );
                              if (hms != null) {
                                setState(() => _blackByoyomiRemaining = hms);
                              }
                            },
                          ),
                          intTile(
                            countLabel,
                            _blackByoyomiCount,
                            0,
                            99,
                            (v) => setState(() => _blackByoyomiCount = v),
                          ),
                        ],

                        const SizedBox(height: AppDimens.gap12),

                        // BEYAZ
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            whiteLabel,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        timeTile(mainTimeLabel, _whiteMainTime, () async {
                          final hms = await _showTimePickerLive(
                            context: sheetContext,
                            initialSeconds: _whiteMainTime,
                          );
                          if (hms != null) setState(() => _whiteMainTime = hms);
                        }),
                        if (!_isSimple && !_isFischer) ...[
                          timeTile(
                            byoyomiTimeLabel,
                            _whiteByoyomiRemaining,
                            () async {
                              final hms = await _showTimePickerLive(
                                context: sheetContext,
                                initialSeconds: _whiteByoyomiRemaining,
                              );
                              if (hms != null) {
                                setState(() => _whiteByoyomiRemaining = hms);
                              }
                            },
                          ),
                          intTile(
                            countLabel,
                            _whiteByoyomiCount,
                            0,
                            99,
                            (v) => setState(() => _whiteByoyomiCount = v),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppDimens.gap12),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.brass,
                      foregroundColor: AppColors.ink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () =>
                        Navigator.of(sheetContext, rootNavigator: true).pop(),
                    child: Text(
                      okLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (mounted && wasRunning && !_gameEnded) _startTimer();
  }

  String _formatHmsFromSeconds(int seconds) {
    if (seconds < 0) seconds = 0;
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<int?> _showTimePickerLive({
    required BuildContext context,
    required int initialSeconds,
  }) async {
    int h = (initialSeconds ~/ 3600).clamp(0, 9);
    int m = ((initialSeconds % 3600) ~/ 60).clamp(0, 59);
    int s = (initialSeconds % 60).clamp(0, 59);

    final lang = AppLanguage.current;
    final cancelLabel = AppStrings.t(lang, 'cancel');
    final pickLabel = AppStrings.t(lang, 'dialogPickTime');
    final okLabel = AppStrings.t(lang, 'ok');
    final hourLabel = AppStrings.t(lang, 'unitHour');
    final minuteLabel = AppStrings.t(lang, 'unitMinute');
    final secondLabel = AppStrings.t(lang, 'unitSecond');

    return showModalBottomSheet<int>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) {
        return SizedBox(
          height: 260,
          child: Column(
            children: [
              _PickerHeaderBar(
                cancelLabel: cancelLabel,
                title: pickLabel,
                okLabel: okLabel,
                onCancel: () => Navigator.pop(ctx),
                onOk: () => Navigator.pop(ctx, h * 3600 + m * 60 + s),
              ),
              const Divider(height: 1),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                          initialItem: h,
                        ),
                        onSelectedItemChanged: (v) => h = v,
                        children: List.generate(
                          10,
                          (i) => Center(child: Text('$i $hourLabel')),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                          initialItem: m,
                        ),
                        onSelectedItemChanged: (v) => m = v,
                        children: List.generate(
                          60,
                          (i) => Center(child: Text('$i $minuteLabel')),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                          initialItem: s,
                        ),
                        onSelectedItemChanged: (v) => s = v,
                        children: List.generate(
                          60,
                          (i) => Center(child: Text('$i $secondLabel')),
                        ),
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

  Future<int?> _showIntPickerLive({
    required BuildContext context,
    required int initial,
    required int min,
    required int max,
  }) async {
    int selected = initial.clamp(min, max);
    final itemCount = max - min + 1;
    final initialIndex = (selected - min).clamp(0, itemCount - 1);

    final lang = AppLanguage.current;
    final cancelLabel = AppStrings.t(lang, 'cancel');
    final pickLabel = AppStrings.t(lang, 'dialogPick');
    final okLabel = AppStrings.t(lang, 'ok');

    return showModalBottomSheet<int>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) {
        return SizedBox(
          height: 240,
          child: Column(
            children: [
              _PickerHeaderBar(
                cancelLabel: cancelLabel,
                title: pickLabel,
                okLabel: okLabel,
                onCancel: () => Navigator.pop(ctx),
                onOk: () => Navigator.pop(ctx, selected),
              ),
              const Divider(height: 1),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialIndex,
                  ),
                  onSelectedItemChanged: (index) => selected = min + index,
                  children: List.generate(
                    itemCount,
                    (index) => Center(child: Text('${min + index}')),
                  ),
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
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.notifier,
      builder: (context, lang, _) {
        if (_gameEnded) {
          final winnerName = _winnerKey != null
              ? AppStrings.t(lang, _winnerKey!)
              : '';
          final winText = winnerName.isEmpty
              ? AppStrings.t(lang, 'won')
              : '$winnerName ${AppStrings.t(lang, 'won')}';

          final winnerIsBlack = _winnerKey == 'settingsBlack';
          final winnerAccent = winnerIsBlack
              ? AppColors.blackStoneGlow
              : AppColors.whiteStone;

          return Scaffold(
            backgroundColor: AppColors.menuTop,
            body: AppBackground(
              child: Center(
                child: Padding(
                  padding: AppDimens.screenPadding,
                  child: FantasyPanel(
                    accented: true,
                    accent: winnerAccent,
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: FantasyDecorations.chip(
                            accent: winnerAccent,
                            radius: 20,
                          ),
                          child: Center(
                            child: _buildStoneMarker(winnerIsBlack, size: 40),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          winText,
                          style: AppTextStyles.display(
                            fontSize: 42,
                            color: AppColors.parchment,
                            letterSpacing: 0.8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: FantasyPrimaryButton(
                            onPressed: () => Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            ),
                            child: Text(AppStrings.t(lang, 'backToHome')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.gameBackground,
          body: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // Beyaz oyuncu sadece kendi sırasıysa basınca geçsin
                    if (_isRunning && !_isBlackTurn) _passTurn();
                  },
                  child: _buildPlayerArea(
                    lang: lang,
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
              _buildControlBarTapArea(),

              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // Siyah oyuncu sadece kendi sırasıysa basınca geçsin
                    if (_isRunning && _isBlackTurn) _passTurn();
                  },
                  child: _buildPlayerArea(
                    lang: lang,
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
      },
    );
  }

  Widget _buildPlayerArea({
    required String lang,
    required bool isTop,
    required bool isBlack,
    required int mainTime,
    required int byoyomiRemaining,
    required int byoyomiCount,
    required int moves,
    required bool isActive,
  }) {
    final glow = isBlack ? AppColors.blackStoneGlow : AppColors.whiteStoneGlow;
    final textColor = isBlack ? AppColors.parchment : AppColors.ink;
    final chipBackground = isBlack
        ? AppColors.parchment.withValues(alpha: 0.07)
        : AppColors.ink.withValues(alpha: 0.08);
    final chipBorder = isBlack
        ? AppColors.whiteStone.withValues(alpha: 0.22)
        : AppColors.ink.withValues(alpha: 0.28);
    final playerLabel = AppStrings.t(
      lang,
      isBlack ? 'settingsBlack' : 'settingsWhite',
    );
    final currentDisplayTime = mainTime > 0 ? mainTime : byoyomiRemaining;

    String byoyomiInfo = '';
    if (_isFischer) {
      final incSec = isBlack ? widget.blackByoyomi : widget.whiteByoyomi;
      byoyomiInfo = AppStrings.t(
        lang,
        'timerFischerInfo',
      ).replaceFirst('{seconds}', '$incSec');
    } else if (!_isSimple && byoyomiCount > 0) {
      final fixedSec = isBlack ? widget.blackByoyomi : widget.whiteByoyomi;
      if (widget.timeSystem == TimeSystemIds.byoyomi) {
        byoyomiInfo = AppStrings.t(lang, 'timerJapanInfo')
            .replaceFirst('{count}', '$byoyomiCount')
            .replaceFirst('{seconds}', '$fixedSec');
      } else if (widget.timeSystem == TimeSystemIds.canada) {
        byoyomiInfo = AppStrings.t(lang, 'timerCanadaInfo')
            .replaceFirst('{count}', '$byoyomiCount')
            .replaceFirst('{seconds}', '$fixedSec');
      }
    }

    final movesLabel = AppStrings.t(lang, 'moves');
    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isBlack
              ? const [Color(0xFF0C0C0B), Color(0xFF1B1815), Color(0xFF2A2118)]
              : const [Color(0xFFE5DAC3), Color(0xFFC0B08F), Color(0xFF83735A)],
          stops: const [0, 0.58, 1],
        ),
        border: Border.all(color: isActive ? glow : chipBorder, width: 2),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: glow.withValues(alpha: 0.34),
                  blurRadius: 30,
                  spreadRadius: 2,
                  blurStyle: BlurStyle.inner,
                ),
              ]
            : null,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: isBlack ? 0.1 : 0.07,
            child: Image.asset(
              'assets/textures/dark_tabletop.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            top: isTop,
            bottom: !isTop,
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                // Küçük ekranda / büyük sistem yazı tipinde blok taşmasın:
                // doğal boyutunda sığmıyorsa oranı bozmadan küçültülür.
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Dar ekranda / büyük yazı tipinde satır taşmasın:
                            // rozetler gerekirse oranı bozmadan küçülür.
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: chipBackground,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: chipBorder),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildStoneMarker(isBlack),
                                      const SizedBox(width: 7),
                                      Text(
                                        playerLabel,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: chipBackground,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: chipBorder),
                                  ),
                                  child: Text(
                                    '$movesLabel: $moves',
                                    style: AppTextStyles.moveCount.copyWith(
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _formatTime(currentDisplayTime),
                          style: AppTextStyles.timerBig.copyWith(
                            color: textColor,
                            shadows: isActive
                                ? [
                                    Shadow(
                                      color: glow.withValues(alpha: 0.72),
                                      blurRadius: 18,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        if (byoyomiInfo.isNotEmpty) ...[
                          const SizedBox(height: AppDimens.gap8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: chipBackground,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: chipBorder),
                            ),
                            child: Text(
                              byoyomiInfo,
                              style: AppTextStyles.byoInfo.copyWith(
                                color: textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          opacity: isActive ? 1 : 0,
                          child: Container(
                            width: 46,
                            height: 3,
                            decoration: BoxDecoration(
                              color: glow,
                              borderRadius: BorderRadius.circular(99),
                              boxShadow: [
                                BoxShadow(
                                  color: glow.withValues(alpha: 0.72),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
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
    );

    if (isTop) {
      content = Transform.rotate(angle: pi, child: content);
    }

    return content;
  }

  Widget _buildStoneMarker(bool isBlack, {double size = 17}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.35, -0.4),
          radius: 0.92,
          colors: isBlack
              ? const [Color(0xFF77736C), Color(0xFF242321), Color(0xFF050505)]
              : const [Color(0xFFFFFFFF), Color(0xFFEDE4D2), Color(0xFFBCAE91)],
          stops: const [0, 0.34, 1],
        ),
        border: Border.all(
          color: isBlack
              ? AppColors.whiteStone.withValues(alpha: 0.18)
              : AppColors.ink.withValues(alpha: 0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.42),
            blurRadius: size * 0.28,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
    );
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

  bool get _isSimple => widget.timeSystem == TimeSystemIds.simple;
  bool get _isJapan => widget.timeSystem == TimeSystemIds.byoyomi;
  bool get _isCanada => widget.timeSystem == TimeSystemIds.canada;
  bool get _isFischer => widget.timeSystem == TimeSystemIds.fischer;

  @override
  void initState() {
    super.initState();
    if (_isJapan) {
      _blackByoCount = 5;
      _whiteByoCount = 5;
    } else if (_isCanada) {
      _blackByoCount = 25;
      _whiteByoCount = 25;
    } else if (_isFischer) {
      // Fischer için makul varsayılan: +5 sn / hamle
      _blackByoS = 5;
      _whiteByoS = 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.notifier,
      builder: (context, lang, _) {
        final systemLabel = _timeSystemLabel(lang);
        final title = AppStrings.t(
          lang,
          'settingsTitle',
        ).replaceFirst('{system}', systemLabel);

        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: AppBackground(
            child: SingleChildScrollView(
              padding: AppDimens.screenPadding,
              child: Column(
                children: [
                  FantasyPanel(
                    accented: true,
                    padding: EdgeInsets.zero,
                    child: SwitchListTile(
                      value: _useDifferentSettings,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 3,
                      ),
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
                      secondary: Icon(
                        Icons.tune_rounded,
                        color: AppColors.brass,
                      ),
                      title: Text(
                        AppStrings.t(lang, 'settingsDifferent'),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.parchmentSoft,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.gap16),
                  if (!_useDifferentSettings)
                    _buildCommonBlock(lang)
                  else
                    _buildDifferentBlock(lang),
                  const SizedBox(height: AppDimens.gap32),
                  SizedBox(
                    width: double.infinity,
                    child: FantasyPrimaryButton(
                      onPressed: _onStartPressed,
                      child: Text(AppStrings.t(lang, 'btnStart')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _timeSystemLabel(String lang) {
    switch (widget.timeSystem) {
      case TimeSystemIds.byoyomi:
        return AppStrings.t(lang, 'byoyomiTitle');
      case TimeSystemIds.canada:
        return AppStrings.t(lang, 'canadaTitle');
      case TimeSystemIds.fischer:
        return AppStrings.t(lang, 'fischerTitle');
      case TimeSystemIds.simple:
      default:
        return AppStrings.t(lang, 'simpleTitle');
    }
  }

  Widget _buildDifferentBlock(String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.t(lang, 'settingsBlack'),
          style: AppTextStyles.display(
            fontSize: 18,
            color: AppColors.blackStoneGlow,
          ),
        ),
        const SizedBox(height: AppDimens.gap8),
        _buildPlayerBlock(
          lang: lang,
          mainH: _blackMainH,
          mainM: _blackMainM,
          mainS: _blackMainS,
          byoH: _blackByoH,
          byoM: _blackByoM,
          byoS: _blackByoS,
          byoCount: _blackByoCount,
          accent: AppColors.blackStoneGlow,
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
        Text(
          AppStrings.t(lang, 'settingsWhite'),
          style: AppTextStyles.display(
            fontSize: 18,
            color: AppColors.whiteStone,
          ),
        ),
        const SizedBox(height: AppDimens.gap8),
        _buildPlayerBlock(
          lang: lang,
          mainH: _whiteMainH,
          mainM: _whiteMainM,
          mainS: _whiteMainS,
          byoH: _whiteByoH,
          byoM: _whiteByoM,
          byoS: _whiteByoS,
          byoCount: _whiteByoCount,
          accent: AppColors.whiteStone,
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

  Widget _buildCommonBlock(String lang) {
    return _buildPlayerBlock(
      lang: lang,
      mainH: _blackMainH,
      mainM: _blackMainM,
      mainS: _blackMainS,
      byoH: _blackByoH,
      byoM: _blackByoM,
      byoS: _blackByoS,
      byoCount: _blackByoCount,
      accent: AppColors.brass,
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
    required String lang,
    required int mainH,
    required int mainM,
    required int mainS,
    required int byoH,
    required int byoM,
    required int byoS,
    required int byoCount,
    required Color accent,
    required void Function(int, int, int) onMainChanged,
    required void Function(int, int, int) onByoChanged,
    required void Function(int) onCountChanged,
  }) {
    final mainLabel = AppStrings.t(lang, 'mainTime');
    final byoyomiLabel = _isFischer
        ? AppStrings.t(lang, 'incrementTime')
        : AppStrings.t(lang, 'byoyomiTime');
    final canadaLabel = AppStrings.t(lang, 'canadaMoveCount');
    final japanLabel = AppStrings.t(lang, 'japanByoCount');

    return Column(
      children: [
        _buildTimeTile(
          label: mainLabel,
          subtitle: _formatHms(mainH, mainM, mainS),
          accent: accent,
          onTap: () async {
            final result = await _showTimePicker(
              context: context,
              initialH: mainH,
              initialM: mainM,
              initialS: mainS,
            );
            if (result != null) onMainChanged(result.h, result.m, result.s);
          },
        ),
        const SizedBox(height: AppDimens.gap16),
        if (!_isSimple)
          Column(
            children: [
              _buildTimeTile(
                label: byoyomiLabel,
                subtitle: _formatHms(byoH, byoM, byoS),
                accent: accent,
                onTap: () async {
                  final result = await _showTimePicker(
                    context: context,
                    initialH: byoH,
                    initialM: byoM,
                    initialS: byoS,
                  );
                  if (result != null) {
                    onByoChanged(result.h, result.m, result.s);
                  }
                },
              ),
              const SizedBox(height: AppDimens.gap16),
              if (_isCanada || _isJapan)
                _buildIntTile(
                  label: _isCanada ? canadaLabel : japanLabel,
                  value: byoCount,
                  accent: accent,
                  onTap: () async {
                    final value = await _showIntPicker(
                      context: context,
                      initial: byoCount,
                      min: 1,
                      max: 40,
                    );
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
    final whiteMainSec = _useDifferentSettings
        ? _toSeconds(_whiteMainH, _whiteMainM, _whiteMainS)
        : blackMainSec;

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

  Widget _buildTimeTile({
    required String label,
    required String subtitle,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: FantasyDecorations.panel(accented: true, accent: accent),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.parchment,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: FantasyDecorations.chip(accent: accent, radius: 12),
          child: Icon(Icons.mode_edit_outline_rounded, size: 20, color: accent),
        ),
      ),
    );
  }

  Widget _buildIntTile({
    required String label,
    required int value,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: FantasyDecorations.panel(accented: true, accent: accent),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.parchment,
          ),
        ),
        subtitle: Text(
          '$value',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: FantasyDecorations.chip(accent: accent, radius: 12),
          child: Icon(Icons.edit_outlined, size: 20, color: accent),
        ),
      ),
    );
  }

  Future<_Hms?> _showTimePicker({
    required BuildContext context,
    required int initialH,
    required int initialM,
    required int initialS,
  }) async {
    int selectedH = initialH;
    int selectedM = initialM;
    int selectedS = initialS;

    final lang = AppLanguage.current;
    final cancelLabel = AppStrings.t(lang, 'cancel');
    final pickLabel = AppStrings.t(lang, 'dialogPickTime');
    final okLabel = AppStrings.t(lang, 'ok');
    final hourLabel = AppStrings.t(lang, 'unitHour');
    final minuteLabel = AppStrings.t(lang, 'unitMinute');
    final secondLabel = AppStrings.t(lang, 'unitSecond');

    return showModalBottomSheet<_Hms>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 260,
          child: Column(
            children: [
              _PickerHeaderBar(
                cancelLabel: cancelLabel,
                title: pickLabel,
                okLabel: okLabel,
                onCancel: () => Navigator.pop(ctx),
                onOk: () =>
                    Navigator.pop(ctx, _Hms(selectedH, selectedM, selectedS)),
              ),
              const Divider(height: 1),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                          initialItem: initialH,
                        ),
                        onSelectedItemChanged: (value) => selectedH = value,
                        children: List.generate(
                          10,
                          (index) => Center(child: Text('$index $hourLabel')),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                          initialItem: initialM,
                        ),
                        onSelectedItemChanged: (value) => selectedM = value,
                        children: List.generate(
                          60,
                          (index) => Center(child: Text('$index $minuteLabel')),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                          initialItem: initialS,
                        ),
                        onSelectedItemChanged: (value) => selectedS = value,
                        children: List.generate(
                          60,
                          (index) => Center(child: Text('$index $secondLabel')),
                        ),
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

  Future<int?> _showIntPicker({
    required BuildContext context,
    required int initial,
    required int min,
    required int max,
  }) async {
    int selected = initial.clamp(min, max);
    final itemCount = max - min + 1;
    final initialIndex = (selected - min).clamp(0, itemCount - 1);

    final lang = AppLanguage.current;
    final cancelLabel = AppStrings.t(lang, 'cancel');
    final pickLabel = AppStrings.t(lang, 'dialogPick');
    final okLabel = AppStrings.t(lang, 'ok');

    return showModalBottomSheet<int>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 240,
          child: Column(
            children: [
              _PickerHeaderBar(
                cancelLabel: cancelLabel,
                title: pickLabel,
                okLabel: okLabel,
                onCancel: () => Navigator.pop(ctx),
                onOk: () => Navigator.pop(ctx, selected),
              ),
              const Divider(height: 1),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialIndex,
                  ),
                  onSelectedItemChanged: (index) => selected = min + index,
                  children: List.generate(
                    itemCount,
                    (index) => Center(child: Text('${min + index}')),
                  ),
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

/// Seçici (picker) panellerinin üst barı: İptal / başlık / Tamam.
/// Dar ekranda veya büyük sistem yazı tipinde satır taşmasın diye üç öğe de
/// gerekirse oranı bozmadan küçülür — "Tamam" her zaman görünür kalır.
class _PickerHeaderBar extends StatelessWidget {
  const _PickerHeaderBar({
    required this.cancelLabel,
    required this.title,
    required this.okLabel,
    required this.onCancel,
    required this.onOk,
  });

  final String cancelLabel;
  final String title;
  final String okLabel;
  final VoidCallback onCancel;
  final VoidCallback onOk;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: TextButton(onPressed: onCancel, child: Text(cancelLabel)),
          ),
        ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: onOk, child: Text(okLabel)),
          ),
        ),
      ],
    );
  }
}

class _Hms {
  final int h;
  final int m;
  final int s;
  _Hms(this.h, this.m, this.s);
}
