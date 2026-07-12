fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios certs

```sh
[bundle exec] fastlane ios certs
```

Apple Distribution sertifikası + App Store profili oluştur/indir

### ios metadata

```sh
[bundle exec] fastlane ios metadata
```

10 dilli mağaza metinlerini App Store Connect'e yükle

### ios shots

```sh
[bundle exec] fastlane ios shots
```

Ekran görüntülerini App Store Connect'e yükle

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Hazır IPA'yı TestFlight'a yükle

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
