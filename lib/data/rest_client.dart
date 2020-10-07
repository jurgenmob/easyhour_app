import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_utils.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/models/activity.dart';
import 'package:easyhour_app/models/calendar.dart';
import 'package:easyhour_app/models/client.dart';
import 'package:easyhour_app/models/error.dart';
import 'package:easyhour_app/models/location.dart';
import 'package:easyhour_app/models/permit.dart';
import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/models/smart_working.dart';
import 'package:easyhour_app/models/today_activity.dart';
import 'package:easyhour_app/models/trip.dart';
import 'package:easyhour_app/models/user.dart';
import 'package:easyhour_app/models/user_info.dart';
import 'package:easyhour_app/models/vacation.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EasyRest {
  static final EasyRest _instance = EasyRest._internal();

  factory EasyRest() {
    return _instance;
  }

  String get username => _username;
  String _username;

  String get domain => _domain;
  String _domain;
  String _accessToken;
  String _refreshToken;

  Dio _dio = Dio()
    ..options.baseUrl = '$baseUrl/easyhour/api'
    ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  EasyRest._internal() {
    // Initialize logged user tokens from prefs
    initClient();

    // Add auth token to each request
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) {
        return options
          ..headers.addAll({
            if (_accessToken != null) "Authorization": "Bearer $_accessToken",
            "X-AZIENDA-DOMAIN": _domain,
            Headers.contentTypeHeader: Headers.jsonContentType
          });
      },
      onError: (e) async {
        if (e.response?.statusCode == 401) {
          // Ensure we don't get stuck in an infinite loop
          e.request.extra.putIfAbsent("eh_retry", () => 0);
          if (e.request.extra["eh_retry"] <= 2) {
            e.request.extra["eh_retry"]++;

            // Update the access token
            RequestOptions options = e.response.request;
            Response<String> response = await _dio.put<String>('/refresh',
                data: RefreshTokenRequest(_refreshToken).toJson());
            saveTokens(LoginResponse.fromJson(jsonDecode(response.data)));
            options.headers['Authorization'] = 'Bearer $_accessToken';
            return _dio.request(options.path, options: options);
          }
        }

        return e;
      },
    ));
  }

  void initClient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _domain = prefs.getString('domain');
    _username = prefs.getString('username');
    _accessToken = prefs.getString('accessToken');
    _refreshToken = prefs.getString('refreshToken');
  }

  Future<bool> saveTokens(LoginResponse response) async {
    _accessToken = response?.accessToken;
    _refreshToken = response?.refreshToken;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('domain', _domain);
    await prefs.setString('username', _username);
    await prefs.setString('accessToken', _accessToken);
    await prefs.setString('refreshToken', _refreshToken);

    return _accessToken != null;
  }

  Future<bool> doLogin(String domain, String username, String password) async {
    _username = username.trim();
    _domain = domain.trim();

    try {
      Response<String> response = await _dio.post<String>('/authenticate',
          data: LoginRequest(username: username, password: password).toJson());

      return saveTokens(LoginResponse.fromJson(jsonDecode(response.data)));
    } catch (e, s) {
      print(e);
      print(s);
    }

    return false;
  }

  Future<bool> doLogout() {
    _accessToken = null;
    _refreshToken = null;

    return saveTokens(null);
  }

  Future<bool> isUserLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('accessToken')?.isNotEmpty ?? false;
  }

  Future<List<TodayActivity>> getTodayActivities() async {
    Response<String> response = await _dio.get('/today-activities');

    TodayActivitiesResponse activities =
        TodayActivitiesResponse.fromJson(jsonDecode(response.data));

    return activities.malattia != null
        ? [activities.malattia]
        : (activities.ferie != null ? [activities.ferie] : activities.tasks);
  }

  Future<List<Activity>> getActivities() async {
    Response<String> response = await _dio.get('/user-attivitas');

    return ActivityResponse.fromJson(jsonDecode(response.data)).items;
  }

  Future<Worklog> addEditWorklog(Worklog item) async {
    Response<String> response = await _dio.request<String>(
      '/worklogs',
      data: item.toJson(),
      options: Options(method: item.isNew ? 'POST' : 'PUT'),
    );

    return Worklog.fromJson(jsonDecode(response.data), task: item.task);
  }

  Future<Response> deleteWorklog(Worklog item) async {
    return _dio.delete('/worklogs/${item.id}');
  }

  Future<Activity> addEditActivity(Activity item) async {
    Response<String> response = await _dio.request<String>(
      '/attivitas',
      data: item.toJson(),
      options: Options(method: item.isNew ? 'POST' : 'PUT'),
    );

    return Activity.fromJson(jsonDecode(response.data));
  }

  Future<Response> deleteActivity(Activity item) async {
    return _dio.delete('/attivitas/${item.id}');
  }

  Future<List<Permit>> getPermits() async {
    Response<String> response = await _dio.get('/user-permessos');

    return PermitResponse.fromJson(jsonDecode(response.data)).items;
  }

  Future<Permit> addEditPermit(Permit item) async {
    Response<String> response = await _dio.request<String>(
      '/permessos',
      data: item.toJson(),
      options: Options(method: item.isNew ? 'POST' : 'PUT'),
    );

    return Permit.fromJson(jsonDecode(response.data));
  }

  Future<Response> deletePermit(Permit item) async {
    return _dio.delete('/permessos/${item.id}');
  }

  Future<List<Sickness>> getSicknesses() async {
    Response<String> response = await _dio.get('/user-malattias');

    return SicknessResponse.fromJson(jsonDecode(response.data)).items;
  }

  Future<Sickness> addEditSickness(Sickness item) async {
    Response<String> response = await _dio.request<String>(
      '/malattias',
      data: item.toJson(),
      options: Options(method: item.isNew ? 'POST' : 'PUT'),
    );

    return Sickness.fromJson(jsonDecode(response.data));
  }

  Future<Response> deleteSickness(Sickness item) async {
    return _dio.delete('/malattias/${item.id}');
  }

  Future<List<Trip>> getTrips() async {
    Response<String> response = await _dio.get('/user-trasfertas');

    return TripResponse.fromJson(jsonDecode(response.data)).items;
  }

  Future<Trip> addEditTrip(Trip item) async {
    Response<String> response = await _dio.request<String>(
      '/trasfertas',
      data: item.toJson(),
      options: Options(method: item.isNew ? 'POST' : 'PUT'),
    );

    return Trip.fromJson(jsonDecode(response.data));
  }

  Future<Response> uploadTripAttachment(Trip item, PlatformFile file) async {
    return _dio.post<String>(
      '/allegatoes/',
      data: FormData.fromMap({
        "File": await MultipartFile.fromFile(file.path, filename: file.name),
        "TrasfertaId": item.id,
      }),
    );
  }

  Future<Response> deleteTrip(Trip item) async {
    return _dio.delete('/trasfertas/${item.id}');
  }

  Future<List<Vacation>> getVacations() async {
    Response<String> response = await _dio.get('/user-feries');

    return VacationResponse.fromJson(jsonDecode(response.data)).items;
  }

  Future<Vacation> addEditVacation(Vacation item) async {
    Response<String> response = await _dio.request<String>(
      '/feries',
      data: item.toJson(),
      options: Options(method: item.isNew ? 'POST' : 'PUT'),
    );

    return Vacation.fromJson(jsonDecode(response.data));
  }

  Future<Response> deleteVacation(Vacation item) async {
    return _dio.delete('/feries/${item.id}');
  }

  Future<List<SmartWorking>> getSmartWorkings() async {
    Response<String> response = await _dio.get('/user-smart-workings');

    return SmartWorkingResponse.fromJson(jsonDecode(response.data)).items;
  }

  Future<SmartWorking> addEditSmartWorking(SmartWorking item) async {
    Response<String> response = await _dio.request<String>(
      '/smart-workings',
      data: item.toJson(),
      options: Options(method: item.isNew ? 'POST' : 'PUT'),
    );

    return SmartWorking.fromJson(jsonDecode(response.data));
  }

  Future<Response> deleteSmartWorking(SmartWorking item) async {
    return _dio.delete('/smart-workings/${item.id}');
  }

  Future<UserInfo> getUserInfo() async {
    Response<String> response = await _dio.get('/user-info');

    return UserInfoResponse.fromJson(jsonDecode(response.data)).info;
  }

  Future<List<Module>> getActiveModules() async {
    return (await getUserInfo()).configurazioneAzienda.modulos;
  }

  Future<List<CalendarEvent>> getCalendarEvents(
      DateTime startDate, DateTime endDate) async {
    final startDateParam = DateFormat(restDateFormat).format(startDate);
    final endDateParam = DateFormat(restDateFormat).format(endDate);
    Response<String> response = await _dio.get(
        '/calendar-activities?data_inizio=$startDateParam&data_fine=$endDateParam');

    return CalendarResponse.fromJson(jsonDecode(response.data)).items;
  }

  Future<List<Client>> getClients() async {
    Response<String> response = await _dio.get('/user-clientes');

    return ClientResponse.fromJson(jsonDecode(response.data)).items;
  }

  Future<List<Location>> getLocations() async {
    Response<String> response = await _dio.get('/user-locations');

    return LocationResponse.fromJson(jsonDecode(response.data)).items;
  }
}

String handleRestError(BuildContext context, e, s) {
  // Print the error
  print(e);
  print(s);

  // This is the error shown to the user
  String error;

  // Force user to login again if auth fails
  if (e.runtimeType == DioError &&
      (e.response?.statusCode == 401 || e.request.path == '/refresh')) {
    error = LocaleKeys.message_login_expired.tr();
    EasyRest().doLogout().then((_) => Navigator.pushNamed(context, '/login'));
  } else {
    // Show the error to the user
    try {
      // Response may contain an error message
      error = ErrorResponse.fromJson(jsonDecode(e.response.data)).toString();
    } catch (e) {
      // Use a generic error
      error = LocaleKeys.api_generic_error.tr();
    }
  }

  // Show the error
  Scaffold.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(error)));

  return error;
}
