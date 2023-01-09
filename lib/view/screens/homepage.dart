import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcart_app/utils/app_toast.dart';
import 'package:shoppingcart_app/view/widgets/mytextfromfields.dart';
import 'package:shoppingcart_app/viewmodel/auth_viewmodel.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  TextEditingController productNameController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  var isFavorite = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/buttom.png'), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MyTextFormFields(
                  hintText: 'Product Name',
                  obsText: false,
                  textController: productNameController),
              const SizedBox(
                height: 5,
              ),
              MyTextFormFields(
                hintText: 'description ',
                obsText: false,
                textController: descriptionController,
              ),
              const SizedBox(
                height: 5,
              ),
              MyTextFormFields(
                hintText: 'Price',
                obsText: false,
                textController: priceController,
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                  onPressed: () {
                    context.read<AuthViewModel>().uploadImage();
                  },
                  child: const Text('Select Image')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xff4c505b),
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          try {
                            context.read<AuthViewModel>().firebaseCollection(
                                productNameController: productNameController,
                                descriptionController: descriptionController,
                                priceController: priceController,
                                context: context);
                            AppToast.successToast(
                                masg: "Item Save Successfully");
                          } catch (e) {
                            AppToast.failToast(masg: "items fail");
                          }
                        },
                        icon: const Icon(
                          Icons.add,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('items')
                      .where('uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0,
                            mainAxisExtent: 300,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  16.0,
                                ),
                                color: Colors.amberAccent.shade100,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                    child: (snapshot.data!.docs[index]
                                                ['images'] !=
                                            null)
                                        ? Image.network(
                                            snapshot.data!.docs[index]
                                                ['images'],
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            'https://i.imgur.com/sUFH1Aq.png',
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.docs[index]
                                              ['productName'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .merge(
                                                const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]['price'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .merge(
                                                TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                var docID = snapshot
                                                    .data!.docs[index].id;
                                                context
                                                    .read<AuthViewModel>()
                                                    .deleteItem(docID);
                                                AppToast.successToast(
                                                    masg: "Item Deleted");
                                              },
                                              icon: const Icon(Icons.delete),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                var docID = snapshot
                                                    .data!.docs[index].id;
                                                context
                                                    .read<AuthViewModel>()
                                                    .deleteItem(docID);
                                              },
                                              icon: const Icon(Icons.favorite),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.shopping_cart,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return const Text("Some thing wrong");
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
