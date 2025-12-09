import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:gotimer/main.dart'; // pubspec.yaml -> name: gotimer

void main() {
  group('EsGo Timer Uygulaması', () {
    testWidgets('Ana ekranda Zaman Sistemi başlığı ve butonlar görünüyor', (WidgetTester tester) async {
      // Uygulamayı başlat
      await tester.pumpWidget(const GoTimerApp());

      // Ana başlık
      expect(find.text('Zaman Sistemi'), findsOneWidget);

      // Zaman sistemi butonları
      expect(find.text('Byoyomi'), findsOneWidget);
      expect(find.text('Kanada Byoyomi'), findsOneWidget);
      expect(find.text('Basit Zaman'), findsOneWidget);
    });

    testWidgets('Byoyomi seçilince ayar ekranı açılıyor', (WidgetTester tester) async {
      await tester.pumpWidget(const GoTimerApp());

      // Byoyomi butonuna tıkla
      await tester.tap(find.text('Byoyomi'));
      await tester.pumpAndSettle();

      // AppBar başlığı
      expect(find.text('Byoyomi Ayarları'), findsOneWidget);

      // Alanlar ve buton
      expect(find.text('Ana Süre (Saniye)'), findsOneWidget);
      expect(find.text('Byoyomi (Saniye)'), findsOneWidget);
      expect(find.text('Başlat'), findsOneWidget);
    });

    testWidgets('Ayarlar kaydedilip timer ekranı açılıyor', (WidgetTester tester) async {
      await tester.pumpWidget(const GoTimerApp());

      // Byoyomi -> Ayarlar ekranına geç
      await tester.tap(find.text('Byoyomi'));
      await tester.pumpAndSettle();

      // Direkt Başlat'a bas (varsayılan değerlerle)
      await tester.tap(find.text('Başlat'));
      await tester.pumpAndSettle();

      // Timer ekranına geçildi mi? (Siyah oyuncu yazısı var mı?)
      expect(find.text('Siyah'), findsOneWidget);

      // Ekranda süre biçiminde (mm:ss) en az bir metin olsun
      final timeFinder = find.byWidgetPredicate((widget) => widget is Text && RegExp(r'^\d{2}:\d{2}$').hasMatch(widget.data ?? ''));
      expect(timeFinder, findsAtLeastNWidgets(1));

      // Durdur / Devam Et butonu görünüyor mu? (başlangıçta Devam Et)
      expect(find.text('Devam Et'), findsOneWidget);
    });

    testWidgets('Devam Et butonu sayaç başlatıp Durdur’a dönüşüyor', (WidgetTester tester) async {
      await tester.pumpWidget(const GoTimerApp());

      // Byoyomi -> Başlat
      await tester.tap(find.text('Byoyomi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Başlat'));
      await tester.pumpAndSettle();

      // İlk durumda "Devam Et"
      expect(find.text('Devam Et'), findsOneWidget);

      // Butona bas
      await tester.tap(find.text('Devam Et'));
      await tester.pump();

      // Artık "Durdur" olmalı
      expect(find.text('Durdur'), findsOneWidget);
    });

    testWidgets('Ekrana tıklayınca sıra Siyah <-> Beyaz değişiyor', (WidgetTester tester) async {
      await tester.pumpWidget(const GoTimerApp());

      // Byoyomi -> Başlat
      await tester.tap(find.text('Byoyomi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Başlat'));
      await tester.pumpAndSettle();

      // Başlangıç: Siyah
      expect(find.text('Siyah'), findsOneWidget);
      expect(find.text('Beyaz'), findsNothing);

      // Ekrana tıkla (GestureDetector tüm body'yi sarıyor)
      await tester.tap(find.byType(Scaffold));
      await tester.pump();

      // Şimdi Beyaz olmalı
      expect(find.text('Beyaz'), findsOneWidget);
      expect(find.text('Siyah'), findsNothing);
    });
  });
}
