import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:gotimer/main.dart';
import 'package:gotimer/widgets/change_lang_widgets.dart';

// Play Store pazarlama gorselleri uretir.
// Calistirma:
//   flutter drive \
//     --driver=test_driver/integration_test.dart \
//     --target=integration_test/screenshot_test.dart \
//     -d <ios-simulator-udid>
// Gorseller proje kokunde store_screenshots/ altina yazilir.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Onceki ekrani (ve calisan timer'ini) tamamen sok, sonra yeni ekrani pump et.
  Future<void> teardown(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pump();
  }

  // Bir TimerScreen'i pump edip baslat (aktif oyuncu vurgulu gorunum) ve cek.
  Future<void> shootRunningTimer(
    WidgetTester tester,
    Widget timer,
    String name,
  ) async {
    await teardown(tester);
    await tester.pumpWidget(
      MaterialApp(debugShowCheckedModeBanner: false, home: timer),
    );
    await tester.pumpAndSettle();
    // Calisan saatte periodic timer oldugu icin pumpAndSettle KULLANILMAZ.
    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pump(); // setState
    await tester.pump(const Duration(milliseconds: 350)); // bar silikleme animasyonu
    await binding.takeScreenshot(name);
  }

  testWidgets('store screenshots', (tester) async {
    // Dil, --dart-define=SCREENSHOT_LANG=<kod> ile secilir (uygulama sistem
    // dilini degil, uygulama ici secimi kullanir).
    const lang = String.fromEnvironment('SCREENSHOT_LANG', defaultValue: 'en');
    AppLanguage.set(lang);

    // 1) Ana ekran (zaman sistemi secimi)
    await tester.pumpWidget(const GoTimerApp());
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('01_home');

    // 2) Byoyomi ayar ekrani
    final byoyomiBtn = find.byIcon(Icons.hourglass_bottom_rounded);
    await tester.ensureVisible(byoyomiBtn);
    await tester.pumpAndSettle();
    await tester.tap(byoyomiBtn);
    await tester.pumpAndSettle();
    await binding.takeScreenshot('02_settings');

    // 3) Japon Byoyomi - calisan saat (siyah byoyomi'de, mac ortasi gorunum)
    await shootRunningTimer(
      tester,
      const TimerScreen(
        timeSystem: TimeSystemIds.byoyomi,
        blackMainTime: 0,
        whiteMainTime: 1234,
        blackByoyomi: 30,
        whiteByoyomi: 30,
        blackByoyomiCount: 3,
        whiteByoyomiCount: 3,
      ),
      '03_byoyomi_running',
    );

    // 4) Kanada Byoyomi - calisan saat
    await shootRunningTimer(
      tester,
      const TimerScreen(
        timeSystem: TimeSystemIds.canada,
        blackMainTime: 0,
        whiteMainTime: 1500,
        blackByoyomi: 300,
        whiteByoyomi: 300,
        blackByoyomiCount: 25,
        whiteByoyomiCount: 25,
      ),
      '04_canada_running',
    );

    // 5) Basit Zaman - calisan saat
    await shootRunningTimer(
      tester,
      const TimerScreen(
        timeSystem: TimeSystemIds.simple,
        blackMainTime: 600,
        whiteMainTime: 537,
        blackByoyomi: 0,
        whiteByoyomi: 0,
        blackByoyomiCount: 0,
        whiteByoyomiCount: 0,
      ),
      '05_simple_running',
    );

    // Son ekranin timer'ini durdur (pending timer hatasini onler).
    await teardown(tester);
  });
}
