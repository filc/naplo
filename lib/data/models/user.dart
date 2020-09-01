import 'package:filcnaplo/data/controllers/sync.dart';
import 'package:filcnaplo/kreta/client.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:sqflite/sqflite.dart';

class User {
  String id;
  String name;
  String realName;
  String username;
  String password;
  String instituteCode;
  bool loginState = false;
  ProfileIcon profileIcon = ProfileIcon();
  String customProfileIcon;

  User(this.id, this.username, this.password, this.instituteCode);
}

class CurrentUser {
  Database _storage;
  SyncUser _sync;
  KretaClient _kreta;

  set id(String value) {
    app.users[app.selectedUser].id = value;
  }

  String get id {
    return app.users[app.selectedUser].id;
  }

  set name(String value) {
    app.users[app.selectedUser].name = value;
  }

  String get name {
    return app.users[app.selectedUser].name;
  }

  set realName(String value) {
    app.users[app.selectedUser].realName = value;
  }

  String get realName {
    return app.users[app.selectedUser].realName;
  }

  set username(String value) {
    app.users[app.selectedUser].username = value;
  }

  String get username {
    return app.users[app.selectedUser].username;
  }

  set password(String value) {
    app.users[app.selectedUser].password = value;
  }

  String get password {
    return app.users[app.selectedUser].password;
  }

  set instituteCode(String value) {
    app.users[app.selectedUser].instituteCode = value;
  }

  String get instituteCode {
    return app.users[app.selectedUser].instituteCode;
  }

  set loginState(bool value) {
    app.users[app.selectedUser].loginState = value;
  }

  bool get loginState {
    return app.users[app.selectedUser].loginState;
  }

  set profileIcon(ProfileIcon value) {
    app.users[app.selectedUser].profileIcon = value;
  }

  ProfileIcon get profileIcon {
    return app.users[app.selectedUser].profileIcon;
  }

  set customProfileIcon(String value) {
    app.users[app.selectedUser].customProfileIcon = value;
  }

  String get customProfileIcon {
    return app.users[app.selectedUser].customProfileIcon;
  }

  set storage(Database value) {
    _storage = null; // chill dart we're safe
    _storage = value;
  }

  Database get storage {
    return _storage;
  }

  set sync(SyncUser value) {
    _sync = null; // chill dart we're safe
    _sync = value;
  }

  SyncUser get sync {
    return _sync;
  }

  set kreta(KretaClient value) {
    _kreta = null; // chill dart we're safe
    _kreta = value;
  }

  KretaClient get kreta {
    return _kreta;
  }

  CurrentUser(
    this._kreta,
    this._storage,
    this._sync,
  );
}
