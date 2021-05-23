import 'package:filcnaplo/data/models/school.dart';

LoginContext loginContext = LoginContext();

class LoginContext {
  String? username;
  String? password;
  School? selectedSchool;
  List<School> schools = [];
  bool schoolState = false; // if school list is downloaded
  bool passwordVisible = false;
  bool hint = false;
  bool loginHint = false;
  String? error;
  Map loginError = {};
}
