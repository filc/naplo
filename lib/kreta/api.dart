import 'package:filcnaplo/kreta/client.dart';

class BaseURL {
  static const FILC = "https://filcnaplo.hu";
  static const FILC_BACKUP = "https://backup.filcnaplo.hu";
  static String kreta(String instituteCode) =>
      "https://$instituteCode.e-kreta.hu";
  static const KRETA_IDP = "https://idp.e-kreta.hu";
  static const KRETA_ADMIN = "https://eugyintezes.e-kreta.hu";
  static const KRETA_FILES = "https://files.e-kreta.hu";
  static const FILC_REPO = "https://api.github.com/repos/filc/naplo";
}

class FilcEndpoints {
  static const schoolList = "/school_list.json";
  static const schoolList2 = "/v2/school_list.json";
  static const config = "/settings.json";
  static const config2 = "/v2/config.json";
  static const supporters = "/v2/supporters.json";
  static const news = "/v2/news.json";
  static const latestRelease = "/releases/latest";
}

class KretaEndpoints {
  static const token = "/connect/token";
  static const notes = "/ellenorzo/V3/Sajat/Feljegyzesek";
  static const events = "/ellenorzo/V3/Sajat/FaliujsagElemek";
  static const student = "/ellenorzo/V3/Sajat/TanuloAdatlap";
  static const evaluations = "/ellenorzo/V3/Sajat/Ertekelesek";
  static const absences = "/ellenorzo/V3/Sajat/Mulasztasok";
  static const groups = "/ellenorzo/V3/Sajat/OsztalyCsoportok";
  static const classAverages =
      "/ellenorzo/V3/Sajat/Ertekelesek/Atlagok/OsztalyAtlagok";
  static const timetable = "/ellenorzo/V3/Sajat/OrarendElemek";
  static const exams = "/ellenorzo/V3/Sajat/BejelentettSzamonkeresek";
  static const homework = "/ellenorzo/V3/Sajat/HaziFeladatok";
  static const homeworkDone = "/ellenorzo/V3/Sajat/HaziFeladatok/Megoldva";
  static const capabilities = "/ellenorzo/V3/Sajat/Intezmenyek";
  static String downloadHomeworkAttachments(String uid, String type) =>
      "/ellenorzo/V3/Sajat/HaziFeladatok/Csatolmanyok/$uid,$type";
}

class AdminEndpoints {
  //static const messages = "/api/v1/kommunikacio/postaladaelemek/sajat";
  static const sendMessage = "/api/v1/kommunikacio/uzenetek";
  static String messages(String endpoint) =>
      "/api/v1/kommunikacio/postaladaelemek/$endpoint";
  static String message(String id) =>
      "/api/v1/kommunikacio/postaladaelemek/$id";
  static const recipientCategories = "/api/v1/adatszotarak/cimzetttipusok";
  static const availableCategories = "/api/v1/kommunikacio/cimezhetotipusok";
  static const recipientsTeacher = "/api/v1/kreta/alkalmazottak/tanar";
  static const uploadAttachment = "/ideiglenesfajlok";
  static String downloadAttachment(String id) =>
      "/api/v1/dokumentumok/uzenetek/$id";
  static const trashMessage = "/api/v1/kommunikacio/postaladaelemek/kuka";
  static const deleteMessage = "/api/v1/kommunikacio/postaladaelemek/torles";
}

class KretaAPI {
  Map<String, KretaClient> users = {};
  KretaClient client = KretaClient();

  void addUser(userID) {
    if (users[userID] == null) users[userID] = KretaClient();
  }
}
