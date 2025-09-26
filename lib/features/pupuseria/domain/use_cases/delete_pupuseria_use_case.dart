import 'package:pupusas_track/features/pupuseria/domain/repositories/pupuseria_repository.dart';

class DeletePupuseriaUseCase {

  final PupuseriaRepository pupuseriaRepository;

  DeletePupuseriaUseCase({required this.pupuseriaRepository});

  Future<void> call(String id) async {
    pupuseriaRepository.deletePupuseria(id);
  }
}
