import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:message_notifier/common/widgets/no_internet_connections.dart';
import 'package:message_notifier/core/utils/network_helper.dart';

class InternetService extends GetxService {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.onInit();
  }

  Future<void> checkStatus() async {
    final noInternet = await NetworkHelper.isNotConnected();
    if(noInternet) {
      showNoInternetAlert();
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> connection) {
    if (connection.contains(ConnectivityResult.none)) {
      showNoInternetAlert();
    } else {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  void showNoInternetAlert() =>
      Get.dialog(
  NoInternetConnections(onRetry: retry),
  barrierDismissible: false,
);

      void retry() {
        if (Get.isDialogOpen == true) {
          Get.back();
          checkStatus();
    }
  }
}
