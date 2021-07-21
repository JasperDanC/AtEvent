import 'package:at_event/models/user_image_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// This class handles anonymous authorization through firebase for image uploading.

class AnonymousAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create User object based on FirebaseUser
  UserImageModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserImageModel(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserImageModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
    //.map((User? user) => _userFromFirebaseUser(user)); less simple
  }

  // Sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
