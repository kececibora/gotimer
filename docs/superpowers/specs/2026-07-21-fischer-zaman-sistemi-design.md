# Fischer (Increment) Zaman Sistemi — Tasarım

**Sürüm hedefi:** 2.1.0+9 · **Tarih:** 21 Temmuz 2026

## Amaç
gotimer'a dördüncü zaman sistemi olarak **standart Fischer increment**'i eklemek.
Mevcut sistemler: Japon Byoyomi, Kanada Byoyomi, Basit (Sudden Death).

## Davranış (standart Fischer / FIDE)
- Her oyuncunun bir **ana süresi** vardır ve sırası geldiğinde azalır.
- Oyuncu hamlesini tamamlayınca (sıra devri) ana süresine sabit bir **ek süre
  (increment)** eklenir. Örn. +5 sn.
- Increment **1. hamleden itibaren** geçerlidir; birikme **sınırsızdır** (hızlı
  oynayan süre kazanır).
- Ana süre 0'a inerse oyun biter, rakip kazanır. Ayrı periyot / hak kavramı YOKTUR.

## Mimariye oturma
Mevcut `TimerScreen` alanları yeniden kullanılır — constructor değişmez:
- `blackByoyomi` / `whiteByoyomi` → Fischer'da **increment miktarı (saniye)**.
- `byoyomiCount` → Fischer'da kullanılmaz (0 geçilir).

### Kod noktaları (`lib/main.dart`)
1. `TimeSystemIds` (satır 33): `static const fischer = 'fischer';`
2. Yeni getter: `bool get _isFischer => widget.timeSystem == TimeSystemIds.fischer;`
   (hem `_TimerScreenState` hem ayar state'inde).
3. `_tickBlack` / `_tickWhite` (527, 567): Fischer, Basit ile aynı yolu izler —
   ana süre azalır, 0 olunca `_endGame`. Byoyomi dalına girmez. (Uygulama: `_isSimple`
   kontrolünü `_isSimple || _isFischer` yapmak yeterli; byoyomi bloklarına Fischer
   asla düşmez çünkü Fischer'da ana süre bitince oyun biter.)
4. `_passTurn` (614): hamle sayısı arttıktan sonra, Fischer için ilgili oyuncunun
   ana süresine increment eklenir:
   `if (_isFischer) _blackMainTime += widget.blackByoyomi;` (beyaz için simetrik).
   Ana süre > 0 iken de eklenir (oyun bitmediyse). Üst sınır yok.
5. Ayar ekranı `_buildPlayerBlock` (1900): ikinci tile Fischer'da **"Ek Süre /
   Increment"** etiketiyle görünür (aynı `_showTimePicker`, saniye girer). Sayı
   (count) tile'ı gösterilmez (zaten `_isCanada || _isJapan` ile kapılı).
6. Ana ekran (150-175): dördüncü kart — Fischer. İkon önerisi: `Icons.add_alarm_rounded`.
7. Çalışan ekran: Fischer, Basit gibi sade görünür; büyük ana süre + altında küçük
   **"+Ns / hamle"** bilgisi (statik, `incrementInfo` çevirisi).

## Çeviriler (`lib/translate/translate.dart`, 9 dil)
Yeni anahtarlar: `fischerTitle`, `fischerDesc`, `incrementTime` (ayar etiketi),
`incrementInfo` (çalışan ekran, `+{n}s` biçimli). UTF-8 güvenliği için Python
script ile üretilecek; karakter limiti yok (uygulama içi).

## Testler (`test/app_test.dart`)
Yeni mekanik testleri:
1. Fischer: hamlede ana süreye increment eklenir.
2. Fischer: increment 1. hamleden itibaren geçerli.
3. Fischer: ana süre biterse oyun biter (increment yokken).
4. Fischer: hızlı hamlede süre birikir (sınırsız).
Mevcut evrensel test güncellemesi: *"3 time system kartı var"* → **4 kart**.
Hedef: `flutter test` + `flutter analyze` temiz.

## Mağaza (v2.1.0)
- 10 dilde açıklamaların "TIME SYSTEMS" bölümüne Fischer satırı eklenir.
- 2.1.0 sürüm notu (10 dil): "Fischer (increment) zaman sistemi eklendi."
- Ekran görüntüleri yenilenir: ana ekran otomatik 4 kart; ek olarak Fischer çalışan
  görseli. iPhone 6.9" + iPad 13" (App Store), telefon+tablet (Play).
- Sürüm 2.1.0+9; iOS `flutter build ipa` (test-hedefi kazasına karşı fastlane
  bekçisi devrede) → TestFlight → inceleme; Android AAB → Play production.

## Kapsam dışı (YAGNI)
- Bronstein / basit gecikme varyantları (yalnızca standart increment).
- Increment üst sınırı / tavan.
- Cihaz diline göre otomatik dil (varsayılan İngilizce korunur).
