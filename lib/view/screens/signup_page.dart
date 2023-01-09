import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcart_app/view/screens/homepage.dart';

import 'package:shoppingcart_app/view/screens/login_page.dart';
import 'package:shoppingcart_app/view/widgets/mytextfromfields.dart';
import 'package:shoppingcart_app/viewmodel/auth_viewmodel.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  String userEmail = '';

  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 30),
              child: const Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          MyTextFormFields(
                            hintText: 'Enter Name',
                            obsText: false,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          MyTextFormFields(
                            hintText: 'Enter E-mail',
                            textController: emailcontroller,
                            obsText: false,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          MyTextFormFields(
                            hintText: 'Enter password',
                            textController: passcontroller,
                            obsText: true,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      context.read<AuthViewModel>().signUp(
                                          context: context,
                                          email: emailcontroller.text,
                                          password: passcontroller);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                style: const ButtonStyle(),
                                child: const Text(
                                  'Sign In',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () async {
                              await context
                                  .read<AuthViewModel>()
                                  .signInWithGoogle();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            },
                            child: Image.asset(
                              'assets/google button.png',
                              height: 100,
                              width: 400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
