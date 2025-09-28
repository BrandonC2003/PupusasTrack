import 'package:pupusas_track/core/domain/services/session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionServiceImpl implements SessionService {
  final SharedPreferences prefs;
  static const _idPupuseriakey = 'idPupuseria';

  SessionServiceImpl(this.prefs);

  @override
  Future<String?> getValue(String name) async {
    return prefs.getString(name);
  }

  @override
  Future<void> setValue(String name, value) async {
    await prefs.setString(name, value);
  }

  @override
  Future<void> clearValue(String name) async {
    await prefs.remove(name);
  }

  @override
  Future<String?> getIdPupuseria() async {
    return prefs.getString(_idPupuseriakey);
  }

  @override
  Future<void> setIdPupuseria(String idPupuseria) async {
    await prefs.setString(_idPupuseriakey, idPupuseria);
  }

  @override
  Future<void> cleaIdPupuseria() async {
    await prefs.remove(_idPupuseriakey);
  }
}
