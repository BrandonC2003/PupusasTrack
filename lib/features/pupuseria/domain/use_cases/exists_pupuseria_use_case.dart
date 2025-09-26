import 'package:pupusas_track/features/pupuseria/domain/repositories/pupuseria_repository.dart';

class ExistsPupuseriaUseCase {

  final PupuseriaRepository pupuseriaRepository;

  ExistsPupuseriaUseCase({required this.pupuseriaRepository});

  Future<bool> call(String id) async {
    return pupuseriaRepository.existsPupuseria(id);
  }
}
