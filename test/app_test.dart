import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotimer/main.dart';

/// Test ekranını büyütür (RenderFlex overflow fix) + textScale kontrolü
void _setTestScreenSize(WidgetTester tester, {Size size = const Size(1080, 1920), double devicePixelRatio = 1.0, double textScale = 1.0}) {
  final view = tester.view;

  // Ekran boyutu / DPR (yeni API)
  view.physicalSize = size;
  view.devicePixelRatio = devicePixelRatio;

  // Text scale (yeni API)
  tester.platformDispatcher.textScaleFactorTestValue = textScale;

  addTearDown(() {
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

void main() {
  group('Go Match Timer Uygulaması', () {
    testWidgets('Ana ekranda Zaman Sistemi başlığı ve zaman sistemi kartları görünüyor', (WidgetTester tester) async {
      _setTestScreenSize(tester);

      await tester.pumpWidget(const GoTimerApp());
      await tester.pumpAndSettle();

      // Ana başlık
      expect(find.text('Zaman Sistemi'), findsOneWidget);

      // Zaman sistemi kartları (UI’da görünen TR başlıklar)
      expect(find.text('Japon Byoyomi'), findsOneWidget);
      expect(find.text('Kanada Byoyomi'), findsOneWidget);
      expect(find.text('Basit Zaman'), findsOneWidget);
    });

    testWidgets('Japon Byoyomi seçilince ayar ekranı açılıyor', (WidgetTester tester) async {
      _setTestScreenSize(tester);

      await tester.pumpWidget(const GoTimerApp());
      await tester.pumpAndSettle();

      // Japon Byoyomi kartına tıkla
      await tester.tap(find.text('Japon Byoyomi'));
      await tester.pumpAndSettle();

      // AppBar başlığı: "${widget.timeSystem} Ayarları"
      // timeSystem value: 'Byoyomi' => "Byoyomi Ayarları"
      expect(find.text('Byoyomi Ayarları'), findsOneWidget);

      // Ayar ekranında beklenen alanlar
      expect(find.text('Farklı Ayar Kullan'), findsOneWidget);
      expect(find.text('Ana Süre'), findsOneWidget);
      expect(find.text('Byoyomi Süresi'), findsOneWidget);

      // Başlat butonu
      expect(find.text('Başlat'), findsOneWidget);
    });

    testWidgets('Başlat\'a basılınca oyun ekranı açılıyor ve timer + kontrol ikonları görünüyor', (WidgetTester tester) async {
      _setTestScreenSize(tester);

      await tester.pumpWidget(const GoTimerApp());
      await tester.pumpAndSettle();

      // Ana ekrandan Japon Byoyomi -> Ayarlar
      await tester.tap(find.text('Japon Byoyomi'));
      await tester.pumpAndSettle();

      // Başlat
      await tester.tap(find.text('Başlat'));
      await tester.pumpAndSettle();

      // Timer formatı (mm:ss) kontrolü
      final timeFinder = find.byWidgetPredicate((widget) => widget is Text && widget.data != null && RegExp(r'^\d{2}:\d{2}$').hasMatch(widget.data!));
      expect(timeFinder, findsAtLeastNWidgets(1));

      // Kontrol ikonları: volume, settings, play/pause
      final hasVolumeIcon = find.byIcon(Icons.volume_up_rounded).evaluate().isNotEmpty || find.byIcon(Icons.volume_off_rounded).evaluate().isNotEmpty;
      expect(hasVolumeIcon, true);

      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);

      // Başlangıçta play beklenir
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(find.byIcon(Icons.pause_rounded), findsNothing);

      // Play → Pause geçişi
      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.pump();

      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    });
  });
}
