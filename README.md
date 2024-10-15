<p align="center">
    <img width="500" alt="Yomu no Ikiru logo" src="assets/icon.png">
</p>

# Yomu no ikiru

[![Build status](https://github.com/ppy/osu/actions/workflows/ci.yml/badge.svg?branch=master&event=push)]()
[![GitHub release](https://img.shields.io/github/release/Fran4end/yomu_no_ikiru.svg)](https://github.com/Fran4end/Yomu_no_Ikiru/releases/lastest)

A free app for reading manga in different languages

This is a multi-platform app inspired from [Tachiyomy](https://tachiyomi.org/).
For android 6 or above and ios ...,

## Index

1. [Running](#running-yomu-no-ikiru)
2. [Develop](#developing-yomu-no-ikiru)
3. [contributing](#contributing)
4. [License](#license)

## Status

This project is in development, i do my best to keep things in a stable state. Users are encourage to report any issue and keep in mind that i'm not always active.

Right now the [main](https://github.com/Fran4end/Yomu_no_Ikiru) branch is a version with a deprecated gradle, i'm developing new version from scratch on branch [new_code](https://github.com/Fran4end/Yomu_no_Ikiru/tree/new_code) the others branch is a try of new feature but not working, so please not consider those.

## Running Yomu no Ikiru

If you are just looking to give the app a whirl, you can grab the latest release for your platform:

### Latest release:

| [Windows ?? (x64)]() | macOS ?? ([Intel](), [Apple Silicon]()) | [Linux (x64)]() | [iOS ??]() | [Android 6+]() |
| -------------------- | --------------------------------------- | --------------- | ---------- | -------------- |

## Developing Yomu no Ikiru

### Prerequisite

Please make sure you have the following prerequisites:

- [Flutter SDK](https://flutter.dev/) installed.
- [Android SDK](https://developer.android.com/studio) installed
- [Java JDK 17](https://www.oracle.com/java/technologies/downloads/#java17) installed

When working with the codebase, i recommend using an IDE with intelligent code completion and syntax highlighting, such as the latest version of [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/)

### Downloading the source code

Clone the repository:

```shell
git clone https://github.com/Fran4end/Yomu_no_Ikiru
cd osu
```

To update the source code to the latest commit, run the following command inside the `yomu_no_ikiru` directory:

```shell
git pull
```

### Building

#### From an IDE

...

#### From CLI

You can also build and run _Yomu no Ikiru_ from the command-line:

- list device:

```shell
flutter devices
```

- run code:

```shell
flutter flutter run -d <DEVICE_ID>
```

When running locally to do any kind of performance testing, make sure to add `--release` to the run command, as the overhead of running with the default `Debug` configuration can be large.

If you want more information log, try to add `--verbose`.

### Code analysis

Before committing your code, please run a code formatter. This can be achieved by running `dart format ./` in the command line, or using the `Format code` command in your IDE.

## contributing

...

## License

_Yomu no Ikiru_'s code are licensed under the `Apache License V2`. Please see [the licence file](LICENSE) for more information. [tl;dr](https://www.tldrlegal.com/license/apache-license-2-0-apache-2-0) you can do whatever you want as long as you include the original copyright and license notice in any copy of the software/source.

## Screenshot
