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

1. [Google Play Console](https://play.google.com/console) → **Users and permissions** → **Invite new users**
   yerine API erişimi için: **Setup → API access** (veya Google Cloud Console'da bir proje + service account).
2. Bir **service account** oluşturun ve **JSON anahtarını** indirin.
3. Play Console → **API access** → bu service account'a **Release** (yayınlama) yetkisi verin.
   (Admin / "Release to production, exclude devices, and use Play App Signing" yeterli.)

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
bundle exec fastlane deploy track:internal      # internal test track
# veya
bundle exec fastlane deploy track:production     # production
```

`deploy` lane'i otomatik olarak `flutter build appbundle --release` çalıştırır,
imzalı AAB'yi üretir ve seçilen track'e yükler. `pubspec.yaml`'daki `version`
(şu an `1.1.1+6`) her yüklemede artırılmalıdır (Play, aynı versionCode'u reddeder).

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
