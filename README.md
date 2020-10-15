# EasyHour App

The timesheet, that's it!

## Getting Started

TODO

### Setting the Google Maps API key

1. Create a `secure.properties` file starting from `secure.properties.tpl` and set the map keys for iOS and Android.
2. In your IDE (or from CLI) specify as build/run parameter: `--dart-define="GOOGLE_MAPS_API_KEY=..."`

iOS: TBD

### Re-generate language keys

```
flutter pub run easy_localization:generate -f keys -S assets/translations/ -o locale_keys.g.dart
```

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>
