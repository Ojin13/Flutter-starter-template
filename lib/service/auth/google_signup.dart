import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_starter_template/common/model/user_model.dart';

import '../../ioc/ioc_container.dart';
import '../user_service.dart';

const List<String> scopes = <String>['email', 'https://www.googleapis.com/auth/userinfo.profile'];

class GoogleSignup {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _userServices = get<UserService>();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
  );

  Future<void> handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      await _userServices.createUserDocument(UserModel(
        id: _firebaseAuth.currentUser!.uid,
        name: _firebaseAuth.currentUser!.displayName ?? '',
        email: _firebaseAuth.currentUser!.email ?? '',
        createdByUser: _firebaseAuth.currentUser!.uid,
        createdDate: DateTime.now(),
        description: '',
      ));
    } on Exception catch (e) {
      print('exception->$e');
    }
  }
}
