abstract class PupuseriaRepository {
  Future<String> createPupuseria();
  Future<bool> existsPupuseria(String id);
  Future<void> deletePupuseria(String id);
}