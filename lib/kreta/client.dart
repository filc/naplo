import 'dart:convert';
import 'dart:typed_data';
import 'package:filcnaplo/data/models/config.dart';
import 'package:filcnaplo/data/models/new.dart';
import 'package:http/http.dart' as http;
import 'package:filcnaplo/kreta/api.dart';
import 'package:filcnaplo/utils/parse_jwt.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/context/message.dart';
import 'package:filcnaplo/data/models/attachment.dart';
import 'package:filcnaplo/data/models/subject.dart';
import 'package:filcnaplo/data/models/supporter.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/data/models/lesson.dart';
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
import 'package:intl/intl.dart';

class KretaClient {
  var client = http.Client();
  final String clientId = "kreta-ellenorzo-mobile";
  String userAgent;
  String accessToken;
  String refreshToken;
  String instituteCode;
  String userId;
  bool kretaOffline = false;

  Future checkResponse(http.Response response, {bool retry = true}) async {
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

    if (response.headers.containsKey("x-maintenance-mode") &&
        response.request.url.host.contains(instituteCode)) {
      kretaOffline = true;
    } else {
      kretaOffline = false;
    }
  }

  Future<List<School>> getSchools() async {
    loginContext.schoolState = false;

    try {
      var response = await http.get(
        Uri.parse(BaseURL.FILC + FilcEndpoints.schoolList2),
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

  Future<Map> getSupporters() async {
    try {
      var response = await http.get(
        Uri.parse(BaseURL.FILC + FilcEndpoints.supporters),
        headers: {"Content-Type": "application/json"},
      );

      checkResponse(response);

      Map responseJson = jsonDecode(response.body);
      Map supporters = {};

      supporters["top"] = [];
      responseJson["top"].forEach(
          (supporter) => supporters["top"].add(Supporter.fromJson(supporter)));
      supporters["all"] = [];
      responseJson["all"].forEach(
          (supporter) => supporters["all"].add(Supporter.fromJson(supporter)));

      supporters["progress"] = responseJson["progress"];

      return supporters;
    } catch (error) {
      print("ERROR: KretaAPI.getSupporters: " + error.toString());
      return {
        "top": [],
        "all": [],
        "progress": {"value": 0, "max": 100}
      };
    }
  }

  Future<Config> getConfig() async {
    try {
      var response = await http.get(
        Uri.parse(BaseURL.FILC + FilcEndpoints.config2),
        headers: {"Content-Type": "application/json"},
      );

      checkResponse(response);

      Map responseJson = jsonDecode(response.body);
      Config config = Config.fromJson(responseJson);

      return config;
    } catch (error) {
      print("ERROR: KretaAPI.getConfig: " + error.toString());
      return Config.defaults;
    }
  }

  Future<List<News>> getNews() async {
    try {
      var response = await http.get(
          Uri.parse(BaseURL.FILC + FilcEndpoints.news),
          headers: {"Content-Type": "application/json"});
      List<News> news = [];

      List responseJson = json.decode(response.body);

      responseJson.forEach((newJson) => news.add(News.fromJson(newJson)));

      return news;
    } catch (error) {
      print("ERROR: KretaAPI.getNews: " + error.toString());
      return [];
    }
  }

  Future<bool> login(User user) async {
    try {
      var response = await client.post(
        Uri.parse(BaseURL.KRETA_IDP + KretaEndpoints.token),
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

      if (app.debugMode) {
        print("DEBUG: KretaAPI.login: " +
            "\n       InstituteCode: " +
            user.instituteCode.toString().substring(0, 5) +
            "*" * (user.instituteCode.toString().length - 5) +
            "\n       Username: " +
            user.username.toString().substring(0, 3) +
            "*" * (user.username.toString().length - 3) +
            "\n       Password: ********");
      }

      // Do not uncomment this
      // await checkResponse(response, retry: false);

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

  Future<bool> refreshLogin() async => await login(
        app.users.firstWhere(
          (search) => search.id == userId,
          orElse: () => null,
        ),
      );

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
    print(userAgent);
    try {
      var response = await client.get(
        Uri.parse(BaseURL.KRETA_ADMIN + AdminEndpoints.messages(type)),
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
        Uri.parse(BaseURL.KRETA_ADMIN + AdminEndpoints.message(id.toString())),
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
        Uri.parse(BaseURL.KRETA_ADMIN + AdminEndpoints.recipientsTeacher),
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
        Uri.parse(BaseURL.KRETA_ADMIN + AdminEndpoints.sendMessage),
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
        Uri.parse(BaseURL.KRETA_ADMIN +
            AdminEndpoints.downloadAttachment(attachment.id.toString())),
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
        Uri.parse(BaseURL.kreta(instituteCode) + KretaEndpoints.notes),
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
        Uri.parse(BaseURL.kreta(instituteCode) + KretaEndpoints.events),
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
        Uri.parse(BaseURL.kreta(instituteCode) + KretaEndpoints.student),
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
        Uri.parse(BaseURL.kreta(instituteCode) + KretaEndpoints.evaluations),
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
        Uri.parse(BaseURL.kreta(instituteCode) + KretaEndpoints.absences),
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

  Future<Map<String, dynamic>> getGroup() async {
    try {
      var response = await client.get(
        Uri.parse(BaseURL.kreta(instituteCode) + KretaEndpoints.groups),
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent
        },
      );

      await checkResponse(response);

      List responseJson = jsonDecode(response.body);
      return {
        "uid": responseJson[0]["OktatasNevelesiFeladat"]["Uid"],
        "className": responseJson[0]["Nev"]
      };
    } catch (error) {
      print("ERROR: KretaAPI.getGroup: " + error.toString());
      return null;
    }
  }

  Future<List> getAverages(String groupId) async {
    try {
      var response = await client.get(
        Uri.parse(BaseURL.kreta(instituteCode) +
            KretaEndpoints.classAverages +
            "?oktatasiNevelesiFeladatUid=" +
            groupId),
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
        Uri.parse(BaseURL.kreta(instituteCode) + KretaEndpoints.exams),
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
        Uri.parse(BaseURL.kreta(instituteCode) +
            KretaEndpoints.homework +
            "?datumTol=" +
            from.toUtc().toIso8601String()),
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent
        },
      );

      await checkResponse(response);

      List responseJson = jsonDecode(response.body);
      List<Homework> homework = [];
      await Future.forEach(responseJson, (hw) async {
        var response2 = await client.get(
          Uri.parse(BaseURL.kreta(instituteCode) +
              KretaEndpoints.homework +
              "/" +
              hw["Uid"]),
          headers: {
            "Authorization": "Bearer $accessToken",
            "User-Agent": userAgent
          },
        );

        await checkResponse(response2);

        Map responseJson2 = jsonDecode(response2.body);
        homework.add(Homework.fromJson(responseJson2));
      });

      return homework;
    } catch (error) {
      print("ERROR: KretaAPI.getHomeworks: " + error.toString());
      return null;
    }
  }

  // Client method template

  Future<Uint8List> downloadHomeworkAttachment(
      HomeworkAttachment attachment) async {
    try {
      var response = await client.get(
        Uri.parse(BaseURL.kreta(instituteCode) +
            KretaEndpoints.downloadHomeworkAttachments(
                attachment.id.toString(), attachment.type)),
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent
        },
      );

      await checkResponse(response);

      return response.bodyBytes;
    } catch (error) {
      print("ERROR: KretaAPI.downloadHomeworkAttachment: " + error.toString());
      return null;
    }
  }

  Future<List<Lesson>> getLessons(DateTime from, DateTime to) async {
    if (from == null || to == null) return [];

    try {
      var response = await client.get(
        Uri.parse(BaseURL.kreta(instituteCode) +
            KretaEndpoints.timetable +
            "?datumTol=" +
            DateFormat('yyyy-MM-dd').format(from) +
            //from.toUtc().toIso8601String() +
            "&datumIg=" +
            //to.toUtc().toIso8601String(),
            DateFormat('yyyy-MM-dd').format(to)),
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

  Future<void> trashMessage(bool deleted, int id) async {
    Map data = {
      "isKuka": deleted,
      "postaladaElemAzonositoLista": [id]
    };

    try {
      var response = await client.post(
          Uri.parse(BaseURL.KRETA_ADMIN + AdminEndpoints.trashMessage),
          headers: {
            "Authorization": "Bearer $accessToken",
            "User-Agent": userAgent,
            "Content-Type": "application/json"
          },
          body: jsonEncode(data));
      await checkResponse(response);
    } catch (error) {
      print("ERROR: KretaAPI.trashMessage: " + error.toString());
      return null;
    }
  }

  Future<void> deleteMessage(int id) async {
    try {
      var response = await client.delete(
        Uri.parse(BaseURL.KRETA_ADMIN +
            AdminEndpoints.deleteMessage +
            "?postaladaElemAzonositok=" +
            id.toString()),
        headers: {
          "Authorization": "Bearer $accessToken",
          "User-Agent": userAgent,
        },
      );
      await checkResponse(response);
    } catch (error) {
      print("ERROR: KretaAPI.deleteMessage: " + error.toString());
      return null;
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
