import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/auth/auth_state.dart';

class AuthBlocNotifier extends ChangeNotifier {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> _subscription;

  AuthBlocNotifier(this.authBloc) {
    _subscription = authBloc.stream.listen((state) {
      notifyListeners(); // esto refresca GoRouter
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}