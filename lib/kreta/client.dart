import 'dart:convert';
import 'dart:typed_data';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/context/message.dart';
import 'package:filcnaplo/data/models/attachment.dart';
import 'package:filcnaplo/data/models/subject.dart';
import 'package:filcnaplo/data/models/supporter.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:http/http.dart' as http;
import 'package:filcnaplo/data/context/login.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/data/models/recipient.dart';
import 'package:filcnaplo/data/models/school.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/data/models/event.dart';
import 'package:filcnaplo/data/models/student.dart';
import 'package:filcnaplo/data/models/user.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:filcnaplo/utils/parse_jwt.dart';
import 'package:filcnaplo/kreta/api.dart';

class KretaClient {
  var client = http.Client();
  final String clientId = "kreta-ellenorzo-mobile";
  final String userAgent = "hu.ekreta.student/1.0.5/Android/0/0";
  String accessToken;
  String refreshToken;
  String instituteCode;
  String userId;

  Future checkResponse(response, {bool retry = true}) async {
    if (instituteCode != null) {
      if (accessToken == null)
        print("WARNING: accessToken is null. How did this happen?");
      if (refreshToken == null)
        print("WARNING: refreshToken is null. How did this happen?");
    }

    if (response.statusCode == 401) {
      if (refreshToken != null && retry == true && userId != null)
        await refreshLogin();
      else
        throw "Authorization failed";
    }

    if (response.statusCode == 500) print(response.body);

    if (response.statusCode != 200 && response.statusCode != 204)
      throw "Invalid response: " + response.statusCode.toString();
  }

  Future<List<School>> getSchools() async {
    loginContext.schoolState = false;

    try {
      var response = await http.get(
        BaseURL.FILC + FilcEndpoints.schoolList2,
        headers: {"Content-Type": "application/json"},
      );

      checkResponse(response);

      List responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      List<School> schools = [];

      responseJson.forEach((school) => schools.add(School(
          school["instituteCode"] ?? "-",
          school["name"] ?? "-",
          school["city"] ?? "-")));

      schools.add(School(
        "klik035246001",
        "Zuglói Szent Szakáll Gimnázium",
        "Budapest",
      ));

      return schools;
    } catch (error) {
      print("ERROR: KretaAPI.getSchools: " + error.toString());
      return [];
    }
  }

  Future<List<List<Supporter>>> getSupporters() async {
    try {
      var response = await http.get(
        BaseURL.FILC + FilcEndpoints.supporters,
        headers: {"Content-Type": "application/json"},
      );

      checkResponse(response);

      Map responseJson = jsonDecode(response.body);
      List<List<Supporter>> supporters = [[], []];

      responseJson["top"].forEach(
          (supporter) => supporters[0].add(Supporter.fromJson(supporter)));
      responseJson["all"].forEach(
          (supporter) => supporters[1].add(Supporter.fromJson(supporter)));

      return supporters;
    } catch (error) {
      print("ERROR: KretaAPI.getSupporters: " + error.toString());
      return [[], []];
    }
  }

  Future<bool> login(User user) async {
    try {
      var response = await client.post(
        BaseURL.KRETA_IDP + KretaEndpoints.token,
        body: {
          "userName": user.username,
          "password": user.password,
          "institute_code": user.instituteCode,
          "grant_type": "password",
          "client_id": clientId
        },
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "User-Agent": userAgent,
        },
      );

      if (app.debugVersion) {
        print("DEBUG: KretaAPI.login: " +
            "\n       InstituteCode: " +
            user.instituteCode.toString().substring(0, 5) +
            "*" * (user.instituteCode.toString().length - 5) +
            "\n       Username: " +
            user.username.toString().substring(0, 3) +
            "*" * (user.username.toString().length - 3) +
            "\n       Password: ********");
      }

      await checkResponse(response, retry: false);

      loginContext.error = null;

      Map responseJson = jsonDecode(response.body);

      if (responseJson["error"] != null) {
        loginContext.error = responseJson["error"];
        return false;
      }

      if (responseJson["error"] == null) {
        accessToken = responseJson["access_token"];
        refreshToken = responseJson["refresh_token"];
        instituteCode = user.instituteCode;
        userId = user.id;

        Map studentJson = parseJwt(accessToken);

        if (!(await app.storage.storage.query("users"))
            .map((u) => u["id"])
            .toList()
            .contains(user.id)) {
          await app.storage.storage.insert("users", {
            "id": user.id,
            "name": studentJson["name"],
          });
        }

        if (app.storage.users[user.id] == null)
          await app.storage.createUser(user.id);

        await app.storage.users[user.id].update("kreta", {
          "username": user.username,
          "password": user.password,
          "institute_code": user.instituteCode,
        });

        return true;
      }

      return false;
    } catch (error) {
      print("ERROR: KretaAPI.login: " + error.toString());
      return false;
    }
  }

  Future<bool> refreshLogin() async =>
      await login(app.users.firstWhere((search) => search.id == userId));

  // currently buggy, do not use
  // Future<bool> refreshLogin() async {
  //   try {
  //     var response = await client.post(
  //       BaseURL.KRETA_IDP + KretaEndpoints.token,
  //       body: {
  //         "refresh_token": refreshToken,
  //         "institute_code": instituteCode,
  //         "grant_type": "refresh_token",
  //         "client_id": clientId,
  //       },
  //       headers: {
  //         "Content-Type": "application/x-www-form-urlencoded",
  //         "User-Agent": userAgent,
  //       },
  //     );

  //     await checkResponse(response);

  //     Map responseJson = jsonDecode(response.body);
  //     accessToken = responseJson["access_token"];
  //     refreshToken = responseJson["refresh_token"];
  //   } catch (error) {
  //     print("ERROR: KretaAPI.refreshLogin: " + error.toString());
  //     return false;
  //   }
  // }

  Future<List<Message>> getMessages(String type) async {
    try {
      var response = await client.get(
        BaseURL.KRETA_ADMIN + AdminEndpoints.messages(type),
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent,
        },
      );

      await checkResponse(response);

      List responseJson = jsonDecode(response.body);
      List<Message> messages = [];

      await Future.forEach(responseJson, (message) async {
        Map msg = await getMessage(message["azonosito"]);
        if (msg != null) messages.add(Message.fromJson(msg));
      });

      return messages;
    } catch (error) {
      print("ERROR: KretaAPI.getMessage: " + error.toString());
      return null;
    }
  }

  Future<Map> getMessage(int id) async {
    try {
      var response = await client.get(
        BaseURL.KRETA_ADMIN + AdminEndpoints.message(id.toString()),
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent,
        },
      );

      await checkResponse(response);

      Map responseJson = jsonDecode(response.body);

      return responseJson;
    } catch (error) {
      print("ERROR: KretaAPI.getMessage: " + error.toString());
      return null;
    }
  }

  Future<List<Recipient>> getRecipients() async {
    try {
      var response = await client.get(
        BaseURL.KRETA_ADMIN + AdminEndpoints.recipientsTeacher,
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent
        },
      );

      await checkResponse(response);

      List responseJson = jsonDecode(response.body);
      List<Recipient> recipients = [];

      responseJson.forEach((recipient) => recipients.add(Recipient(
          0,
          recipient["oktatasiAzonosito"],
          recipient["nev"] ?? "",
          recipient["kretaAzonosito"],
          RecipientCategory(9, "TANAR", "Tanár", "Tanár", "Tanár"))));

      return recipients;
    } catch (error) {
      print("ERROR: KretaAPI.getRecipients: " + error.toString());
      return null;
    }
  }

  Future<bool> sendMessage() async {
    try {
      List recipientsJson = [];
      List attachmentsJson = [];

      messageContext.recipients.where((r) => r.id != null).forEach((recipient) {
        recipientsJson.add({
          "azonosito": recipient.id,
          "kretaAzonosito": recipient.kretaId,
          "nev": recipient.name,
          "tipus": {
            "azonosito": recipient.category.id,
            "kod": recipient.category.code,
            "rovidNev": recipient.category.shortName,
            "nev": recipient.category.name,
            "leiras": recipient.category.description,
          },
        });
      });

      List<Attachment> attachments = [];

      for (int i = 0; i < messageContext.attachments.length; i++) {
        //messageContext.attachments[i].id = i;
        Attachment attachment =
            await uploadAttachment(messageContext.attachments[i]);
        if (attachment == null) throw "Failed to upload attachment";
        attachments.add(attachment);
      }

      attachments
          .where((a) => a.fileId != null && a.kretaFilePath != null)
          .forEach((attachment) {
        attachmentsJson.add({
          "fajlNev": attachment.name,
          "azonosito": 0,
          "fajl": {
            "fileHandler": "FileService",
            "utvonal": attachment.kretaFilePath,
            "ideiglenesFajlAzonosito": attachment.fileId,
          },
        });
      });

      print(attachmentsJson);

      Map messageJson = {
        "cimzettLista": recipientsJson,
        "csatolmanyok": attachmentsJson,
        "targy": messageContext.subject,
        "szoveg": messageContext.content,
      };

      if (messageContext.replyId != null)
        messageJson["elozoUzenetAzonosito"] = messageContext.replyId;

      messageJson["kuldesDatum"] =
          DateTime.now().toUtc().toIso8601String().split(".")[0] + "Z";
      messageJson["azonosito"] = 0;
      messageJson["feladoTitulus"] = "";

      var response = await client.post(
        BaseURL.KRETA_ADMIN + AdminEndpoints.sendMessage,
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent,
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(messageJson),
      );

      await checkResponse(response);

      return true;
    } catch (error) {
      print("ERROR: KretaAPI.sendMessage: " + error.toString());
      return false;
    }
  }

  Future<Attachment> uploadAttachment(Attachment attachment) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(BaseURL.KRETA_FILES + AdminEndpoints.uploadAttachment),
      );
      request.headers["Authorization"] = "Bearer $accessToken";
      request.headers["User-Agent"] = userAgent;
      request.files
          .add(await http.MultipartFile.fromPath('fajl', attachment.file.path));
      var response = await request.send();

      checkResponse(response);

      Map responseJson = jsonDecode(await response.stream.bytesToString());

      attachment.fileId = responseJson["fajlAzonosito"];
      attachment.kretaFilePath = responseJson["utvonal"];

      return attachment;
    } catch (error) {
      print("ERROR: KretaAPI.uploadAttachment: " + error.toString());
      return null;
    }
  }

  Future<Uint8List> downloadAttachment(Attachment attachment) async {
    try {
      var response = await client.get(
        BaseURL.KRETA_ADMIN +
            AdminEndpoints.downloadAttachment(attachment.id.toString()),
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent,
        },
      );

      await checkResponse(response);

      return response.bodyBytes;
    } catch (error) {
      print("ERROR: KretaAPI.downloadAttachment: " + error.toString());
      return null;
    }
  }

  Future<List<Note>> getNotes() async {
    try {
      var response = await client.get(
        BaseURL.kreta(instituteCode) + KretaEndpoints.notes,
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent,
        },
      );

      await checkResponse(response);

      List<Note> notes = [];

      List responseJson = jsonDecode(response.body);
      responseJson.forEach((json) => notes.add(Note.fromJson(json)));

      return notes;
    } catch (error) {
      print("ERROR: KretaAPI.getNotes: " + error.toString());
      return null;
    }
  }

  Future<List<Event>> getEvents() async {
    try {
      var response = await client.get(
        BaseURL.kreta(instituteCode) + KretaEndpoints.events,
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent,
        },
      );

      await checkResponse(response);

      List<Event> events = [];

      List responseJson = jsonDecode(response.body);
      responseJson.forEach((json) => events.add(Event.fromJson(json)));

      return events;
    } catch (error) {
      print("ERROR: KretaAPI.getEvents " + error.toString());
      return null;
    }
  }

  Future<Student> getStudent() async {
    try {
      var response = await client.get(
        BaseURL.kreta(instituteCode) + KretaEndpoints.student,
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent,
        },
      );

      await checkResponse(response);

      Map responseJson = jsonDecode(response.body);
      Student student = Student.fromJson(responseJson);

      return student;
    } catch (error) {
      print("ERROR: KretaAPI.getStudent: " + error.toString());
      return null;
    }
  }

  Future<List<Evaluation>> getEvaluations() async {
    try {
      var response = await client.get(
        BaseURL.kreta(instituteCode) + KretaEndpoints.evaluations,
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent,
        },
      );

      await checkResponse(response);

      List responseJson = jsonDecode(response.body);
      List<Evaluation> evaluations = [];

      responseJson.forEach(
          (evaluation) => evaluations.add(Evaluation.fromJson(evaluation)));

      return evaluations;
    } catch (error) {
      print("ERROR: KretaAPI.getEvaluations: " + error.toString());
      return null;
    }
  }

  Future<List<Absence>> getAbsences() async {
    try {
      var response = await client.get(
        BaseURL.kreta(instituteCode) + KretaEndpoints.absences,
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent,
        },
      );

      await checkResponse(response);

      List responseJson = jsonDecode(response.body);
      List<Absence> absences = [];

      responseJson
          .forEach((absence) => absences.add(Absence.fromJson(absence)));

      return absences;
    } catch (error) {
      print("ERROR: KretaAPI.getAbsences: " + error.toString());
      return null;
    }
  }

  Future<String> getGroups() async {
    try {
      var response = await client.get(
        BaseURL.kreta(instituteCode) + KretaEndpoints.groups,
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent
        },
      );

      await checkResponse(response);

      List responseJson = jsonDecode(response.body);
      String uid = responseJson[0]["OktatasNevelesiFeladat"]["Uid"];

      return uid;
    } catch (error) {
      print("ERROR: KertaAPI.getGroups: " + error.toString());
      return null;
    }
  }

  Future<List> getAverages(String groupId) async {
    try {
      var response = await client.get(
        BaseURL.kreta(instituteCode) +
            KretaEndpoints.classAverages +
            "?oktatasiNevelesiFeladatUid=" +
            groupId,
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent
        },
      );

      await checkResponse(response);

      List responseJson = jsonDecode(response.body);
      List averages = [];

      responseJson.forEach((average) {
        averages.add([
          Subject.fromJson(average["Tantargy"]),
          average["OsztalyCsoportAtlag"]
        ]);
      });

      return averages;
    } catch (error) {
      print("ERROR: KretaAPI.getAverages: " + error.toString());
      return null;
    }
  }

  Future<List<Exam>> getExams() async {
    try {
      var response = await client.get(
        BaseURL.kreta(instituteCode) + KretaEndpoints.exams,
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent
        },
      );

      await checkResponse(response);

      List responseJson = jsonDecode(response.body);
      List<Exam> exams = [];

      responseJson.forEach((exam) => exams.add(Exam.fromJson(exam)));

      return exams;
    } catch (error) {
      print("ERROR: KretaAPI.getExams: " + error.toString());
      return null;
    }
  }

  Future<List<Homework>> getHomeworks(DateTime from) async {
    try {
      var response = await client.get(
        BaseURL.kreta(instituteCode) +
            KretaEndpoints.homeworks +
            "?datumTol=" +
            from.toUtc().toIso8601String(),
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent
        },
      );

      await checkResponse(response);

      List responseJson = jsonDecode(response.body);
      List<Homework> homeworks = [];

      responseJson
          .forEach((homework) => homeworks.add(Homework.fromJson(homework)));

      return homeworks;
    } catch (error) {
      print("ERROR: KretaAPI.getHomeworks: " + error.toString());
      return null;
    }
  }

  Future<List<Lesson>> getLessons(DateTime from, DateTime to) async {
    if (from == null || to == null) return [];

    try {
      var response = await client.get(
        BaseURL.kreta(instituteCode) +
            KretaEndpoints.timetable +
            "?datumTol=" +
            from.toUtc().toIso8601String() +
            "&datumIg=" +
            to.toUtc().toIso8601String(),
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent
        },
      );

      await checkResponse(response);

      List responseJson = jsonDecode(response.body);
      List<Lesson> lessons = [];

      responseJson.forEach((lesson) => lessons.add(Lesson.fromJson(lesson)));

      return lessons;
    } catch (error) {
      print("ERROR: KretaAPI.getLessons: " + error.toString());
      return null;
    }
  }

  Future homeworkSolved(Homework homework, bool state) async {
    try {
      var response = await client.post(
        BaseURL.kreta(instituteCode) + KretaEndpoints.homeworkDone,
        body: '[{"IsMegoldva":$state,"TanarHaziFeladatUid":"${homework.id}"}]',
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent,
          "Content-Type": "application/json"
        },
      );

      await checkResponse(response);
    } catch (error) {
      print("ERROR: KretaAPI.homeworkSolved: " + error.toString());
    }
  }

  // Client method template
  /*
    Future<Type> getTemplate() async {
      try {
        var response = await client.get(endpoint,
          headers: {
            "Authorization": "Bearer $accessToken",
            "User-Agent": userAgent
          },
        );

        await checkResponse(response);
        
        Type template = response.body;

        return template;
      } catch (error) {
        print("ERROR: KretaAPI.getTemplate: " + error.toString());
        return null;
      }
    }
  */
}
