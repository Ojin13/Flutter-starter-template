import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_starter_template/common/model/user_model.dart';

import '../../ioc/ioc_container.dart';
import '../user_service.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _userServices = get<UserService>();
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _userServices.createUserDocument(UserModel(
      id: currentUser!.uid,
      name: username,
      email: email,
      createdByUser: currentUser!.uid,
      createdDate: DateTime.now(),
      description: '',
    ));

    await currentUser!.updateDisplayName(username);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String getCurrentUserUuid() {
    User? currentUser = _firebaseAuth.currentUser;
    return currentUser != null ? currentUser.uid : 'Anonymous user';
  }

  Future<bool> reauthenticateUser(String password) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: password);

      try {
        await user.reauthenticateWithCredential(credential);
        return true;
      } on FirebaseAuthException catch (e) {
        return false;
      }
    }

    return false;
  }

  Future<void> changeUserPassword(String newPassword) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  Future<void> updateUsername(String username) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(username);
    }
  }

  Future<void> deleteAccount() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
