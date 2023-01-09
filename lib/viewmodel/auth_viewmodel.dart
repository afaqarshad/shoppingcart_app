import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppingcart_app/model/cart_model.dart';
import 'package:shoppingcart_app/utils/app_toast.dart';
import 'package:shoppingcart_app/view/screens/homepage.dart';
import 'package:shoppingcart_app/view/screens/login_page.dart';

class AuthViewModel with ChangeNotifier {
  String imageUrl = '';
  String userEmail = "";

  signUp(
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

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
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
    notifyListeners();
  }

  login({required context, required email, required password}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
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
    notifyListeners();
  }

  logout() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
    notifyListeners();
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    userEmail = googleUser.email;
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  firebaseCollection({
    required BuildContext context,
    required TextEditingController productNameController,
    required TextEditingController descriptionController,
    required TextEditingController priceController,
  }) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('items').doc().set(
      {
        'productName': productNameController.text,
        'description': descriptionController.text,
        'price': priceController.text,
        'uid': uid,
        'favorite': false,
        'images': imageUrl.toString(),
      },
    );
    productNameController.clear();
    priceController.clear();
    descriptionController.clear();
    imageUrl = '';
    notifyListeners();
  }

  uploadImage() async {
    final firebaseStorage = FirebaseStorage.instance;
    final picker = ImagePicker();
    XFile? image;

    image = await picker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);

    var snapshot = await firebaseStorage.ref().child('images').putFile(file);

    var downloadUrl = await snapshot.ref.getDownloadURL();

    imageUrl = downloadUrl;

    notifyListeners();
  }

  deleteItem(String docID) async {
    FirebaseFirestore.instance.collection('items').doc(docID).delete();
  }

  List<CartModel> listItems = [];
}
