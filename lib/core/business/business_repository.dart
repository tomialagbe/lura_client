import 'package:lura_client/core/api/api.dart';
import 'package:lura_client/core/business/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessRepository {
  static const _prefKeyBusinessId = 'businessId';
  static const _prefKeyBusinessName = 'businessName';

  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  const BusinessRepository(
      {required this.apiClient, required this.sharedPreferences});

  Future<Business?> getBusinessForUser() async {
    final cachedBusiness = _getFromPreferences();
    if (cachedBusiness != null) {
      return cachedBusiness;
    }

    return await _getFromServer();
  }

  Future<bool> saveBusinessForUser(String businessName) async {
    await apiClient.post('/businesses', data: {'businessName': businessName});
    return true;
  }

  Business? _getFromPreferences() {
    final id = sharedPreferences.getInt(_prefKeyBusinessId);
    if (id == null) {
      return null;
    }

    final name = sharedPreferences.getString(_prefKeyBusinessName);
    if (name == null) {
      sharedPreferences.remove(_prefKeyBusinessId);
      return null;
    }

    return Business(id: id, name: name);
  }

  Future<Business?> _getFromServer() async {
    try {
      final resp = await apiClient.get('/businesses');
      final business = Business.fromJson(resp!.data);
      return business;
    } on ResponseException catch (ex) {
      if (ex.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }
}
