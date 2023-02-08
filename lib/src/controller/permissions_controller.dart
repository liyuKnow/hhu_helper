import 'package:permission_handler/permission_handler.dart';

class PermissionController {
  // THIS CLASS CONTROLS INDIVIDUAL AND GROUP APP PERMISSIONS AT STARTUP AND USE

  // CHECKING IF THESE PERMISSIONS ARE GRANTED
  static Future<bool> isLocationGranted() async {
    return await Permission.location.status.isGranted;
  }

  static Future<bool> isStorageGranted() async {
    return await Permission.storage.status.isGranted;
  }

  static Future<bool> isManageStorageGranted() async {
    return await Permission.manageExternalStorage.status.isGranted;
  }

  // REQUESTING FOR EACH PERMISSION
  static requestLocation() async {
    if (!await isLocationGranted()) {
      await Permission.location.request();
    }
  }

  static requestStorage() async {
    if (!await isStorageGranted()) {
      await Permission.storage.request();
    }
  }

  static requestManageStorage() async {
    if (!await isManageStorageGranted()) {
      await Permission.manageExternalStorage.request();
    }
  }

  // ON START UP REQUEST
  static onStartUpPermission() async {
    await requestManageStorage();

    await requestLocation();

    await requestStorage();
  }
}
