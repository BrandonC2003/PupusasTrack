abstract class FormStatus{
  final String message;
  const FormStatus({this.message = ""});
}

class InitialFormStatus extends FormStatus {
  const InitialFormStatus({super.message});
}

class SubmissionInProgress extends FormStatus {
  const SubmissionInProgress({super.message});
}

class InvalidFormStatus extends FormStatus {
  const InvalidFormStatus({super.message});
}

class SubmissionSuccess extends FormStatus {
  const SubmissionSuccess({super.message});
}

class SubmissionFailure extends FormStatus {
  const SubmissionFailure({super.message});
}