import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotimer/main.dart';

void _setTestScreenSize(
  WidgetTester tester, {
  Size size = const Size(1080, 1920),
  double textScale = 1.0,
}) {
  final view = tester.view;
  view.physicalSize = size;
  view.devicePixelRatio = 1.0;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;

  addTearDown(() {
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const GoTimerApp());
  await tester.pumpAndSettle();
}

Future<void> pumpTimerScreen(
  WidgetTester tester, {
  required String timeSystem,
  required int blackMainTime,
  required int whiteMainTime,
  required int blackByoyomi,
  required int whiteByoyomi,
  required int blackByoyomiCount,
  required int whiteByoyomiCount,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: TimerScreen(
        timeSystem: timeSystem,
        blackMainTime: blackMainTime,
        whiteMainTime: whiteMainTime,
        blackByoyomi: blackByoyomi,
        whiteByoyomi: whiteByoyomi,
        blackByoyomiCount: blackByoyomiCount,
        whiteByoyomiCount: whiteByoyomiCount,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Home'da 3 zaman sistemi kartı var ve her birinin farklı ikonu var.
/// Byoyomi ikonuna tıklayıp settings ekranına gider.
Future<void> goToByoyomiSettings(WidgetTester tester) async {
  await pumpApp(tester);

  expect(find.byIcon(Icons.hourglass_bottom_rounded), findsOneWidget);
  expect(find.byIcon(Icons.format_list_numbered_rounded), findsOneWidget);
  expect(find.byIcon(Icons.timer_rounded), findsOneWidget);

  // Home bir SingleChildScrollView; kucuk test yuzeyinde buton gorunur
  // alanin disinda kalabilir. Once gorunur yap, sonra tikla (CI uyumu).
  final byoyomiBtn = find.byIcon(Icons.hourglass_bottom_rounded);
  await tester.ensureVisible(byoyomiBtn);
  await tester.pumpAndSettle();
  await tester.tap(byoyomiBtn);
  await tester.pumpAndSettle();

  // Settings ekranında en altta geniş FilledButton var (Start)
  expect(find.byType(FilledButton), findsAtLeastNWidgets(1));
}

/// Settings ekranındaki en alttaki geniş FilledButton'a basıp Timer ekranına gider.
Future<void> startFromByoyomi(WidgetTester tester) async {
  await goToByoyomiSettings(tester);

  final allFilled = find.byType(FilledButton);
  expect(allFilled, findsAtLeastNWidgets(1));

  // Settings'teki Start butonu genelde en altta son FilledButton.
  // Scroll view'in altinda kalabilir; once gorunur yap (CI uyumu).
  await tester.ensureVisible(allFilled.last);
  await tester.pumpAndSettle();
  await tester.tap(allFilled.last);
  await tester.pumpAndSettle();

  // Timer ekranda MM:SS görünmeli
  expect(
    find.byWidgetPredicate(
      (w) =>
          w is Text &&
          w.data != null &&
          RegExp(r'^\d{2}:\d{2}$').hasMatch(w.data!),
    ),
    findsAtLeastNWidgets(1),
  );

  // Başlangıçta bar görünür
  expect(find.byKey(const ValueKey('visible_bar')), findsOneWidget);
}

/// Ekrandaki tüm "MM:SS" textlerini listeler
List<String> readAllTimes(WidgetTester tester) {
  final texts = tester.widgetList<Text>(
    find.byWidgetPredicate((w) {
      return w is Text &&
          w.data != null &&
          RegExp(r'^\d{2}:\d{2}$').hasMatch(w.data!);
    }),
  );
  return texts.map((t) => t.data!).toList();
}

bool anyTimeChangedUnordered(List<String> before, List<String> after) {
  if (before.length != after.length) return true;

  final Map<String, int> b = {};
  final Map<String, int> a = {};

  for (final x in before) {
    b[x] = (b[x] ?? 0) + 1;
  }
  for (final x in after) {
    a[x] = (a[x] ?? 0) + 1;
  }

  if (b.length != a.length) return true;
  for (final k in b.keys) {
    if (b[k] != a[k]) return true;
  }
  return false;
}

Future<void> elapseSeconds(WidgetTester tester, int seconds) async {
  for (int i = 0; i < seconds; i++) {
    await tester.pump(const Duration(seconds: 1));
  }
}

Future<void> showControlBarAgain(WidgetTester tester) async {
  if (find.byKey(const ValueKey('visible_bar')).evaluate().isNotEmpty) return;

  expect(find.byKey(const ValueKey('hidden_bar')), findsOneWidget);

  await tester.tap(
    find.byKey(const ValueKey('hidden_bar')),
    warnIfMissed: false,
  );
  await tester.pump();
  await tester.pumpAndSettle();

  expect(find.byKey(const ValueKey('visible_bar')), findsOneWidget);
}

Future<void> pressPlay(WidgetTester tester) async {
  await showControlBarAgain(tester);

  final play = find.byIcon(Icons.play_arrow_rounded);
  expect(play, findsOneWidget);

  await tester.tap(play);
  await tester.pump();

  expect(find.byKey(const ValueKey('hidden_bar')), findsOneWidget);
}

Future<void> pressPause(WidgetTester tester) async {
  await showControlBarAgain(tester);

  final pause = find.byIcon(Icons.pause_rounded);
  expect(pause, findsOneWidget);

  await tester.tap(pause);
  await tester.pump();
  await tester.pumpAndSettle();

  expect(find.byKey(const ValueKey('visible_bar')), findsOneWidget);
}

Future<void> tapWhiteArea(WidgetTester tester) async {
  final size = tester.getSize(find.byType(Scaffold).first);
  await tester.tapAt(Offset(size.width / 2, size.height * 0.15));
  await tester.pump();
}

Future<void> tapBlackArea(WidgetTester tester) async {
  final size = tester.getSize(find.byType(Scaffold).first);
  await tester.tapAt(Offset(size.width / 2, size.height * 0.85));
  await tester.pump();
}

void main() {
  // SystemSound.play test ortamında patlamasın
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'SystemSound.play') return null;
          return null;
        });
  });

  group('🟢 Go Match Timer – Universal Flow Tests', () {
    testWidgets('Home yükleniyor (4 time system kartı var)', (tester) async {
      _setTestScreenSize(tester);
      await pumpApp(tester);

      expect(find.byIcon(Icons.hourglass_bottom_rounded), findsOneWidget);
      expect(find.byIcon(Icons.format_list_numbered_rounded), findsOneWidget);
      expect(find.byIcon(Icons.timer_rounded), findsOneWidget);
      expect(find.byIcon(Icons.add_alarm_rounded), findsOneWidget);
    });

    testWidgets('Byoyomi settings açılıyor', (tester) async {
      _setTestScreenSize(tester);
      await goToByoyomiSettings(tester);
    });

    testWidgets('Start → Timer ekranı açılıyor', (tester) async {
      _setTestScreenSize(tester);
      await startFromByoyomi(tester);
    });

    testWidgets('Play → bar silikleşiyor, zaman akıyor', (tester) async {
      _setTestScreenSize(tester);
      await startFromByoyomi(tester);

      final before = readAllTimes(tester);
      expect(before, isNotEmpty);

      await pressPlay(tester);
      await elapseSeconds(tester, 3);

      final after = readAllTimes(tester);
      expect(after, isNotEmpty);

      expect(anyTimeChangedUnordered(before, after), isTrue);
    });

    testWidgets('Pause → zaman duruyor, bar görünür', (tester) async {
      _setTestScreenSize(tester);
      await startFromByoyomi(tester);

      await pressPlay(tester);
      await elapseSeconds(tester, 2);

      await pressPause(tester);

      final beforePause = readAllTimes(tester);
      await elapseSeconds(tester, 3);
      final afterPause = readAllTimes(tester);

      expect(anyTimeChangedUnordered(beforePause, afterPause), isFalse);
      expect(find.byKey(const ValueKey('visible_bar')), findsOneWidget);
    });

    testWidgets('Ses toggle', (tester) async {
      _setTestScreenSize(tester);
      await startFromByoyomi(tester);

      await showControlBarAgain(tester);

      final volUp = find.byIcon(Icons.volume_up_rounded);
      final volOff = find.byIcon(Icons.volume_off_rounded);

      if (volUp.evaluate().isNotEmpty) {
        await tester.tap(volUp);
        await tester.pump();
        expect(volOff, findsOneWidget);
      } else {
        await tester.tap(volOff);
        await tester.pump();
        expect(volUp, findsOneWidget);
      }
    });

    testWidgets('Settings bottom sheet açılıyor ve X ile kapanıyor', (
      tester,
    ) async {
      _setTestScreenSize(tester);
      await startFromByoyomi(tester);

      await showControlBarAgain(tester);

      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close_rounded), findsNothing);
    });
  });

  group('🧠 Oyun Mekanigi Testleri', () {
    testWidgets('Timer baslamadan dokunus move arttirmaz', (tester) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.byoyomi,
        blackMainTime: 30,
        whiteMainTime: 30,
        blackByoyomi: 10,
        whiteByoyomi: 10,
        blackByoyomiCount: 5,
        whiteByoyomiCount: 5,
      );

      final movesZero = find.textContaining('Moves: 0');
      expect(movesZero, findsNWidgets(2));

      await tapBlackArea(tester);
      await tapWhiteArea(tester);
      await tester.pumpAndSettle();

      expect(find.textContaining('Moves: 0'), findsNWidgets(2));
      expect(find.textContaining('Moves: 1'), findsNothing);
    });

    testWidgets('Kanada: taslar bitince yeni period resetlenir', (
      tester,
    ) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.canada,
        blackMainTime: 0,
        whiteMainTime: 0,
        blackByoyomi: 10,
        whiteByoyomi: 10,
        blackByoyomiCount: 2,
        whiteByoyomiCount: 7,
      );

      // Siyah oynar: 2 -> 1
      await pressPlay(tester);
      await tapBlackArea(tester);
      expect(find.textContaining('Moves left: 1 | 10s'), findsOneWidget);

      // Beyaz oynar (sira degissin)
      await tapWhiteArea(tester);

      // Siyah tekrar oynar: 1 -> 0 -> reset => 2
      await tapBlackArea(tester);
      expect(find.textContaining('Moves left: 2 | 10s'), findsOneWidget);
      expect(find.textContaining('Moves left: 6 | 10s'), findsOneWidget);
    });

    testWidgets('Geri sayim sesi 10-6 araliginda tetiklenir', (tester) async {
      _setTestScreenSize(tester);

      int beepCalls = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'SystemSound.play') beepCalls++;
            return null;
          });

      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null);
      });

      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.simple,
        blackMainTime: 12,
        whiteMainTime: 99,
        blackByoyomi: 0,
        whiteByoyomi: 0,
        blackByoyomiCount: 0,
        whiteByoyomiCount: 0,
      );

      await pressPlay(tester);
      await elapseSeconds(tester, 3); // 12 -> 09, ilk uyari penceresi (<=10)

      expect(beepCalls, greaterThanOrEqualTo(1));
    });

    testWidgets('Geri sayim sesi son saniyelere (5-1) kadar devam eder', (
      tester,
    ) async {
      // Hata #4 regresyonu: eski kod >=5 idi ve son 4 saniye sessizdi.
      _setTestScreenSize(tester);

      int beepCalls = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'SystemSound.play') beepCalls++;
            return null;
          });
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null);
      });

      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.simple,
        blackMainTime: 4,
        whiteMainTime: 99,
        blackByoyomi: 0,
        whiteByoyomi: 0,
        blackByoyomiCount: 0,
        whiteByoyomiCount: 0,
      );

      await pressPlay(tester);
      beepCalls = 0; // baslangic beep'ini disla

      // 4 -> 3 -> 2: hepsi <=10 && >=1, ses CALMALI (eski kodda sessizdi)
      await elapseSeconds(tester, 2);

      expect(beepCalls, greaterThan(0));
    });

    testWidgets('Japon Byoyomi: period bitince hak duser ve sure resetlenir', (
      tester,
    ) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.byoyomi,
        blackMainTime: 0,
        whiteMainTime: 0,
        blackByoyomi: 2,
        whiteByoyomi: 7,
        blackByoyomiCount: 2,
        whiteByoyomiCount: 9,
      );

      await pressPlay(tester);

      // Siyah byoyomi: 00:02 -> 00:01 -> 00:00 -> period reset (00:02), hak 2 -> 1
      await elapseSeconds(tester, 3);

      expect(find.text('00:02'), findsOneWidget);
      expect(find.textContaining('Byoyomi: 1 periods | 2s'), findsOneWidget);
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    });

    testWidgets('Japon Byoyomi: hamle yapilinca sure tazelenir, hak korunur', (
      tester,
    ) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.byoyomi,
        blackMainTime: 0,
        whiteMainTime: 0,
        blackByoyomi: 10,
        whiteByoyomi: 10,
        blackByoyomiCount: 3,
        whiteByoyomiCount: 3,
      );

      await pressPlay(tester);

      // Siyah byoyomi: 00:10 -> 4 saniye harca -> 00:06
      await elapseSeconds(tester, 4);
      expect(find.text('00:06'), findsOneWidget);

      // Siyah hamle yapar -> byoyomi suresi 00:10'a tazelenmeli, hak hala 3
      await tapBlackArea(tester);
      await tester.pump();

      // 00:06 kaybolur; iki oyuncu da 00:10 gosterir (siyah resetlendi)
      expect(find.text('00:06'), findsNothing);
      expect(find.text('00:10'), findsNWidgets(2));
      // Hak sayisi korunmali (dusmemeli)
      expect(find.textContaining('Byoyomi: 3 periods | 10s'), findsNWidgets(2));
    });

    testWidgets('Japon Byoyomi: N hak ayari tam N periyot verir (off-by-one yok)', (
      tester,
    ) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.byoyomi,
        blackMainTime: 0,
        whiteMainTime: 0,
        blackByoyomi: 1,
        whiteByoyomi: 99,
        blackByoyomiCount: 2,
        whiteByoyomiCount: 9,
      );

      await pressPlay(tester);

      // 2 periyot x 1 sn: hamle yapilmazsa 2 periyot sonra (~4 sn) biter.
      // Eski (hatali) mantik 3 periyot verir ve ~6 sn dayanirdi; 5 sn'de
      // yeni mantik bitmis, eski mantik hala calisir olurdu.
      await elapseSeconds(tester, 5);

      // Oyun bitti: kazanan ekrani (settingsWhite) goruntulenir -> pause ikonu yok
      expect(find.byIcon(Icons.pause_rounded), findsNothing);
      expect(find.byIcon(Icons.play_arrow_rounded), findsNothing);
      expect(find.text('White Won!'), findsOneWidget);
    });

    testWidgets('Hamle sayaci artar ve sira degisir', (tester) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.byoyomi,
        blackMainTime: 60,
        whiteMainTime: 60,
        blackByoyomi: 30,
        whiteByoyomi: 30,
        blackByoyomiCount: 5,
        whiteByoyomiCount: 5,
      );

      await pressPlay(tester);
      expect(find.textContaining('Moves: 0'), findsNWidgets(2));

      // Siyah oynar (alt alan): siyah Moves 0 -> 1, sira beyaza gecer
      await tapBlackArea(tester);
      await tester.pump();
      expect(find.textContaining('Moves: 1'), findsOneWidget);

      // Beyaz oynar (ust alan): beyaz Moves 0 -> 1
      await tapWhiteArea(tester);
      await tester.pump();
      expect(find.textContaining('Moves: 1'), findsNWidgets(2));
    });

    testWidgets('Sira disindaki oyuncunun dokunusu hamleyi gecmez', (
      tester,
    ) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.byoyomi,
        blackMainTime: 60,
        whiteMainTime: 60,
        blackByoyomi: 30,
        whiteByoyomi: 30,
        blackByoyomiCount: 5,
        whiteByoyomiCount: 5,
      );

      await pressPlay(tester);

      // Sira siyahta; beyaz alanina dokunmak hicbir sey yapmamali
      await tapWhiteArea(tester);
      await tester.pump();
      expect(find.textContaining('Moves: 0'), findsNWidgets(2));
    });

    testWidgets('Basit Zaman: sure bitince oyun biter ve rakip kazanir', (
      tester,
    ) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.simple,
        blackMainTime: 2,
        whiteMainTime: 60,
        blackByoyomi: 0,
        whiteByoyomi: 0,
        blackByoyomiCount: 0,
        whiteByoyomiCount: 0,
      );

      await pressPlay(tester);

      // Siyah 00:02 -> 00:01 -> 00:00 -> 3. tick'te oyun biter
      await elapseSeconds(tester, 3);

      expect(find.text('White Won!'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.byIcon(Icons.pause_rounded), findsNothing);
    });

    testWidgets('Ana sure bitince byoyomi suresine gecilir', (tester) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.byoyomi,
        blackMainTime: 2,
        whiteMainTime: 60,
        blackByoyomi: 30,
        whiteByoyomi: 30,
        blackByoyomiCount: 5,
        whiteByoyomiCount: 5,
      );

      await pressPlay(tester);

      // main 00:02 -> 00:01 (t1) -> main 0 (t2): ekran byoyomi 00:30'a gecer
      await elapseSeconds(tester, 2);
      expect(find.text('00:30'), findsOneWidget);
    });

    testWidgets('Kanada: blok suresi biterse oyun biter', (tester) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.canada,
        blackMainTime: 0,
        whiteMainTime: 60,
        blackByoyomi: 3,
        whiteByoyomi: 30,
        blackByoyomiCount: 5,
        whiteByoyomiCount: 25,
      );

      await pressPlay(tester);

      // 3 sn blok, hamle yok: 3->2->1->0, 4. tick'te endGame
      await elapseSeconds(tester, 5);
      expect(find.text('White Won!'), findsOneWidget);
    });
  });

  group('⏱️ Fischer (increment) Testleri', () {
    testWidgets('Fischer: hamlede ana süreye increment eklenir', (
      tester,
    ) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.fischer,
        blackMainTime: 60,
        whiteMainTime: 60,
        blackByoyomi: 10, // increment = 10 sn
        whiteByoyomi: 10,
        blackByoyomiCount: 0,
        whiteByoyomiCount: 0,
      );

      await pressPlay(tester);

      // Siyah 5 sn harcar: 00:60 -> 00:55
      await elapseSeconds(tester, 5);
      expect(find.text('00:55'), findsOneWidget);

      // Siyah hamle yapar: 55 + 10 increment = 65 -> 01:05, sıra beyaza geçer
      await tapBlackArea(tester);
      await tester.pump();
      expect(find.text('01:05'), findsOneWidget);
    });

    testWidgets('Fischer: increment 1. hamleden itibaren geçerli', (
      tester,
    ) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.fischer,
        blackMainTime: 30,
        whiteMainTime: 30,
        blackByoyomi: 5,
        whiteByoyomi: 5,
        blackByoyomiCount: 0,
        whiteByoyomiCount: 0,
      );

      await pressPlay(tester);

      // İlk hamle hemen yapılır (süre harcamadan): 30 + 5 = 35 -> 00:35
      await tapBlackArea(tester);
      await tester.pump();
      expect(find.text('00:35'), findsOneWidget);
    });

    testWidgets('Fischer: ana süre biterse oyun biter', (tester) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.fischer,
        blackMainTime: 2,
        whiteMainTime: 60,
        blackByoyomi: 10,
        whiteByoyomi: 10,
        blackByoyomiCount: 0,
        whiteByoyomiCount: 0,
      );

      await pressPlay(tester);

      // Hamle yapılmazsa increment eklenmez: 2 -> 1 -> 0 -> 3. tick oyun biter
      await elapseSeconds(tester, 3);
      expect(find.text('White Won!'), findsOneWidget);
      expect(find.byIcon(Icons.pause_rounded), findsNothing);
    });

    testWidgets('Fischer: hızlı hamlelerde süre birikir (sınırsız)', (
      tester,
    ) async {
      _setTestScreenSize(tester);
      await pumpTimerScreen(
        tester,
        timeSystem: TimeSystemIds.fischer,
        blackMainTime: 20,
        whiteMainTime: 20,
        blackByoyomi: 10,
        whiteByoyomi: 10,
        blackByoyomiCount: 0,
        whiteByoyomiCount: 0,
      );

      await pressPlay(tester);

      // Siyah hemen oynar: 20 + 10 = 30 (başlangıçtan yüksek) -> 00:30
      await tapBlackArea(tester); // sıra beyaza
      await tester.pump();
      await tapWhiteArea(tester); // beyaz oynar, sıra siyaha
      await tester.pump();
      // Siyah tekrar hemen oynar: 30 + 10 = 40 -> 00:40
      await tapBlackArea(tester);
      await tester.pump();
      expect(find.text('00:40'), findsOneWidget);
    });
  });
}
