import 'package:price_sense/app/core/network/api_client.dart';
import 'package:price_sense/app/core/network/api_endpoint.dart';
import 'package:price_sense/app/data/model/remote/response_model/product_model.dart';
import 'package:price_sense/app/data/model/remote/response_model/scan_product_model.dart';

class DashboardRepository {
  Future<List<ProductModel?>> getAllProduct() async {
    final res = await ApiService.to.get(ApiEndpoints.getProducts);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return List<ProductModel>.from((res.data as List).map((x) => ProductModel.fromJson(x)));
    }
    return [];
  }

  Future<ScanProductModel?> getScanProduct() async {
    final res = await ApiService.to.get("", customBaseUrl: "https://fakestoreapi.com/products/1");
    if (res.statusCode == 200 || res.statusCode == 201) {
      return scanProductModelFromJson(res.toString());
    }
    return null;
  }
}
