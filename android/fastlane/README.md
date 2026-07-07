fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android build_aab

```sh
[bundle exec] fastlane android build_aab
```

Flutter ile imzali release AAB uret

### android deploy

```sh
[bundle exec] fastlane android deploy
```

Google Play'e yukle. Kullanim: fastlane deploy track:internal

track secenekleri: internal | alpha | beta | production (varsayilan: internal)

### android bump_build

```sh
[bundle exec] fastlane android bump_build
```

pubspec.yaml build numarasini +1 artir (1.1.1+6 -> 1.1.1+7)

### android release

```sh
[bundle exec] fastlane android release
```

Build numarasini artir + Play'e yukle. Kullanim: fastlane release track:production

### android metadata

```sh
[bundle exec] fastlane android metadata
```

Sadece magaza metni/gorsel/surum notlarini yukle (binary yok)

Kullanim: fastlane metadata version:6

### android validate

```sh
[bundle exec] fastlane android validate
```

Sadece kimlik dogrulamayi test et (yukleme yapmaz)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
