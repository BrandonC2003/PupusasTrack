import 'package:pupusas_track/features/pupuseria/domain/repositories/pupuseria_repository.dart';

class CreatePupuseriaUseCase {

  final PupuseriaRepository pupuseriaRepository;

  CreatePupuseriaUseCase({required this.pupuseriaRepository});

  Future<String> call() async {
    return pupuseriaRepository.createPupuseria();
  }
}
