import 'package:area_mobile/backend/google_auth.dart';

Future<String?> getStoredToken() async {
  String? token = await secureStorage.read(key: 'auth_token');
  if (token != null) {
    return token;
  }
  return null;
}
