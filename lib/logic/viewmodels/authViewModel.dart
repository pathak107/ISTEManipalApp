import 'package:flutter/cupertino.dart';
import 'package:istemanipalapp/logic/models/User.dart';
import 'package:istemanipalapp/services/dialogService.dart';
import 'package:istemanipalapp/services/locator.dart';
import 'package:istemanipalapp/services/storageService.dart';
import 'package:istemanipalapp/services/api.dart';

enum Status { Uninitialized, Authenticated, Unauthenticated }

class AuthViewModel with ChangeNotifier {
  AuthViewModel();
  //making instace of web api and storage services to use their function
  var api = locator<Api>();
  var storage = locator<StorageService>();

  Status _status = Status.Uninitialized;
  User _user;
  String _token;
  String _headers;
  bool _isFetchingData = false;

  //getters
  User get user => _user;
  Status get status => _status;
  String get token => _token;
  bool get isFetchingData => _isFetchingData;
  String get headers => _headers;

  AuthViewModel.initialize() {
    checkLogIn();
  }

  //setters
  _setToken(value) {
    _token = value;
    _headers = "Token $_token";
    notifyListeners();
  }

  _setFetchingData(value) {
    _isFetchingData = value;
    notifyListeners();
  }

  _setStatus(value) {
    _status = value;
    notifyListeners();
  }

  _setUser(value) {
    _user = User.fromJson(value);
    notifyListeners();
  }

  setUserPoints(value) {
    _user.points = value;
    notifyListeners();
  }

  Future<dynamic> getTokenAndUser() async {
    return await storage.getTokenAndUser();
  }

  void checkLogIn() async {
    final tokenAndUser = await getTokenAndUser();
    if (tokenAndUser['token'] == null) {
      _setStatus(Status.Unauthenticated);
    } else {
      _setToken(tokenAndUser['token']);

      var user = {
        'username': tokenAndUser['username'],
        'email': tokenAndUser['email'],
        'first_name': tokenAndUser['first_name'],
        'last_name': tokenAndUser['last_name']
      };
      _setUser(user);
      _setStatus(Status.Authenticated);
    }
  }

  void signUp(username, email, firstName, lastName, password, password2) async {
    _setFetchingData(true);
    var userData = await api.registerUser(
        username, email, firstName, lastName, password, password2);
    if (userData['success'] == true) {
      storage.storeTokenAndUser(userData['user']);
      _setToken(userData['user']['token']);
      _setUser(userData['user']);
      _setStatus(Status.Authenticated);
      _setFetchingData(false);
    } else {
      locator<DialogService>().showAlertDialog('Error', userData['error']);
      _setFetchingData(false);
    }
  }

  void login(username, password) async {
    _setFetchingData(true);
    var userData = await api.loginUser(username, password);
    if (userData['success'] == true) {
      storage.storeTokenAndUser(userData['user']);
      _setToken(userData['user']['token']);
      _setUser(userData['user']);
      _setStatus(Status.Authenticated);
      _setFetchingData(false);
    } else {
      locator<DialogService>().showAlertDialog('Error', userData['error']);
      _setFetchingData(false);
    }
  }

  void logOut() async {
    _setStatus(Status.Unauthenticated);
    _setToken("");
    storage.deleteAllUserData();
  }
}
