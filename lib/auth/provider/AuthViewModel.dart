
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/source/FirebaseService.dart';
import '../../data/StateModel.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, StateModel<void>>(
  (ref) => AuthViewModel(ref),
);

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

class AuthViewModel extends StateNotifier<StateModel<void>> {
  final FirebaseService _firebaseService;

  AuthViewModel(Ref ref)
      : _firebaseService = ref.read(firebaseServiceProvider),
        super(StateModel.loading());

  Future<void> login(String email, String password) async {
    try {
      state = StateModel.loading();
      await _firebaseService.login(email, password);
      state = StateModel.success(null);
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }

  Future<void> signup(String email, String password, String name) async {
    try {
      state = StateModel.loading();
      await _firebaseService.signup(email, password, name);
      state = StateModel.success(null);
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }
}