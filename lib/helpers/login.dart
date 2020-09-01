import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/login.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/kreta/client.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/data/models/user.dart';
import 'package:filcnaplo/utils/tools.dart';

class LoginHelper {
  final GlobalKey<ScaffoldState> key;

  LoginHelper({this.key});

  Future<bool> submit(BuildContext context) async {
    bool error = false;

    // bypass login
    if (loginContext.username == "nobody" &&
        loginContext.password == "nobody" &&
        app.debugVersion) {
      app.users.add(User("debug", "nobody", "nobody", null));
      app.user.name = "Test User";
      app.user.realName = "Test User";
      app.debugUser = true;
      app.selectedUser = 0;
      app.user.loginState = true;
      app.storage.addUser("debug");

      return true;
    }

    if (loginContext.username == "") {
      error = true;
      loginContext.loginError["username"] = I18n.of(context).loginUsernameError;
    }

    if (loginContext.password == "") {
      error = true;
      loginContext.loginError["password"] = I18n.of(context).loginPasswordError;
    }

    if (loginContext.selectedSchool == null) {
      error = true;
      loginContext.loginError["school"] = I18n.of(context).loginSchoolError;
    }

    if (error) {
      return false;
    }

    String userID = generateUserId(
        loginContext.username, loginContext.selectedSchool.instituteCode);

    if (app.debugVersion) print("DEBUG: UserID: " + userID);

    User user = User(
      userID,
      loginContext.username,
      loginContext.password,
      loginContext.selectedSchool.instituteCode,
    );

    app.kretaApi.users[userID] = KretaClient();

    if (await app.kretaApi.users[userID].login(user)) {
      await app.settings.update(login: false);

      app.selectedUser = app.users.length - 1;

      return true;
    } else {
      if (loginContext.error == null) {
        app.kretaApi.users[userID] = null;
        key.currentState.showSnackBar(SnackBar(
          content: Text(
            I18n.of(context).loginError,
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ));

        return false;
      } else {
        if (loginContext.error == "invalid_grant") {
          loginContext.loginError["password"] =
              I18n.of(context).loginWrongCredentials;

          return false;
        }

        return false;
      }
    }
  }
}
