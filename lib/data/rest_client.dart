import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/activity.dart';
import 'package:easyhour_app/models/booking.dart';
import 'package:easyhour_app/models/calendar.dart';
import 'package:easyhour_app/models/client.dart';
import 'package:easyhour_app/models/error.dart';
import 'package:easyhour_app/models/location.dart';
import 'package:easyhour_app/models/office.dart';
import 'package:easyhour_app/models/permit.dart';
import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/models/smart_working.dart';
import 'package:easyhour_app/models/task.dart';
import 'package:easyhour_app/models/timer.dart';
import 'package:easyhour_app/models/today_activity.dart';
import 'package:easyhour_app/models/trip.dart';
import 'package:easyhour_app/models/user.dart';
import 'package:easyhour_app/models/user_info.dart';
import 'package:easyhour_app/models/vacation.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/models/workplace.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EasyRest {
  static final EasyRest _instance = EasyRest._internal();

  static int _retry = 0;

  factory EasyRest() {
    return _instance;
  }

  get username => _username;
  String _username;

  get domain => _domain;
  String _domain;
  String _accessToken;
  String _refreshToken;

  PackageInfo packageInfo;

  Dio _dio = Dio()
    ..options.baseUrl = '$baseUrl/easyhour/api'
    ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  String get userAgent =>
      "EasyHourApp/${packageInfo?.version} " +
      "(${Platform.operatingSystem}/${Platform.operatingSystemVersion}; " +
      "${packageInfo?.appName}/${packageInfo?.buildNumber})";

  EasyRest._internal() {
    // Initialize logged user tokens from prefs
    initClient();

    // Add auth token to each request
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      // Wait for user information to be available first
      if (isUserLogged() && userInfo == null && options.path != '/user-info') {
        await getUserInfo();
      }

      return options
        ..headers.addAll({
          if (_accessToken != null) "Authorization": "Bearer $_accessToken",
          "X-AZIENDA-DOMAIN": _domain,
          Headers.contentTypeHeader: Headers.jsonContentType,
          HttpHeaders.userAgentHeader: userAgent,
        });
    }, onError: (e) async {
      if (e.response?.statusCode == 401) {
        // Ensure we don't get stuck in an infinite loop
        if (_retry++ < 2) {
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
    }, onResponse: (e) {
      _retry = 0;
    }));
  }

  void initClient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();

    _domain = prefs.getString('domain');
    _username = prefs.getString('username');
    _accessToken = prefs.getString('accessToken');
    _refreshToken = prefs.getString('refreshToken');
  }

  Future<bool> saveTokens(LoginResponse response) async {
    _accessToken = response?.accessToken;
    _refreshToken = response?.refreshToken;

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

      if (await saveTokens(LoginResponse.fromJson(jsonDecode(response.data)))) {
        // Also, wait for user information to be populated
        await getUserInfo();

        return true;
      }
    } catch (e, s) {
      print(e);
      print(s);
    }

    return false;
  }

  Future<bool> doLogout() {
    _accessToken = null;
    _refreshToken = null;
    userInfo = null;

    return saveTokens(null);
  }

  bool isUserLogged() => prefs.getString('accessToken')?.isNotEmpty ?? false;

  Future<List<TodayActivity>> getTodayActivities() async {
    Response<String> response = await _dio.get('/today-activities');

    TodayActivityResponse activities =
        TodayActivityResponse.fromJson(jsonDecode(response.data));

    return activities.malattia != null
        ? [activities.malattia]
        : (activities.ferie != null ? [activities.ferie] : activities.tasks);
  }

  Future<List<Task>> getTasks() async {
    Response<String> response = await _dio.get('/user-tasks');

    return TaskResponse.fromJson(jsonDecode(response.data)).items;
  }

  Future<List<Activity>> getActivities() async {
    Response<String> response = await _dio.get('/user-attivitas');

    return ActivityResponse.fromJson(jsonDecode(response.data)).items;
  }

  Future<WorkLog> addEditWorklog(WorkLog item) async {
    Response<String> response = await _dio.request<String>(
      '/worklogs',
      data: item.toJson(),
      options: Options(method: item.isNew ? 'POST' : 'PUT'),
    );

    return WorkLog.fromJson(jsonDecode(response.data), task: item.task);
  }

  Future<Response> deleteWorklog(WorkLog item) async {
    return _dio.delete('/worklogs/${item.id}');
  }

  Future<List<String>> getSuggestedDescriptions(Task task) async {
    Response<String> response =
        await _dio.get('/suggested-descriptions/${task.id}');

    return jsonDecode(response.data).cast<String>();
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

    userInfo = UserInfoResponse.fromJson(jsonDecode(response.data)).info;

    // Also set the Crashlytics ID here
    FirebaseCrashlytics.instance
        .setUserIdentifier(userInfo.userDTO.id?.toString());

    return userInfo;
  }

  Future<List<CalendarEvent>> getCalendarEvents(DateTimeRange dateRange) async {
    final startDate = DateFormat(restDateFormat).format(dateRange.start);
    final endDate = DateFormat(restDateFormat).format(dateRange.end);
    Response<String> response = await _dio
        .get('/calendar-activities?data_inizio=$startDate&data_fine=$endDate');

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

  Future<Location> addEditLocation(Location item) async {
    Response<String> response = await _dio.request<String>(
      '/user-locations',
      data: item.toJson(),
      options: Options(method: item.isNew ? 'POST' : 'PUT'),
    );

    return Location.fromJson(jsonDecode(response.data));
  }

  Future<Response> deleteLocation(Location item) async {
    return _dio.delete('/locations/${item.id}');
  }

  Future<Timer> startTimer(Task task, WorkLog worklog) async {
    Response<String> response = await _dio.post<String>('/start-timer',
        data: TimerStartRequest(task, worklog).toJson());

    return Timer.fromJson(jsonDecode(response.data));
  }

  Future<Timer> stopTimer(Timer timer) async {
    Response<String> response = await _dio.put<String>('/stop-timer',
        data: TimerStopRequest(timer).toJson());

    return Timer.fromJson(jsonDecode(response.data));
  }

  Future<List<Booking>> getBookings() async {
    // Mock data
    // return EasyMock().getBookings();

    Response<String> response = await _dio.get('/user-prenotaziones');

    return BookingResponse.fromJson(jsonDecode(response.data)).items;
  }

  Future<Response> deleteBooking(Booking item) async {
    return _dio.delete('/user-prenotaziones/${item.id}');
  }

  Future<Booking> addEditBooking(Booking item) async {
    Response<String> response = await _dio.request<String>(
      '/nuova-prenotazione',
      data: item.toJson(),
      options: Options(method: item.isNew ? 'POST' : 'PUT'),
    );

    return Booking.fromJson(jsonDecode(response.data));
  }

  Future<List<WorkPlace>> getWorkPlaces(DateTimeRange dateRange) async {
    Response<String> response = await _dio.get('/available-postaziones/' +
        '${dateRange.start.formatRest()}/${dateRange.end.formatRest()}');

    return WorkPlaceResponse.fromJson(jsonDecode(response.data)).items;
  }

  Future<List<Office>> getOffices() async {
    // Mock data
    // return EasyMock().getOffices();

    Response<String> response = await _dio.get('/ufficios');

    return OfficeResponse.fromJson(jsonDecode(response.data)).items;
  }

  Future<Office> addEditOffice(Office item) async {
    Response<String> response = await _dio.request<String>(
      '/ufficios',
      data: item.toJson(),
      options: Options(method: item.isNew ? 'POST' : 'PUT'),
    );

    return Office.fromJson(jsonDecode(response.data));
  }

  Future<Response> deleteOffice(Office item) async {
    return _dio.delete('/ufficios/${item.id}');
  }

  Future<bool> updatePushToken(String deviceId) async {
    Response<String> response = await _dio.post<String>('/pushes',
        data: UpdatePushRequest(deviceId, Platform.operatingSystem).toJson());

    return UpdatePushResponse.fromJson(jsonDecode(response.data)).deviceId ==
        deviceId;
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
