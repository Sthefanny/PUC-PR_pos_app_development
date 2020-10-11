import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageRepository extends Disposable {
  final FlutterSecureStorage _storage;

  SecureStorageRepository(this._storage);

  Future<String> getItem(String key) async {
    return await _storage.read(key: key);
  }

  void setItem(String key, String value) async {
    return await _storage.write(key: key, value: value);
  }

  void deleteItem(String key) async {
    return await _storage.delete(key: key);
  }

  void deleteAll() async {
    return await _storage.deleteAll();
  }

  @override
  void dispose() {}
}
