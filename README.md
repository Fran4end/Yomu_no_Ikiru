<p align="center">
    <img src="yomu_no_ikiru/assets/icon.png" alt="Yomu no Ikiru logo">
</p>

# Yomu no Ikiru

[![GitHub release](https://img.shields.io/github/release/Fran4end/yomu_no_ikiru.svg)](https://github.com/Fran4end/Yomu_no_Ikiru/releases)

**Yomu no Ikiru** is a free and open-source multi-platform app for reading manga.  
It is designed to be flexible, extendable, and respectful of intellectual property.

> ⚠️ **Disclaimer**  
> This application does not provide or host any manga content.  
> Users are responsible for importing and managing their own sources through external configuration files.  
> The app acts solely as a reading tool for publicly accessible content. It does not verify or moderate third-party sources.

---

## Table of Contents

1. [Running](#running-yomu-no-ikiru)
2. [Develop](#developing-yomu-no-ikiru)
3. [contributing](#contributing)
4. [License](#license)

---

## Project Status

This project is under active development.  
I do my best to keep things in a stable state. Feedback and bug reports are welcome, but please be aware that I may not always be immediately available.

> ⚙️ The current [`main`](https://github.com/Fran4end/Yomu_no_Ikiru) branch is a new codebase. Older versions can be found in earlier commits and may include legacy features (e.g., Gradle builds).  
> **⚠️ LEGACY CODE DISCLAIMER**  
> This branch contains legacy code that references third‑party websites which may infringe copyright.  
> These versions are **unsupported**, **unmaintained**, and **provided “as‑is”**.  
> The maintainers **do not condone** unauthorized access to copyrighted content and **disclaim all liability** for any use of these legacy branches.  
> Please use only the last commits on [`main`](https://github.com/Fran4end/Yomu_no_Ikiru) branch for the officially supported, legal‑friendly code.

---

## Running Yomu no Ikiru

Currently, there are no automated builds. You can compile the app from source or download the latest release when available:

### Latest release

| [Windows ?? (x64)]() | macOS ?? ([Intel](), [Apple Silicon]()) | [Linux (x64)]() | [iOS ??]() | [Android 6+]() |
| -------------------- | --------------------------------------- | --------------- | ---------- | -------------- |

---

## Developing Yomu no Ikiru

### Prerequisite

Ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/) installed.
- [Android SDK](https://developer.android.com/studio) installed
- [Java JDK 21](https://www.oracle.com/java/technologies/downloads/#jdk21-windows) installed

Recommended IDEs:

- [Visual Studio Code](https://code.visualstudio.com/)
- [Android Studio](https://developer.android.com/)

### Cloning the source code

Clone the repository:

```shell
git clone https://github.com/Fran4end/Yomu_no_Ikiru

cd yomu_no_ikiru
```

To update the source code to the latest commit, run the following command inside the `Yomu no Ikiru` directory:

```shell
git pull
```

### Building

#### From an IDE

(coming soon...)

#### From CLI

You can also build and run _Yomu no Ikiru_ from the command-line:

- list device:

```shell
flutter devices
```

- run code:

```shell
cd yomu_no_ikiru
flutter run -d <DEVICE_ID>
```

When running locally to do any kind of performance testing, make sure to add `--release` to the run command, as the overhead of running with the default `Debug` configuration can be large.

If you want more information log, try to add `--verbose`.

### Code analysis

Before committing your code, please run a code formatter. This can be achieved by running `dart format ./` in the command line, or using the `Format code` command in your IDE.

---

## contributing

(coming soon...)

---

## Screenshot

---

## License

_Yomu no Ikiru_'s code are licensed under the `Apache License 2.0`. Please see [the license file](LICENSE) for more information. [tl;dr](https://www.tldrlegal.com/license/apache-license-2-0-apache-2-0) you can do whatever you want as long as you include the original copyright and license notice in any copy of the software/source.
