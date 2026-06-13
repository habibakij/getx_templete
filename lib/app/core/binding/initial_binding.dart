import 'package:get/get.dart';
import 'package:price_sense/app/core/network/api_client.dart';
import 'package:price_sense/app/core/service/connectivity_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiService>(ApiService(), permanent: true);
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
  }
}
