import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/booking.dart';

import 'base_provider.dart';

class BookingProvider extends BaseProvider<Booking> {
  @override
  Future<List<Booking>> get() => restGet(EasyRest().getBookings());

  @override
  Future<Booking> add(Booking item) => restAdd(EasyRest().addEditBooking(item));

  @override
  Future<bool> delete(Booking item) =>
      restDelete(item, EasyRest().deleteBooking(item));
}
