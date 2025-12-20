import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotimer/main.dart';

void _setTestScreenSize(WidgetTester tester, {Size size = const Size(1080, 1920), double textScale = 1.0}) {
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

/// Ekrandaki tüm "MM:SS" textlerini listeler.
/// Timer ekranında genelde 2 tane olur (beyaz + siyah).
List<String> readAllTimes(WidgetTester tester) {
  final texts = tester.widgetList<Text>(
    find.byWidgetPredicate((w) {
      return w is Text && w.data != null && RegExp(r'^\d{2}:\d{2}$').hasMatch(w.data!);
    }),
  );
  return texts.map((t) => t.data!).toList();
}

/// Sıra bağımsız: herhangi bir time değişti mi?
bool anyTimeChangedUnordered(List<String> before, List<String> after) {
  // Çok nadir: list uzunluğu değişerse de "değişti" kabul edelim
  if (before.length != after.length) return true;

  // Multiset gibi davranmak için sayalım
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

Future<void> goToJapaneseByoyomiSettings(WidgetTester tester) async {
  await pumpApp(tester);

  await tester.tap(find.text('Japon Byoyomi'));
  await tester.pumpAndSettle();

  expect(find.textContaining('Ayar'), findsWidgets);
  expect(find.text('Başlat'), findsOneWidget);
}

Future<void> startFromJapaneseByoyomi(WidgetTester tester) async {
  await goToJapaneseByoyomiSettings(tester);

  await tester.tap(find.text('Başlat'));
  await tester.pumpAndSettle();

  // Timer ekranda MM:SS görünmeli
  expect(find.byWidgetPredicate((w) => w is Text && w.data != null && RegExp(r'^\d{2}:\d{2}$').hasMatch(w.data!)), findsAtLeastNWidgets(1));

  // Başlangıçta bar görünür
  expect(find.byKey(const ValueKey('visible_bar')), findsOneWidget);
}

/// Silik bar varken 1 kez dokununca aktif hale gelmeli.
/// (Artık bar hiç kaybolmuyor; sadece key 'hidden_bar' oluyor)
Future<void> showControlBarAgain(WidgetTester tester) async {
  if (find.byKey(const ValueKey('visible_bar')).evaluate().isNotEmpty) return;

  // Silik bar
  expect(find.byKey(const ValueKey('hidden_bar')), findsOneWidget);

  // En sağlamı: bar widget'ına tap
  await tester.tap(find.byKey(const ValueKey('hidden_bar')), warnIfMissed: false);
  await tester.pumpAndSettle();

  expect(find.byKey(const ValueKey('visible_bar')), findsOneWidget);
}

Future<void> pressPlay(WidgetTester tester) async {
  await showControlBarAgain(tester);

  final play = find.byIcon(Icons.play_arrow_rounded);
  expect(play, findsOneWidget);

  await tester.tap(play);
  await tester.pump(); // state değişsin

  // Play -> bar silikleşir (hidden_bar)
  expect(find.byKey(const ValueKey('hidden_bar')), findsOneWidget);
}

Future<void> pressPause(WidgetTester tester) async {
  // Pause ikonuna basabilmek için önce bar'ı görünür yap
  await showControlBarAgain(tester);

  final pause = find.byIcon(Icons.pause_rounded);
  expect(pause, findsOneWidget);

  await tester.tap(pause);
  await tester.pumpAndSettle();

  // Pause -> bar görünür kalır
  expect(find.byKey(const ValueKey('visible_bar')), findsOneWidget);
}

void main() {
  group('🟢 Go Match Timer – Ana Akış Testleri (main.dart son hali)', () {
    testWidgets('Ana ekran yükleniyor ve zaman sistemleri görünüyor', (tester) async {
      _setTestScreenSize(tester);
      await pumpApp(tester);

      expect(find.text('Zaman Sistemi'), findsOneWidget);
      expect(find.text('Japon Byoyomi'), findsOneWidget);
      expect(find.text('Kanada Byoyomi'), findsOneWidget);
      expect(find.text('Basit Zaman'), findsOneWidget);
    });

    testWidgets('Japon Byoyomi ayar ekranı açılıyor', (tester) async {
      _setTestScreenSize(tester);
      await goToJapaneseByoyomiSettings(tester);
    });

    testWidgets('Başlat → Timer ekranı açılıyor', (tester) async {
      _setTestScreenSize(tester);
      await startFromJapaneseByoyomi(tester);
    });

    testWidgets('Play → Timer başlıyor, bar silikleşiyor, zaman akıyor', (tester) async {
      _setTestScreenSize(tester);
      await startFromJapaneseByoyomi(tester);

      final before = readAllTimes(tester);
      expect(before, isNotEmpty);

      await pressPlay(tester);

      // 2-3 sn yeterli, 3 yapalım
      await elapseSeconds(tester, 3);

      final after = readAllTimes(tester);
      expect(after, isNotEmpty);

      // Sıra bağımsız: en az bir time değişmeli
      expect(anyTimeChangedUnordered(before, after), isTrue);
    });

    testWidgets('Pause → Timer duruyor, bar görünür, zaman duruyor', (tester) async {
      _setTestScreenSize(tester);
      await startFromJapaneseByoyomi(tester);

      await pressPlay(tester);
      await elapseSeconds(tester, 2);

      await pressPause(tester);

      final beforePause = readAllTimes(tester);
      expect(beforePause, isNotEmpty);

      await elapseSeconds(tester, 3);

      final afterPause = readAllTimes(tester);
      expect(afterPause, isNotEmpty);

      // Pause sonrası zaman değişmemeli
      expect(anyTimeChangedUnordered(beforePause, afterPause), isFalse);
    });

    testWidgets('Pause → Play çalışıyor (dur → tekrar ak)', (tester) async {
      _setTestScreenSize(tester);
      await startFromJapaneseByoyomi(tester);

      // Play
      await pressPlay(tester);
      await elapseSeconds(tester, 2);

      // Pause
      await pressPause(tester);
      final paused1 = readAllTimes(tester);
      await elapseSeconds(tester, 2);
      final paused2 = readAllTimes(tester);

      // Pause'da değişmemeli
      expect(anyTimeChangedUnordered(paused1, paused2), isFalse);

      // Tekrar Play
      await pressPlay(tester);
      final before = readAllTimes(tester);
      await elapseSeconds(tester, 2);
      final after = readAllTimes(tester);

      // Tekrar akmalı
      expect(anyTimeChangedUnordered(before, after), isTrue);
    });

    testWidgets('Ses butonu toggle oluyor', (tester) async {
      _setTestScreenSize(tester);
      await startFromJapaneseByoyomi(tester);

      final volUp = find.byIcon(Icons.volume_up_rounded);
      final volOff = find.byIcon(Icons.volume_off_rounded);

      expect(find.byKey(const ValueKey('visible_bar')), findsOneWidget);

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

    testWidgets('Settings bottom sheet açılıyor ve X ile kapanıyor', (tester) async {
      _setTestScreenSize(tester);
      await startFromJapaneseByoyomi(tester);

      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close_rounded), findsNothing);
    });
  });
}
