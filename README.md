# POSApp

A mobile POS (Point of Sale) system for small restaurants, written in Flutter.

**Tested & printable on Sunmi V1S device.**

![sunmi_v1s](.github/resource/print.jpg)

**Support:**

- Android
- Web (unable to print)
- English & Vietnamese (auto detect Locale)

---

## Install & Run

Get [flutter](https://flutter.dev/)

```
flutter pub get
flutter run
```

**For web**

1. `flutter config --enable-web`
2. `flutter run -d web-server`
3. Browse from Firefox (don't use Chrome version >= 100.x for debugging)

**For emulator**
1. `flutter run`

## Features

- Table management with drag-and-drop layout
- Menu management with image support
- Order processing with discount options
- Sales history and reporting
- Expense journal
- Thermal receipt printing (Bluetooth)
- Local storage (SQLite / LocalStorage)

## Architecture

Provider-based architecture:
- **provider/** — State management (Order, Menu, Config suppliers)
- **screens/** — UI screens (Lobby, Menu, Order Details, History, Edit Menu, Expense Journal)
- **storage_engines/** — Database connections (SQLite, Local Storage)
- **theme/** — Material 3 theme with brand colors
- **common/** — Shared widgets (Radial Menu, Draggable, Money format)

## Testing

```bash
flutter test
```

## Build

```bash
flutter pub get
flutter run                          # Run on connected device/emulator
flutter build apk --debug            # Debug APK
flutter build apk --release          # Release APK
```

### Web
```bash
flutter config --enable-web
flutter run -d web-server            # Run on web
flutter build web                    # Build for web
```

## Deploy

### Android
1. Bump version in `pubspec.yaml`
2. Run `flutter build apk --release` or `flutter build appbundle --release`
3. Upload to Google Play Console

### Web (GitHub Pages)
1. Run `flutter build web`
2. Deploy `build/web` to GitHub Pages or any static host

## CI/CD

This project uses GitHub Actions for CI. See `.github/workflows/flutter.yml`.

## License

MIT - POSApp
