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
import 'ui/app_theme.dart';

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
          home: const TimeSystemScreen(),
        );
      },
    );
  }
}

// ============ Time System Selection Screen ============
class TimeSystemScreen extends StatelessWidget {
  const TimeSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<GoThemeId>(
      valueListenable: AppThemeController.notifier,
      builder: (context, selectedTheme, child) {
        return ValueListenableBuilder<String>(
          valueListenable: AppLanguage.notifier,
          builder: (context, lang, _) {
            return Scaffold(
              backgroundColor: AppColors.bg,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [LanguageButton()],
                              ),

                              const SizedBox(height: 50),

                              Text(
                                AppStrings.t(lang, 'appSubtitle'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppDimens.gap12),
                              Text(
                                AppStrings.t(lang, 'timeSystemTitle'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: AppDimens.gap16),
                              _themeSelector(
                                lang: lang,
                                selectedTheme: selectedTheme,
                              ),
                              const SizedBox(height: AppDimens.gap20),

                              _timeSystemButton(
                                context,
                                TimeSystemIds.byoyomi,
                                AppStrings.t(lang, 'byoyomiTitle'),
                                AppStrings.t(lang, 'byoyomiDesc'),
                              ),
                              const SizedBox(height: AppDimens.gap16),
                              _timeSystemButton(
                                context,
                                TimeSystemIds.canada,
                                AppStrings.t(lang, 'canadaTitle'),
                                AppStrings.t(lang, 'canadaDesc'),
                              ),
                              const SizedBox(height: AppDimens.gap16),
                              _timeSystemButton(
                                context,
                                TimeSystemIds.simple,
                                AppStrings.t(lang, 'simpleTitle'),
                                AppStrings.t(lang, 'simpleDesc'),
                              ),

                              const SizedBox(height: AppDimens.gap16),
                              Text(
                                'v.1.1.1',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary.withOpacity(
                                    0.75,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AppDimens.gap24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InfoButton(
                                    languageCode: lang,
                                  ), // 👈 SAĞ ALT (Info)
                                  const HelpButton(), // 👈 SOL ALT (Nasıl Kullanılır)
                                ],
                              ),
                              const SizedBox(height: AppDimens.gap8),
                            ],
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
      },
    );
  }

  String _themeTitle(String lang) => lang == 'tr' ? 'Tema Seçimi' : 'Theme';

  String _themeName(String lang, GoThemeId theme) {
    final isTr = lang == 'tr';
    switch (theme) {
      case GoThemeId.classic:
        return isTr ? 'Orijinal' : 'Original';
      case GoThemeId.wood:
        return isTr ? 'Ahsap Uzak Dogu' : 'Wood Dojo';
    }
  }

  Widget _themeSelector({
    required String lang,
    required GoThemeId selectedTheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _themeTitle(lang),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _themeOptionCard(
              icon: Icons.layers_rounded,
              label: _themeName(lang, GoThemeId.classic),
              selected: selectedTheme == GoThemeId.classic,
              onTap: () => AppThemeController.setTheme(GoThemeId.classic),
            ),
            const SizedBox(width: 8),
            _themeOptionCard(
              icon: Icons.temple_buddhist_rounded,
              label: _themeName(lang, GoThemeId.wood),
              selected: selectedTheme == GoThemeId.wood,
              onTap: () => AppThemeController.setTheme(GoThemeId.wood),
            ),
          ],
        ),
      ],
    );
  }

  Widget _themeOptionCard({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          height: 78,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.controlButton.withOpacity(0.88)
                : AppColors.card.withOpacity(0.82),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.accent : Colors.white24,
              width: selected ? 1.4 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? AppColors.accent : Colors.white,
                size: 20,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeSystemButton(
    BuildContext context,
    String systemId,
    String title,
    String description,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.radius24),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimerSettingsScreen(timeSystem: systemId),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppDimens.radius24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(_timeSystemIcon(systemId), color: Colors.white, size: 32),
            const SizedBox(width: AppDimens.gap18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppDimens.gap4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
      case TimeSystemIds.simple:
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
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.gap12),
        child: Container(
          width: AppDimens.controlButtonWidth,
          height: AppDimens.controlButtonHeight,
          decoration: BoxDecoration(
            color: AppColors.controlButton,
            borderRadius: BorderRadius.circular(AppDimens.radius12),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      );
    }

    return Container(
      key: ValueKey(_controlsVisible ? 'visible_bar' : 'hidden_bar'),
      color: AppColors.controlBar,
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

    if (_isSimple) {
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

    if (_isSimple) {
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

        if (_blackMainTime <= 0) {
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

        if (_whiteMainTime <= 0) {
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
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radius24),
        ),
      ),
      builder: (sheetContext) {
        Widget timeTile(String title, int seconds, VoidCallback onTap) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.controlBar.withOpacity(0.35),
              borderRadius: BorderRadius.circular(AppDimens.radius20),
            ),
            child: ListTile(
              onTap: onTap,
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                _formatHmsFromSeconds(seconds),
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              trailing: const Icon(Icons.edit_outlined, color: Colors.white70),
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
            decoration: BoxDecoration(
              color: AppColors.controlBar.withOpacity(0.35),
              borderRadius: BorderRadius.circular(AppDimens.radius20),
            ),
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
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                '$value',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              trailing: const Icon(Icons.edit_outlined, color: Colors.white70),
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
                        color: Colors.white24,
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
                                      color: AppColors.card,
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
                if (!_isSimple) ...[
                  timeTile(byoyomiTimeLabel, _blackByoyomiRemaining, () async {
                    final hms = await _showTimePickerLive(
                      context: sheetContext,
                      initialSeconds: _blackByoyomiRemaining,
                    );
                    if (hms != null) {
                      setState(() => _blackByoyomiRemaining = hms);
                    }
                  }),
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
                if (!_isSimple) ...[
                  timeTile(byoyomiTimeLabel, _whiteByoyomiRemaining, () async {
                    final hms = await _showTimePickerLive(
                      context: sheetContext,
                      initialSeconds: _whiteByoyomiRemaining,
                    );
                    if (hms != null) {
                      setState(() => _whiteByoyomiRemaining = hms);
                    }
                  }),
                  intTile(
                    countLabel,
                    _whiteByoyomiCount,
                    0,
                    99,
                    (v) => setState(() => _whiteByoyomiCount = v),
                  ),
                ],

                const SizedBox(height: AppDimens.gap12),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(cancelLabel),
                  ),
                  Text(
                    pickLabel,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, h * 3600 + m * 60 + s),
                    child: Text(okLabel),
                  ),
                ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(cancelLabel),
                  ),
                  Text(
                    pickLabel,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, selected),
                    child: Text(okLabel),
                  ),
                ],
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

          return Scaffold(
            body: Container(
              color: Colors.red,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      winText,
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.popUntil(context, (route) => route.isFirst),
                      child: Text(
                        AppStrings.t(lang, 'backToHome'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
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
    final Color backgroundColor = isActive
        ? AppColors.active
        : (isBlack ? AppColors.blackBase : AppColors.whiteBase);
    final Color textColor = isActive
        ? const Color(0xFF222222)
        : (isBlack ? Colors.white : const Color(0xFF111111));

    final currentDisplayTime = mainTime > 0 ? mainTime : byoyomiRemaining;

    // ✅ DİNAMİK BYOYOMI BİLGİSİ (kalan hak + kalan süre)
    String byoyomiInfo = '';

    if (!_isSimple && byoyomiCount > 0) {
      final fixedSec = isBlack ? widget.blackByoyomi : widget.whiteByoyomi;
      if (widget.timeSystem == TimeSystemIds.byoyomi) {
        final template = AppStrings.t(lang, 'timerJapanInfo');
        byoyomiInfo = template
            .replaceFirst('{count}', '$byoyomiCount')
            .replaceFirst('{seconds}', '$fixedSec');
      } else if (widget.timeSystem == TimeSystemIds.canada) {
        final template = AppStrings.t(lang, 'timerCanadaInfo');
        byoyomiInfo = template
            .replaceFirst('{count}', '$byoyomiCount')
            .replaceFirst('{seconds}', '$fixedSec');
      }
    }

    final movesLabel = AppStrings.t(lang, 'moves');

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
              child: Text(
                '$movesLabel: $moves',
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.gap8),
            Text(
              _formatTime(currentDisplayTime),
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: textColor,
              ),
            ),
            if (byoyomiInfo.isNotEmpty) ...[
              const SizedBox(height: AppDimens.gap8),
              Text(
                byoyomiInfo,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textColor.withOpacity(0.9),
                ),
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

  bool get _isSimple => widget.timeSystem == TimeSystemIds.simple;
  bool get _isJapan => widget.timeSystem == TimeSystemIds.byoyomi;
  bool get _isCanada => widget.timeSystem == TimeSystemIds.canada;

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
                    title: Text(
                      AppStrings.t(lang, 'settingsDifferent'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white70,
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
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _onStartPressed,
                      child: Text(
                        AppStrings.t(lang, 'btnStart'),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
    required void Function(int, int, int) onMainChanged,
    required void Function(int, int, int) onByoChanged,
    required void Function(int) onCountChanged,
  }) {
    final mainLabel = AppStrings.t(lang, 'mainTime');
    final byoyomiLabel = AppStrings.t(lang, 'byoyomiTime');
    final canadaLabel = AppStrings.t(lang, 'canadaMoveCount');
    final japanLabel = AppStrings.t(lang, 'japanByoCount');

    return Column(
      children: [
        _buildTimeTile(
          label: mainLabel,
          subtitle: _formatHms(mainH, mainM, mainS),
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
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimens.radius20),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppDimens.radius12),
          ),
          child: const Icon(
            Icons.mode_edit_outline_rounded,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildIntTile({
    required String label,
    required int value,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimens.radius20),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          '$value',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppDimens.radius12),
          ),
          child: const Icon(Icons.edit_outlined, size: 20, color: Colors.white),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(cancelLabel),
                  ),
                  Text(
                    pickLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(
                      ctx,
                      _Hms(selectedH, selectedM, selectedS),
                    ),
                    child: Text(okLabel),
                  ),
                ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(cancelLabel),
                  ),
                  Text(
                    pickLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, selected),
                    child: Text(okLabel),
                  ),
                ],
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

class _Hms {
  final int h;
  final int m;
  final int s;
  _Hms(this.h, this.m, this.s);
}
