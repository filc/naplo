import 'package:background_fetch/background_fetch.dart';
import 'package:filcnaplo/data/tasks/syncEvaluations.dart';

class BackgroundController {
  Future executeTask(String taskId) async {
    switch (taskId) {
      case "flutter_background_fetch":
        await syncEvaluations();
    }
  }

  Future init() async {
    try {
      int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          startOnBoot: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY,
        ),
        (String taskId) async {
          print("INFO: [BackgroundFetch] taskId: $taskId");
          // try {
          await executeTask(taskId);
          // } catch (error) {
          // print("ERROR: [BackgroundFetch] Failed to execute task: " + taskId);
          // }
          BackgroundFetch.finish(taskId);
        },
      );
      print("INFO: [BackgroundFetch] configure status: " + status.toString());
    } catch (error) {
      print("ERROR: [BackgroundFetch] configure failed: " + error.toString());
    }

    BackgroundFetch.registerHeadlessTask(_backgroundFetchHeadlessTask);
  }

  void _backgroundFetchHeadlessTask(HeadlessTask task) {
    String taskId = task.taskId;
    bool isTimeout = task.timeout;
    if (isTimeout) {
      // This task has exceeded its allowed running-time.
      print("[BackgroundFetch] Headless task timed-out: $taskId");
      BackgroundFetch.finish(taskId);
      return;
    }
    print("[BackgroundFetch] Headless event received: $taskId");
    BackgroundFetch.finish(taskId);
  }
}
