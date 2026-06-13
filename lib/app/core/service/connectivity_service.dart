import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

final class ConnectivityService extends GetxService {
  static ConnectivityService get to => Get.find();
  final _connectivity = Connectivity();
  final isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
    _probe(); // initial check
  }

  Future<bool> get hasConnection async {
    await _probe();
    return isOnline.value;
  }

  Future<void> _probe() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 5));
      isOnline.value = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline.value = false;
    } on TimeoutException catch (_) {
      isOnline.value = false;
    }
  }

  Future<void> _handleConnectivityChange(List<ConnectivityResult> results) async {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      isOnline.value = false;
    } else {
      await _probe();
    }
  }
}
