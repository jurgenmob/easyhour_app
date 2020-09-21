import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/trip.dart';

import 'base_provider.dart';

class TripProvider extends BaseProvider<Trip> {
  @override
  Future<List<Trip>> get() => restGet(EasyRest().getTrips());

  @override
  Future<Trip> add(Trip item) => restAdd(EasyRest().addEditTrip(item));

  @override
  Future<Trip> edit(Trip item) => restEdit(EasyRest().addEditTrip(item));

  @override
  Future<bool> delete(Trip item) =>
      restDelete(item, EasyRest().deleteTrip(item));
}
