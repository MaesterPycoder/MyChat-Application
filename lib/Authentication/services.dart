import 'package:firebase_auth/firebase_auth.dart';
import 'package:mychat/models/userInfo.dart';

// Describing the Authentication services for our App
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserInformation _userFromFirebaseUser(User user) {
    return user != null ? UserInformation(user.uid) : "Failed to Login";
  }

  // Get status of user mail verification
  get isEmailVerified {
    return _auth.currentUser.emailVerified;
  }

// Return's current user
  get currentUser {
    return _auth.currentUser;
  }

// Reloading the current user
  Future reloadUser() async {
    await _auth.currentUser.reload();
  }

// Method for sending verification mail
  Future verifyEmail() async {
    await _auth.currentUser.sendEmailVerification();
  }

// Method for signing into user account
  Future userSignInEmailAndPassword(String uemail, String upassword) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: uemail, password: upassword);
      User firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      // Return's error if occurs
      return e.code;
    }
  }

// Creating account for new User
  Future userSignUpEmailAndPassword(String eemail, String epassword) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: eemail, password: epassword);
      User firebaseUser = result.user;
      print(firebaseUser.uid);
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      return e.code;
    }
  }

// Sending password reset mail to user
  Future userResetPassword(String remail) async {
    try {
      return await _auth.sendPasswordResetEmail(email: remail);
    } catch (e) {
      return e.code;
    }
  }

// Signing our from account
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return e.code;
    }
  }
}
