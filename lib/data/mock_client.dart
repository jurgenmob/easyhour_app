import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/booking.dart';
import 'package:easyhour_app/models/office.dart';
import 'package:easyhour_app/models/workplace.dart';
import 'package:flutter/material.dart';

class EasyMock {
  static final EasyMock _instance = EasyMock._internal();

  factory EasyMock() {
    return _instance;
  }

  EasyMock._internal();

  Future<List<Booking>> getBookings() async {
    List<WorkPlace> workPlaces = await getWorkPlaces();

    return List.generate(
        20,
        (i) => Booking(
            id: i,
            dataInizio: DateTime.parse("2020-01-${i.padLeft(2)}"),
            dataFine: DateTime.parse("2020-01-${(i + 1).padLeft(2)}"),
            postazione: (workPlaces..shuffle()).first));
  }

  Future<List<WorkPlace>> getWorkPlaces({DateTimeRange dateRange}) async {
    return List.generate(
        20,
        (i) => WorkPlace(
            id: i,
            nome: "Scrivania luuuunga ${i + 1}",
            ufficio:
                Office(id: i % 3, nome: "Ufficio lungo lungo ${i % 3 + 1}")));
  }

  Future<List<Office>> getOffices() async {
    // Mock data
    return List.generate(3, (i) => Office(id: i, nome: "Office ${i + 1}"));
  }
}
