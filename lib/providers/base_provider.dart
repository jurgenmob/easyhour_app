import 'package:dio/dio.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class BaseProvider<T extends BaseModel> extends ChangeNotifier {
  dynamic _filter;

  set filter(dynamic filter) {
    final notify = filter != _filter;

    _filter = filter;

    if (notify) notifyListeners();
  }

  List<T> get allItems => List.unmodifiable(_items != null ? _items : List());

  List<T> get items => List.unmodifiable(_items != null && _filter != null
      ? _items.where((element) => element.filter(_filter)).toList()
      : (_items ?? List()));
  List<T> _items = List();

  Future<List<T>> get();

  Future<T> add(T item) {
    _items.add(item);

    notifyListeners();

    return Future.value(item);
  }

  Future<bool> delete(T item) {
    final bool ret = _items.remove(item);

    notifyListeners();

    return Future.value(ret);
  }

  Future<T> edit(T item) {
    notifyListeners();

    return Future.value(item);
  }

  @protected
  Future<List<T>> restGet(Future<List<T>> restCall) async {
    // Return value should contain the list of items
    _items = await restCall;

    notifyListeners();

    return items;
  }

  @protected
  Future<T> restAdd(Future<T> restCall) async {
    // Return value should contain the new item
    T item = await restCall;
    if (item != null) _items.add(item);

    notifyListeners();

    return item;
  }

  @protected
  Future<T> restEdit(Future<T> restCall) async {
    // Return value should contain the changed item
    T item = await restCall;
    if (item != null) {
      final pos = _items.indexOf(item);
      _items.setRange(pos, pos + 1, [item]);
    }

    notifyListeners();

    return item;
  }

  @protected
  Future<bool> restDelete(T item, Future<Response> restCall) async {
    // Return value is empty, just check the http code
    Response response = await restCall;
    final bool resultOk =
        response.statusCode == 200 || response.statusCode == 204;
    if (resultOk) _items.remove(item);

    notifyListeners();

    return resultOk;
  }
}
