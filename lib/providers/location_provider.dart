import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/location.dart';

import 'base_provider.dart';

class LocationProvider extends BaseProvider<Location> {
  @override
  Future<List<Location>> get() => restGet(EasyRest().getLocations());

  @override
  Future<bool> delete(Location item) =>
      restDelete(item, EasyRest().deleteLocation(item));
}
