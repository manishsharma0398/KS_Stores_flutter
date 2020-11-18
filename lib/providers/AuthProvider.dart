import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  bool isUserAdmin = false;
  Map<String, dynamic> userDetails = {};

  CollectionReference users = FirebaseFirestore.instance.collection("users");
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> checkIfUserAlreadyRegistered(String email) async {
    bool userAlreadyRegistered;

    final userLength = await users.where("email", isEqualTo: email).get();

    if (userLength.docs.length == 0) {
      userAlreadyRegistered = false;
    } else {
      userAlreadyRegistered = true;
    }

    return userAlreadyRegistered;
  }

  void logInWithEmail() {}

  void signupWithEmail() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: "barry.allen@example.com",
              password: "SuperSecretPassword!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  getUserDetailsAtStartup() async {
    if (auth.currentUser != null) {
      getAndSetUserDetails(auth.currentUser.email);
    }
  }

  Future<void> continueWithGmail() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // print('@@@@@@@@@@@@@@');
    // print(credential);
    // print(credential.accessToken);
    // print(credential.idToken);
    // // google, facebook
    // print(credential.providerId);
    // print('@@@@@@@@@@@@@@');

    // print('##############');
    // print(googleAuth);
    // print(googleAuth.accessToken);
    // print(googleAuth.idToken);
    // print('##############');

    // print('%%%%%%%%%%%%%%');
    // print(googleUser);
    // print(googleUser.displayName);
    // print(googleUser.email);
    // print(googleUser.id);
    // print(googleUser.photoUrl);
    // print('%%%%%%%%%%%%%%');

    await users
        .where("email", isEqualTo: googleUser.email)
        .get()
        .then((usersLength) async {
      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (usersLength.docs.length == 0) {
        registerWithGmail(googleUser, authResult.user.uid);
      } else {
        getAndSetUserDetails(googleUser.email);
      }
    });
  }

  getAndSetUserDetails(String userEmail) async {
    final snapshot = await users.where("email", isEqualTo: userEmail).get();

    final userData = snapshot.docs;

    if (userData.isNotEmpty) {
      userDetails = userData.single.data();
      // print(userDetails);

      isUserAdmin = userDetails["admin"] == null ? false : userDetails["admin"];

      notifyListeners();
    }
  }

  registerWithGmail(GoogleSignInAccount userDetails, String userId) async {
    bool isAdmin = false;

    await FirebaseFirestore.instance
        .collection("admins")
        .where("email", isEqualTo: userDetails.email)
        .get()
        .then((value) => value.docs.length > 0 ? isAdmin = true : false);

    await users.doc(userId).set({
      "email": userDetails.email.trim(),
      "phone": "",
      "admin": isAdmin,
      "address": "",
      "dp": userDetails.photoUrl.trim(),
      "name": userDetails.displayName
          .split(" ")
          .map((str) => str[0].toUpperCase() + str.substring(1).toLowerCase())
          .join(" ")
          .trim(),
    });

    // if (isAdmin) {
    //   // isUserAdmin = true;
    //   notifyListeners();
    // }
  }
}
