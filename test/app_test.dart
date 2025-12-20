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
/// (Timer ekranında 2 tane olur; test için bu daha sağlam)
List<String> readAllTimes(WidgetTester tester) {
  final texts = tester.widgetList<Text>(
    find.byWidgetPredicate((w) {
      return w is Text && w.data != null && RegExp(r'^\d{2}:\d{2}$').hasMatch(w.data!);
    }),
  );
  return texts.map((t) => t.data!).toList();
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

  // Başlangıçta kontrol bar görünür (visible_bar key)
  expect(find.byKey(const ValueKey('visible_bar')), findsOneWidget);
}

Future<void> showControlBarAgain(WidgetTester tester) async {
  // Eğer bar görünürse zaten ok.
  if (find.byKey(const ValueKey('visible_bar')).evaluate().isNotEmpty) return;

  // Bar gizliyse hidden_bar vardır.
  expect(find.byKey(const ValueKey('hidden_bar')), findsOneWidget);

  // child'a tap yerine, bar alanının olduğu yere tapAt yapıyoruz (ekran ortası).
  final size = tester.view.physicalSize / tester.view.devicePixelRatio;
  await tester.tapAt(Offset(size.width / 2, size.height / 2));
  await tester.pumpAndSettle();

  expect(find.byKey(const ValueKey('visible_bar')), findsOneWidget);
}

Future<void> pressPlay(WidgetTester tester) async {
  await showControlBarAgain(tester);

  final play = find.byIcon(Icons.play_arrow_rounded);
  expect(play, findsOneWidget);

  await tester.tap(play);
  await tester.pump(); // state değişsin

  // Play -> _hideControls() => bar gizlenir
  expect(find.byKey(const ValueKey('hidden_bar')), findsOneWidget);
}

Future<void> pressPause(WidgetTester tester) async {
  // Pause ikonuna basabilmek için önce bar'ı görünür yap
  await showControlBarAgain(tester);

  final pause = find.byIcon(Icons.pause_rounded);
  expect(pause, findsOneWidget);

  await tester.tap(pause);
  await tester.pumpAndSettle();

  // Pause -> bar görünür
  expect(find.byKey(const ValueKey('visible_bar')), findsOneWidget);
}

Future<void> elapseSeconds(WidgetTester tester, int seconds) async {
  // Timer.periodic (1s) daha stabil çalışsın diye tek seferde 3s yerine
  // 1'er saniye pompalıyoruz.
  for (int i = 0; i < seconds; i++) {
    await tester.pump(const Duration(seconds: 1));
  }
}

bool anyTimeChanged(List<String> before, List<String> after) {
  if (before.length != after.length) return true; // layout değiştiyse bile değişim var kabul
  for (int i = 0; i < before.length; i++) {
    if (before[i] != after[i]) return true;
  }
  return false;
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

    testWidgets('Play → Timer başlıyor ve control bar gizleniyor, zaman akıyor', (tester) async {
      _setTestScreenSize(tester);
      await startFromJapaneseByoyomi(tester);

      final before = readAllTimes(tester);
      expect(before, isNotEmpty);

      await pressPlay(tester);

      await elapseSeconds(tester, 3);

      final after = readAllTimes(tester);
      expect(after, isNotEmpty);

      // En az bir MM:SS değişmeli (aktif oyuncu azalır)
      expect(anyTimeChanged(before, after), isTrue);
    });

    testWidgets('Pause → Timer duruyor, control bar görünür, zaman duruyor', (tester) async {
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
      expect(anyTimeChanged(beforePause, afterPause), isFalse);
    });

    testWidgets('Pause → Play çalışıyor (dur → tekrar ak)', (tester) async {
      _setTestScreenSize(tester);
      await startFromJapaneseByoyomi(tester);

      // Play
      await pressPlay(tester);
      await elapseSeconds(tester, 2);

      // Pause
      await pressPause(tester);
      final pausedTimes = readAllTimes(tester);
      await elapseSeconds(tester, 2);
      final pausedTimes2 = readAllTimes(tester);

      // Pause'da değişmemeli
      expect(anyTimeChanged(pausedTimes, pausedTimes2), isFalse);

      // Tekrar Play
      await pressPlay(tester);
      final before = readAllTimes(tester);
      await elapseSeconds(tester, 2);
      final after = readAllTimes(tester);

      // Tekrar akmalı
      expect(anyTimeChanged(before, after), isTrue);
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
