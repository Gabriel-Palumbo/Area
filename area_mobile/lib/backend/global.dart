import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String localhostURL = "https://localhost:8080";
String serverURL = "https://88.166.16.161:18001";

Future changeBaseURL(bool? isBaseURLLocalhost) async {
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  if (isBaseURLLocalhost == null) {
    await secureStorage.write(key: 'baseURL', value: serverURL);
    await secureStorage.write(key: 'isLocalhost', value: "false");
  }

  if (isBaseURLLocalhost == true) {
    await secureStorage.write(key: 'baseURL', value: localhostURL);
    await secureStorage.write(key: 'isLocalhost', value: "true");
  } else {
    await secureStorage.write(key: 'baseURL', value: serverURL);
    await secureStorage.write(key: 'isLocalhost', value: "false");
  }
}
