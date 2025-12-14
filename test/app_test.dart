import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotimer/main.dart';

/// Test ekranını büyütür (RenderFlex overflow fix)
Future<void> _setTestScreenSize(WidgetTester tester, {Size size = const Size(1080, 1920), double textScale = 1.0}) async {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  binding.window.physicalSizeTestValue = size;
  binding.window.devicePixelRatioTestValue = 1.0;

  // Text scale (bazı cihazlarda büyüyüp overflow yapmasın)
  tester.binding.platformDispatcher.textScaleFactorTestValue = textScale;

  addTearDown(() {
    binding.window.clearPhysicalSizeTestValue();
    binding.window.clearDevicePixelRatioTestValue();
    tester.binding.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

void main() {
  group('Go Match Timer Uygulaması', () {
    testWidgets('Ana ekranda Zaman Sistemi başlığı ve zaman sistemi kartları görünüyor', (WidgetTester tester) async {
      await _setTestScreenSize(tester);

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
      await _setTestScreenSize(tester);

      await tester.pumpWidget(const GoTimerApp());
      await tester.pumpAndSettle();

      // Japon Byoyomi kartına tıkla
      await tester.tap(find.text('Japon Byoyomi'));
      await tester.pumpAndSettle();

      // AppBar başlığı senin kodunda: "${widget.timeSystem} Ayarları"
      // timeSystem value: 'Byoyomi' olduğundan başlık "Byoyomi Ayarları" olur.
      expect(find.text('Byoyomi Ayarları'), findsOneWidget);

      // Ayar ekranında beklenen alanlar
      expect(find.text('Farklı Ayar Kullan'), findsOneWidget);
      expect(find.text('Ana Süre'), findsOneWidget);
      expect(find.text('Byoyomi Süresi'), findsOneWidget);

      // Başlat butonu
      expect(find.text('Başlat'), findsOneWidget);
    });

    testWidgets('Başlat\'a basılınca oyun ekranı açılıyor ve timer + kontrol ikonları görünüyor', (WidgetTester tester) async {
      await _setTestScreenSize(tester);

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

      // Kontrol ikonları: Timer ekranında 3 buton var: volume, settings, play/pause
      expect(find.byIcon(Icons.volume_up_rounded).evaluate().isNotEmpty || find.byIcon(Icons.volume_off_rounded).evaluate().isNotEmpty, true);

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
