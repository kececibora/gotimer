import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotimer/main.dart'; // pubspec.yaml -> name: gotimer

void main() {
  group('Go Match Timer Uygulaması', () {
    testWidgets('Ana ekranda Zaman Sistemi başlığı ve zaman sistemi butonları görünüyor', (WidgetTester tester) async {
      // Uygulamayı başlat
      await tester.pumpWidget(const GoTimerApp());

      // Başlık
      expect(find.text('Zaman Sistemi'), findsOneWidget);

      // Zaman sistemi seçenekleri
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

      // Ayar blokları (mevcut UI’ya göre)
      expect(find.text('Farklı Ayar Kullan'), findsOneWidget);
      expect(find.text('Ana Süre'), findsOneWidget);
      expect(find.text('Byoyomi Süresi'), findsOneWidget);

      // Başlat butonu
      expect(find.text('Başlat'), findsOneWidget);
    });

    testWidgets('Ayarlar kaydedilip Başlat\'a basılınca timer ekranı açılıyor ve sayaç ile play/pause ikonları görünüyor', (WidgetTester tester) async {
      await tester.pumpWidget(const GoTimerApp());

      // Ana ekrandan Byoyomi -> Ayar ekranına geç
      await tester.tap(find.text('Byoyomi'));
      await tester.pumpAndSettle();

      // Başlat butonuna bas
      await tester.tap(find.text('Başlat'));
      await tester.pumpAndSettle();

      // Timer ekranında süre (mm:ss) formatında en az bir metin olmalı
      final timeFinder = find.byWidgetPredicate((widget) => widget is Text && RegExp(r'^\d{2}:\d{2}$').hasMatch(widget.data ?? ''));
      expect(timeFinder, findsAtLeastNWidgets(1));

      // Kontrol barında başlangıçta play ikonunu görmeliyiz
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(find.byIcon(Icons.pause_rounded), findsNothing);

      // Play ikonuna tıkla -> pause ikonuna dönmeli
      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.pump(); // state değişimi için

      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    });
  });
}
