import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageRepository extends Disposable {
  final FlutterSecureStorage _storage;

  SecureStorageRepository(this._storage);

  Future<String> getItem(String key) async {
    return _storage.read(key: key);
  }

  Future<void> setItem(String key, String value) async {
    return _storage.write(key: key, value: value);
  }

  Future<void> deleteItem(String key) async {
    return _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    return _storage.deleteAll();
  }

  @override
  void dispose() {}
}
