import 'package:background_fetch/background_fetch.dart';

class BackgroundController {
  init() {
    BackgroundFetch.configure(
      BackgroundFetchConfig(minimumFetchInterval: 15),
      (String taskId) async {
        print("INFO: [BackgroundFetch] taskId: $taskId");
        BackgroundFetch.finish(taskId);
      },
    ).then((int status) {
      print("INFO: [BackgroundFetch] configure status: " + status.toString());
    }).catchError((error) {
      print("ERROR: [BackgroundFetch] configure failed: " + error.toString());
    });
  }

  Future test() async {
    await BackgroundFetch.scheduleTask(
      TaskConfig(taskId: "task1", delay: 5000),
    );
  }
}
