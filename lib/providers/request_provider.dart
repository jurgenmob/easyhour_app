import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/request.dart';
import 'package:flutter/cupertino.dart';

import 'base_provider.dart';

class RequestProvider extends BaseProvider<Request> {
  @override
  Future<List<Request>> get() => restGet(EasyRest().getRequests());

  Future<bool> approveRefuse(Request item, {@required bool approved}) =>
      restDelete(
          item, EasyRest().approveRefuseRequest(item, approved: approved));
}
