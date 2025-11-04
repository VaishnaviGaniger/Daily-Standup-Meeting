import 'package:get/get.dart';
import 'package:message_notifier/common/widgets/update_available_alert.dart';
import 'package:message_notifier/core/services/shared_prefs_service.dart';
import 'package:message_notifier/core/utils/auth_helper.dart';
import 'package:message_notifier/features/auth/view/login_screen.dart';
import 'package:message_notifier/features/employees/view/emp_dashboard_items_screen.dart';
import 'package:message_notifier/features/employees/view/emp_dashboard_screen.dart';
import 'package:message_notifier/features/host/view/host_dashboard_items_Screen.dart';
import 'package:message_notifier/features/host/view/host_dashboard_screen.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:message_notifier/common/widgets/no_internet_connections.dart';
import 'package:message_notifier/core/services/internet_services.dart';
import 'package:message_notifier/core/utils/network_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(Duration(seconds: 2), checkVersion);
    super.onInit();
  }

  @override
  void onClose() {
    Get.put(InternetService());
    super.onClose();
  }

  Future<void> checkVersion() async {
    try {
      bool noInternet = await NetworkHelper.isNotConnected();
      if (noInternet) {
        Get.dialog(
          NoInternetConnections(
            onRetry: () {
              if (Get.isDialogOpen == true) {
                Get.back();
                checkVersion();
              }
            },
          ),
        );
      } else {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        final NewVersionPlus newVersion = NewVersionPlus(
          androidId: packageInfo.packageName,
          iOSId: packageInfo.packageName,
        );

        final status = await newVersion.getVersionStatus();

        if (status != null && status.canUpdate) {
          Get.dialog(UpdateAvailableAlert(storeLink: status.appStoreLink));
        } else {
          await startApp();
        }
      }
    } catch (e) {
      await startApp();
    }
  }

  Future<void> startApp() async {
    final token = await SharedPrefsService.getToken();
    final role = await SharedPrefsService.getRole();

    if (AuthHelper.isUserLogged()) {
      if (role == 'lead') {
        Get.offAll(() => HostDashboardScreen());
      } else if (role == 'employee') {
        Get.offAll(() => EmpDashboardScreen());
      } else {
        Get.offAll(() => LoginScreen());
      }
      //neeed to set homescreen later
    } else {
      Get.off(() => LoginScreen());
    }
  }
}
