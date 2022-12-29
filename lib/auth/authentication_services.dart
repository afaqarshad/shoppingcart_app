import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppingcart_app/screens/homepage.dart';
import 'package:shoppingcart_app/screens/login_page.dart';
import 'package:shoppingcart_app/utils/app_toast.dart';

class AuthenticationServices {
  static signUp(
      {required BuildContext context,
      required email,
      required password}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => print("success"));
      // saveUserData();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == "unknown") {
        print("Some fild miss please double check");
      } else if (e.code == "invalid-email") {
        print("Your email format is not correct please try again");
      } else if (e.code == "weak-password") {
        print("Password should be greater then 6 digit");
      } else if (e.code == "email-already-in-use") {
        print("Your email already exist please try another email");
      }
      print("Firebase e $e");
    } catch (e) {
      print("e $e");
    }
  }

  static login({required context, required email, required password}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
      AppToast.successToast(masg: "SingUp Success!");
      print("Login Success!");
    } on FirebaseAuthException catch (e) {
      print("Firebae Auth $e");
      if (e.code == "wrong-password") {
        AppToast.failToast(masg: "Your Password is Wrong Please try again");
      } else if (e.code == "user-not-found") {
        AppToast.failToast(masg: "Email not Found Please try again");
      }
    } catch (e) {
      print(e);
    }
  }

  static logout() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
  }
}
