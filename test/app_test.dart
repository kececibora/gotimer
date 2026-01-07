import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// Home'da 3 zaman sistemi kartı var ve hepsinde Icons.timer_rounded var.
/// İlk karta tıklayıp (Byoyomi) settings ekranına gider.
Future<void> goToByoyomiSettings(WidgetTester tester) async {
  await pumpApp(tester);

  final timerIcons = find.byIcon(Icons.timer_rounded);
  expect(timerIcons, findsNWidgets(3));

  await tester.tap(timerIcons.at(0));
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
  await tester.tap(allFilled.last);
  await tester.pumpAndSettle();

  // Timer ekranda MM:SS görünmeli
  expect(find.byWidgetPredicate((w) => w is Text && w.data != null && RegExp(r'^\d{2}:\d{2}$').hasMatch(w.data!)), findsAtLeastNWidgets(1));

  // Başlangıçta bar görünür
  expect(find.byKey(const ValueKey('visible_bar')), findsOneWidget);
}

/// Ekrandaki tüm "MM:SS" textlerini listeler
List<String> readAllTimes(WidgetTester tester) {
  final texts = tester.widgetList<Text>(
    find.byWidgetPredicate((w) {
      return w is Text && w.data != null && RegExp(r'^\d{2}:\d{2}$').hasMatch(w.data!);
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

  await tester.tap(find.byKey(const ValueKey('hidden_bar')), warnIfMissed: false);
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

void main() {
  // SystemSound.play test ortamında patlamasın
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'SystemSound.play') return null;
      return null;
    });
  });

  group('🟢 Go Match Timer – Universal Flow Tests', () {
    testWidgets('Home yükleniyor (3 time system kartı var)', (tester) async {
      _setTestScreenSize(tester);
      await pumpApp(tester);

      expect(find.byIcon(Icons.timer_rounded), findsNWidgets(3));
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

    testWidgets('Settings bottom sheet açılıyor ve X ile kapanıyor', (tester) async {
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
}
