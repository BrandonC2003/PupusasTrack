abstract class SessionService {
  //Metodos genericos para manipular valores en session
  Future<String?> getValue(String name);
  Future<void> setValue(String name, String value);
  Future<void> clearValue(String name);

  //metodos especificos para id de pupusria (el mas utilizado)
  Future<String?> getIdPupuseria();
  Future<void> setIdPupuseria(String idPupuseria);
  Future<void> cleaIdPupuseria();
}