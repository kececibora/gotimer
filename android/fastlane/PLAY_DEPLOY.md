# Google Play Otomatik Yükleme (Fastlane)

Bu klasör, `gotimer` uygulamasını Google Play'e **fastlane** ile yüklemek için yapılandırılmıştır.

- **Paket adı:** `com.borakececi.gotimer`
- **Lane'ler:** `deploy` (yükler), `build_aab` (sadece AAB üretir), `validate` (anahtarı doğrular)
- **Track'ler:** `internal` · `alpha` · `beta` · `production`

> ⚠️ İlk sürüm zorunluluğu: Google Play API'si, uygulamanın **ilk** AAB'sini yükleyemez.
> En az bir kez Play Console'dan manuel yükleme yapılmış olmalı. (gotimer zaten yayında
> olduğu için bu koşul sağlanıyor.)

---

## 1. Service account (bir kez yapılır)

> Not: Yeni Play Console arayüzünde "API erişimi" sayfası her zaman görünmez.
> Aşağıdaki Google Cloud + "Kullanıcılar ve izinler" akışı her durumda çalışır.

**Google Cloud Console'da:**
1. https://console.cloud.google.com → proje oluşturun/seçin.
2. **APIs & Services → Library** → "Google Play Android Developer API" → **Enable**.
3. **IAM & Admin → Service Accounts → Create service account** → isim verin → **Done**.
4. Oluşan hesap → **Keys → Add key → Create new key → JSON** → indirin.
   Bu JSON'ın içeriği `GOOGLE_PLAY_JSON_KEY`'dir; dosyayı yerelde
   `android/fastlane/play-service-account.json` olarak kaydedin (gitignore'lu).
5. Service account e-postasını kopyalayın (`...@...iam.gserviceaccount.com`).

**Play Console'da:**
6. **Kullanıcılar ve izinler → Yeni kullanıcı davet et** → bu e-postayı girin.
7. Uygulama izinlerinde **"Üretime sürüm yayınla"** (+ istenen test track'leri) yetkisini
   verip davet edin. Birkaç dakika sonra anahtar aktif olur.

Anahtarın geçerli olduğunu doğrulamak için (yerelde):

```bash
cd android
GOOGLE_PLAY_JSON_KEY=/tam/yol/play-service-account.json bundle exec fastlane validate
```

---

## 2. Yerelden yükleme

> Yerel macOS ruby'si 2.6 eski olabilir; fastlane için ruby 3.x önerilir
> (`brew install ruby` veya `rbenv install 3.1.4`). Sonra:

```bash
cd android
bundle install                       # fastlane'i kurar (Gemfile)
# JSON anahtarini buraya koyun: android/fastlane/play-service-account.json

bundle exec fastlane release track:internal     # build no'yu +1 yapar, build eder, yukler
# veya sadece yukle (build no artirmadan):
bundle exec fastlane deploy  track:production
```

Lane'ler:
- `release track:<t>` — **build numarasini +1 artirir** (1.1.1+6 → 1.1.1+7), sonra
  `flutter build appbundle --release` yapip yukler. Onerilen yol.
- `deploy track:<t>` — build numarasini degistirmeden build edip yukler.
- `bump_build` — sadece pubspec.yaml build numarasini +1 artirir.
- `metadata version:6` — sadece magaza metni/gorsel/surum notlarini yukler (binary yok).
- `validate` — service-account anahtarini dogrular.

> Play ayni versionCode'u reddettigi icin her yuklemede build numarasi artmalidir;
> `release` lane'i bunu otomatik yapar. Surum **adini** (1.1.1 → 1.2.0) yine elle
> `pubspec.yaml`'dan degistirin (semver karari sizin).

### Magaza gorselleri (ekran goruntuleri)
Pazarlama ekran goruntuleri uygulamadan otomatik uretilir (iOS simulator):
```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/screenshot_test.dart \
  -d <ios-simulator-udid>
# Ciktilar: store_screenshots/*.png (1170x2532). Play 2:1 sinirina padlenip
# android/fastlane/metadata/android/en-US/images/phoneScreenshots/ altina konur.
```
Sonra `fastlane metadata version:<vc>` ile yuklenir.

---

## 3. CI'dan yükleme (GitHub Actions)

`.github/workflows/deploy-play.yml` iki şekilde tetiklenir:
- **Manuel:** GitHub → **Actions** → *Deploy to Google Play* → **Run workflow** → track seçin.
- **Tag ile:** `git tag v1.1.1 && git push origin v1.1.1` → otomatik `internal` track.

### Gerekli GitHub Secrets
(Repo → **Settings → Secrets and variables → Actions → New repository secret**)

| Secret | İçerik |
|--------|--------|
| `GOOGLE_PLAY_JSON_KEY` | Service-account JSON dosyasının **tam içeriği** |
| `ANDROID_KEYSTORE_BASE64` | `base64 -i android/app/upload-keystore.jks` çıktısı |
| `ANDROID_STORE_PASSWORD` | key.properties → storePassword |
| `ANDROID_KEY_PASSWORD` | key.properties → keyPassword |
| `ANDROID_KEY_ALIAS` | `upload` |

`ANDROID_KEYSTORE_BASE64`'ü üretmek için:
```bash
base64 -i android/app/upload-keystore.jks | pbcopy   # macOS: panoya kopyalar
```

---

## Güvenlik
- `play-service-account.json`, `*.jks`, `key.properties` **`.gitignore`'da** — asla commit'lenmez.
- Anahtarlar yalnızca GitHub Secrets ve yerel makinede tutulur.
