# Go Match Timer — Kod İnceleme Raporu

**Tarih:** 2026-06-27
**Kapsam:** `lib/main.dart` zaman kontrolü mantığı (özellikle **Japon Byoyomi**)
**İncelenen sürüm:** 1.1.0+5 (`master`)

---

## 1. Özet

Uygulama üç zaman sistemi sunuyor: **Japon Byoyomi**, **Kanada Byoyomi** ve **Basit Zaman**.
Tüm sayaç mantığı tek dosyada (`lib/main.dart`, 2185 satır), `_TimerScreenState` içinde toplanmış.

İnceleme sonucunda **Kanada Byoyomi** ve **Basit Zaman** sistemleri esas olarak doğru çalışıyor.
Ancak **Japon Byoyomi'de kuralın temelini bozan kritik bir mantık hatası** var ve bunu çevreleyen
iki ikincil hata daha bulunuyor. Aşağıda önem sırasına göre listelenmiştir.

| # | Önem | Sistem | Sorun |
|---|------|--------|-------|
| 1 | 🔴 Kritik | Japon Byoyomi | Hamle yapılınca periyot süresi **sıfırlanmıyor** — kuralın özü çalışmıyor |
| 2 | 🟠 Orta | Japon Byoyomi | Periyot sayısında **+1 (off-by-one)** — "2 hak" ayarı fiilen 3 periyot veriyor |
| 3 | 🟡 Düşük | Japon Byoyomi | Son periyotta hak bilgisi (`Byoyomi: N periods`) **ekrandan kayboluyor** |
| 4 | 🟠 Orta | Tümü (ses) | Uyarı sesi son **10–5 sn** arası çalıyor; son 4 saniye sessiz (yardım metni "son 10 sn" diyor) |
| 5 | 🟢 Bilgi | — | İlgili test ham hatalı davranışı "doğru" olarak sabitliyor (regresyon riski) |

---

## 2. Japon Byoyomi nasıl çalışmalı? (referans kural)

Uygulamanın kendi yardım metni beklenen davranışı net tanımlıyor:

> `helpSystemsB2`: "Japon Byoyomi: Ana süre bittikten sonra **her hak için sabit süre verilir**."
> `byoyomiDesc`: "Ana Süre + Japon Byoyomi Hakkı × Süre"

Standart Japon byoyomi kuralı:

1. Oyuncunun bir **ana süresi** vardır. Bittiğinde byoyomi'ye geçer.
2. Byoyomi'de **N adet periyot** ve her periyot için **X saniye** vardır.
3. **Her hamlede sayaç X saniyeden yeniden başlar.** Oyuncu hamlesini X saniye içinde
   yaparsa periyot **tüketilmez** — bir sonraki hamlede yine taze X saniye alır.
4. Oyuncu bir hamleyi X saniyede yetiştiremezse **bir periyot harcanır** ve yeni periyot başlar.
5. Tüm periyotlar tükenince **süre aşımından kaybeder**.

Yani kritik nokta: **byoyomi süresi her başarılı hamlede tazelenir.**

---

## 3. Hata #1 — 🔴 KRİTİK: Hamlede byoyomi süresi sıfırlanmıyor

### Konum
- `_passTurn()` → [lib/main.dart:689-725](lib/main.dart#L689-L725)

### Sorun
Sıra geçişinde (oyuncu hamlesini yapıp ekrana dokununca) süre sıfırlama bloğu **yalnızca Kanada**
sistemi için yazılmış. Japon byoyomi için hiçbir şey yapılmıyor:

```dart
// _passTurn() içi:
if (_isBlackTurn) {
  _blackMoves++;

  if (widget.timeSystem == TimeSystemIds.canada && _blackMainTime <= 0) {
    _blackByoyomiCount--;
    if (_blackByoyomiCount <= 0) {
      _blackByoyomiCount = widget.blackByoyomiCount;
      _blackByoyomiRemaining = widget.blackByoyomi;   // ← reset SADECE Kanada'da
    }
  }
  // ⚠️ Japon byoyomi için reset YOK
}
```

`_blackByoyomiRemaining` yalnızca `_tickBlack()` içinde, süre 0'a düşüp **bir hak tüketildiğinde**
sıfırlanıyor ([lib/main.dart:634-641](lib/main.dart#L634-L641)). Hamle yapıldığında değil.

### Sonuç (kural ihlali)
Japon byoyomi fiilen **"N×X saniyelik tek bir havuz"** gibi davranıyor; süre hamleler arasında
kaldığı yerden devam ediyor.

**Senaryo:** 30 sn × 5 hak ayarı.
- Siyah byoyomi'ye giriyor, süre 30.
- Hamlesini 25 sn'de yapıyor → süre 5'e düşmüş.
- Sıra geçiyor, beyaz oynuyor, tekrar siyaha geliyor.
- **Süre 30'a dönmüyor, 5'ten devam ediyor.** Doğru kuralda bu hamlede yine 30 sn olmalıydı.

Bu, byoyomi'nin **tüm amacını** (hamle başına sabit süre) ortadan kaldıran temel hatadır.

### Önerilen düzeltme
`_passTurn()` içinde, oyuncu byoyomi fazındaysa (ana süre bitmişse) ve sistem Japon byoyomi ise
periyot süresini tazele (hak korunur, çünkü hamle zamanında yapıldı):

```dart
if (_isBlackTurn) {
  _blackMoves++;

  if (_blackMainTime <= 0) {
    if (widget.timeSystem == TimeSystemIds.canada) {
      _blackByoyomiCount--;
      if (_blackByoyomiCount <= 0) {
        _blackByoyomiCount = widget.blackByoyomiCount;
        _blackByoyomiRemaining = widget.blackByoyomi;
      }
    } else if (widget.timeSystem == TimeSystemIds.byoyomi) {
      // Japon byoyomi: hamle zamanında yapıldı → süre tazelenir, hak korunur
      _blackByoyomiRemaining = widget.blackByoyomi;
    }
  }
}
```

Aynı düzeltme `_white...` dalı için de uygulanmalı.

---

## 4. Hata #2 — 🟠 Periyot sayısında off-by-one (fazladan 1 periyot)

### Konum
- `_tickBlack()` byoyomi dalı → [lib/main.dart:634-641](lib/main.dart#L634-L641)
- `initState()` → [lib/main.dart:431-434](lib/main.dart#L431-L434)

### Sorun
`_blackByoyomiRemaining` başlangıçta `widget.blackByoyomi` ile dolduruluyor ve ana süre bitince
bu "ilk" periyot, `_blackByoyomiCount` sayacından **düşülmeden** kullanılıyor. İlk periyot
0'a inince hak sayacı düşmeye başlıyor. Yani sayaç değeri kadar periyot + bedava bir başlangıç
periyodu çalışıyor.

**İz sürüm (byoyomi=2 sn, count=2, hamle yapılmadan):**
```
süre 2→1→0           (başlangıç periyodu, count hâlâ 2)
süre 0 → count 2→1, süre=2
süre 2→1→0           (count=1 periyodu)
süre 0 → count 1→0, süre=2
süre 2→1→0           (count=0 periyodu — bilgi metni kayıp, bkz. Hata #3)
süre 0 → endGame
```
"2 hak" ayarıyla oyuncu fiilen **3 periyot** oynuyor. Ek olarak süre 0'da bir tam saniye
beklediği için her periyot ~(X+1) saniye sürüyor.

### Önerilen düzeltme yönü
`count` değerini "kalan periyot sayısı (içinde bulunulan dahil)" olarak modelleyin ve son periyotta
bitir:

```dart
if (_blackByoyomiRemaining > 0) {
  _blackByoyomiRemaining--;
} else if (_blackByoyomiCount > 1) {   // 1 = içinde bulunulan son periyot
  _blackByoyomiCount--;
  _blackByoyomiRemaining = widget.blackByoyomi;
} else {
  _endGame('settingsWhite');
}
```
> Not: Bu değişiklik mevcut testteki (`app_test.dart:404`) beklentiyi değiştirir; bkz. Hata #5.

---

## 5. Hata #3 — 🟡 Son periyotta hak bilgisi ekrandan kayboluyor

### Konum
- `_buildPlayerArea()` byoyomiInfo bloğu → [lib/main.dart:1514-1527](lib/main.dart#L1514-L1527)

### Sorun
Bilgi metni yalnızca `byoyomiCount > 0` iken gösteriliyor:

```dart
if (!_isSimple && byoyomiCount > 0) {
  ... "Byoyomi: {count} periods | {seconds}s"
}
```

Hata #2'deki modelde sayaç son periyotta 0'a düşüyor; bu yüzden oyuncu **hâlâ geçerli (son)
periyodunu oynarken** "Byoyomi: N periods" yazısı tamamen kayboluyor. Oyuncu kaç hakkı kaldığını
göremiyor — üstelik en kritik anda.

### Önerilen düzeltme
Hata #2'deki "kalan periyot (içinde bulunulan dahil)" modeline geçilirse koşul `byoyomiCount >= 1`
doğal olarak son periyotta da `1` gösterir ve sorun çözülür. Aksi halde koşulu byoyomi fazında
her zaman gösterecek şekilde gevşetin.

---

## 6. Hata #4 — 🟠 Uyarı sesi son 4 saniyede susuyor

### Konum
- `_tickBlack()` → [lib/main.dart:611-613](lib/main.dart#L611-L613)
- `_tickWhite()` → [lib/main.dart:649-651](lib/main.dart#L649-L651)

### Sorun
```dart
if (_soundOn && currentPhaseRemaining >= 5 && currentPhaseRemaining <= 10) {
  _playBeep();
}
```
Bip sesi yalnızca 10, 9, 8, 7, 6, 5 saniyelerinde çalıyor; **4, 3, 2, 1** saniyelerinde susuyor.
Oysa yardım metni `helpSoundB1`: *"Son 10 saniyede uyarı sesi çalar."* diyor. En kritik son 4 saniye
sessiz kalıyor — geri sayımın tam da en gerekli anı.

Ayrıca `currentPhaseRemaining` ana süre fazında ana süreyi yansıttığı için, **ana sürenin** son
10–5 saniyesinde de bip çalıyor (muhtemelen istenen ama dokümante edilmemiş davranış).

### Önerilen düzeltme
Alt sınırı kaldırın (ya da 1 yapın):
```dart
if (_soundOn && currentPhaseRemaining <= 10 && currentPhaseRemaining >= 1) {
  _playBeep();
}
```

---

## 7. Hata #5 — 🟢 Test, hatalı davranışı "doğru" olarak sabitliyor

### Konum
- [test/app_test.dart:383-406](test/app_test.dart#L383-L406) — *"Japon Byoyomi: period bitince hak duser ve sure resetlenir"*
- [test/app_test.dart:346](test/app_test.dart#L346) — test adı *"Son 10-5 saniye araliginda..."* (Hata #4'ü kabulleniyor)

### Sorun
Mevcut byoyomi testi **yalnızca süre dolunca** (hamle yapılmadan) periyot düşmesini doğruluyor.
Asıl kritik durum olan **"hamle yapılınca sürenin tazelenmesi"** için hiç test yok — yani Hata #1
test tarafından hiç yakalanmıyor. Üstelik `app_test.dart:404` satırı off-by-one'lı çıktıyı
(`Byoyomi: 1 periods | 2s`) doğru kabul ediyor; bu yüzden Hata #2 düzeltilince bu test kırılır ve
güncellenmesi gerekir.

### Öneri
Düzeltmelerle birlikte şu testler eklenmeli:
- Byoyomi'de hamle yapılınca `_blackByoyomiRemaining`'in `widget.blackByoyomi`'ye döndüğü.
- "N hak" ayarının tam olarak N periyot verdiği (off-by-one olmadığı).
- Son periyotta hak bilgisinin görünmeye devam ettiği.
- Geri sayım sesinin 10→1 arası her saniye tetiklendiği.

---

## 8. Doğru çalışan kısımlar (referans)

- **Kanada Byoyomi:** `_passTurn()` her hamlede hak düşürüyor, haklar bitince hem süreyi hem hak
  sayısını resetliyor ([lib/main.dart:698-718](lib/main.dart#L698-L718)). Kural doğru.
  (Yine de süre tükenirken `_tickBlack` Kanada dalında benzer "0'da 1 sn bekleme" davranışı var,
  ama Kanada'da süre havuz olduğu için sorun yaratmıyor.)
- **Basit Zaman:** Ana süre bitince oyun bitiyor — doğru.
- **Sıra/dokunma kısıtları:** Oyuncu yalnızca kendi sırasında ve sayaç çalışırken hamle geçebiliyor
  ([lib/main.dart:1448-1451](lib/main.dart#L1448-L1451), [1469-1471](lib/main.dart#L1469-L1471)) — doğru.
- **Ana süre → byoyomi geçişi:** Temiz; ana süre 1→0 olduğunda ekran byoyomi süresine geçiyor.

---

## 9. Önerilen düzeltme sırası

1. **Hata #1** (kritik) — `_passTurn` içine byoyomi süre tazeleme. Tek başına bile kuralı düzeltir.
2. **Hata #4** (orta) — bip alt sınırını kaldır. Tek satır.
3. **Hata #2 + #3** (orta/düşük) — periyot sayacı modelini "içinde bulunulan dahil" olarak yeniden
   ele al; bilgi metni koşulunu buna göre düzelt.
4. **Hata #5** — testleri yeni (doğru) davranışa göre güncelle ve eksik senaryoları ekle.

---

## 10. Uygulanan düzeltmeler (2026-06-27)

Tüm hatalar `master` üzerinde düzeltildi; `flutter test` (13/13 geçti) ve `flutter analyze` (temiz) ile doğrulandı.

| # | Durum | Yapılan değişiklik |
|---|-------|--------------------|
| 1 | ✅ | `_passTurn()` byoyomi fazında `_blackByoyomiRemaining` / `_whiteByoyomiRemaining`'i tam süreye tazeliyor (hak korunur) — [main.dart:698-728](lib/main.dart#L698-L728) |
| 2 | ✅ | `_tickBlack`/`_tickWhite` byoyomi dalında hak koşulu `> 0` → `> 1`; "N hak" artık tam N periyot veriyor — [main.dart:634](lib/main.dart#L634) |
| 3 | ✅ | Hata #2 düzeltmesiyle hak sayacı oyun boyunca `>= 1` kalıyor; son periyotta bilgi metni artık kaybolmuyor (ek değişiklik gerekmedi) |
| 4 | ✅ | Geri sayım sesi koşulu `>= 5` → `>= 1`; uyarı son saniyeye kadar çalıyor — `_tickBlack`/`_tickWhite` |
| 5 | ✅ | İki regresyon testi eklendi: hamlede süre tazeleme ve off-by-one olmadığı — [app_test.dart](test/app_test.dart) |

> Not: Kanada dalındaki "0'da 1 sn bekleme" davranışı (her periyot fiilen X+1 sn) bilinçli olarak
> korundu — saat 00:00'ı bir an gösterip sonra periyot düşmesi yaygın bir byoyomi saati davranışıdır
> ve havuz mantığında sorun yaratmıyor.

---
*Rapor `lib/main.dart`, `lib/translate/translate.dart` ve `test/app_test.dart` incelemesine dayanır;
düzeltmeler `flutter test` ve `flutter analyze` ile doğrulanmıştır.*
