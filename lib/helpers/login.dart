import 'package:filcnaplo/ui/common/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/login.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/kreta/client.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/data/models/user.dart';
import 'package:filcnaplo/utils/tools.dart';

class LoginHelper {
  Future<bool> submit(BuildContext context) async {
    bool error = false;

    // bypass login
    if (loginContext.username == "nobody" &&
        loginContext.password == "nobody" &&
        app.debugMode) {
      app.users.add(User("debug", "nobody", "nobody", "nowhere"));
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
        loginContext.username!, loginContext.selectedSchool!.instituteCode);

    if (app.debugMode) print("DEBUG: UserID: " + userID);

    User user = User(
      userID,
      loginContext.username!,
      loginContext.password!,
      loginContext.selectedSchool!.instituteCode,
    );

    app.kretaApi.users[userID] = KretaClient();

    if (await app.kretaApi.users[userID]!.login(user)) {
      await app.settings.update(login: false);

      app.selectedUser = app.users.length - 1;
      // app.users[app.selectedUser].loginState = true;

      return true;
    } else {
      if (loginContext.error == null) {
        app.kretaApi.users.remove(userID);
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
          message: I18n.of(context).loginError,
          duration: Duration(seconds: 3),
          color: Colors.red,
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
