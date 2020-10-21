# EasyHour App

The timesheet, that's it!

## Getting Started

### Setting the Google Maps API key

Create a `secure.properties` file starting from `secure.properties.tpl` and set the map keys for iOS and Android.

### Other Google services (Analytics, Firebase)

Place Firebase configuratio in `android/app/google-services.json` (Android) and `ios/Runner/GoogleService-Info.plist` (iOS).

### Re-generate language keys

```
flutter pub run easy_localization:generate -f keys -S assets/translations/ -o locale_keys.g.dart
```

### Run the app

```
flutter run
```

### Publish the app

```
flutter clean
flutter pub get

# Android
flutter build appbundle

# iOS
flutter build ios
cd ios
pod install
cd ..
```

... then follow instructions here: [Android](https://flutter.dev/docs/deployment/android) | [iOS](https://flutter.dev/docs/deployment/ios).

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>

