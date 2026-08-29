import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotimer/main.dart';

/// Regresyon: küçük ekranlarda / büyük sistem yazı tipinde hiçbir ekran
/// taşmamalı ve "Tamam" (OK) butonu her zaman erişilebilir olmalı.
///
/// Gerçek şikâyet: bazı telefonlarda canlı ayarlar panelinde OK butonu
/// ekranın altında kalıp tıklanamıyordu (panel kaydırılamayan bir Column'du).

/// Test edilen yüzeyler: küçük (iPhone SE / eski Android), yaygın 5.x"
/// (ör. Honor COR-L29 → 360x640 dp) ve modern telefon.
const _sizes = [Size(320, 568), Size(360, 640), Size(390, 844)];

/// 1.3 = Android/iOS "en büyük" yazı tipi ayarına yakın.
const _scales = [1.0, 1.3];

const _systems = [
  TimeSystemIds.simple,
  TimeSystemIds.byoyomi,
  TimeSystemIds.canada,
  TimeSystemIds.fischer,
];

void _setScreen(WidgetTester tester, Size size, double textScale) {
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

Future<void> _pumpTimer(WidgetTester tester, String timeSystem) async {
  await tester.pumpWidget(
    MaterialApp(
      home: TimerScreen(
        timeSystem: timeSystem,
        blackMainTime: 900,
        whiteMainTime: 900,
        blackByoyomi: 30,
        whiteByoyomi: 30,
        blackByoyomiCount: 5,
        whiteByoyomiCount: 5,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// RenderFlex taşması varsa test framework'ü hata fırlatır.
void _expectNoOverflow(WidgetTester tester, String where) {
  final error = tester.takeException();
  expect(
    error,
    isNull,
    reason: '$where taşıyor:\n${error?.toString().split('\n').first}',
  );
}

/// Butonun ekran sınırları içinde kaldığını (yani dokunulabilir olduğunu)
/// doğrular.
void _expectReachable(WidgetTester tester, Finder button, String label) {
  expect(button, findsOneWidget, reason: '$label bulunamadı');
  final rect = tester.getRect(button);
  final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
  expect(
    rect.bottom <= screen.height,
    isTrue,
    reason:
        '$label ekranın altında kalıyor '
        '(alt kenar ${rect.bottom}, ekran ${screen.height})',
  );
  expect(rect.top >= 0, isTrue, reason: '$label ekranın üstünde kalıyor');
}

void main() {
  for (final size in _sizes) {
    for (final scale in _scales) {
      final tag = '${size.width.toInt()}x${size.height.toInt()} @${scale}x';

      group('$tag —', () {
        testWidgets('ana sayfa taşmıyor', (tester) async {
          _setScreen(tester, size, scale);
          await tester.pumpWidget(const GoTimerApp());
          await tester.pumpAndSettle();
          _expectNoOverflow(tester, 'Ana sayfa');
        });

        for (final system in _systems) {
          testWidgets('$system: ayar ekranı taşmıyor', (tester) async {
            _setScreen(tester, size, scale);
            await tester.pumpWidget(
              MaterialApp(home: TimerSettingsScreen(timeSystem: system)),
            );
            await tester.pumpAndSettle();
            _expectNoOverflow(tester, '$system ayar ekranı');
          });

          testWidgets('$system: oyun ekranı taşmıyor', (tester) async {
            _setScreen(tester, size, scale);
            await _pumpTimer(tester, system);
            _expectNoOverflow(tester, '$system oyun ekranı');
          });

          testWidgets('$system: canlı ayarlarda OK erişilebilir', (
            tester,
          ) async {
            _setScreen(tester, size, scale);
            await _pumpTimer(tester, system);
            await tester.tap(find.byIcon(Icons.settings_rounded));
            await tester.pumpAndSettle();

            _expectNoOverflow(tester, '$system canlı ayarlar');
            _expectReachable(
              tester,
              find.widgetWithText(FilledButton, 'OK'),
              '$system canlı ayarlar OK butonu',
            );
          });
        }

        testWidgets('canlı ayarlarda süre seçici taşmıyor', (tester) async {
          _setScreen(tester, size, scale);
          await _pumpTimer(tester, TimeSystemIds.byoyomi);
          await tester.tap(find.byIcon(Icons.settings_rounded));
          await tester.pumpAndSettle();
          _expectNoOverflow(tester, 'canlı ayarlar');

          await tester.tap(find.byIcon(Icons.edit_outlined).first);
          await tester.pumpAndSettle();
          _expectNoOverflow(tester, 'süre seçici');
        });

        testWidgets('ayar ekranında süre seçici taşmıyor', (tester) async {
          _setScreen(tester, size, scale);
          await tester.pumpWidget(
            const MaterialApp(
              home: TimerSettingsScreen(timeSystem: TimeSystemIds.byoyomi),
            ),
          );
          await tester.pumpAndSettle();

          final edit = find.byIcon(Icons.edit_outlined).first;
          await tester.ensureVisible(edit);
          await tester.pumpAndSettle();
          await tester.tap(edit);
          await tester.pumpAndSettle();
          _expectNoOverflow(tester, 'ayar ekranı süre seçici');
        });
      });
    }
  }
}
