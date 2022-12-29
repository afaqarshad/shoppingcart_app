import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingcart_app/utils/app_toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: Container(
            color: Colors.amber,
            height: MediaQuery.of(context).size.height,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: productNameController,
                  style: const TextStyle(),
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: "Product",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(),
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: "Color",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                TextField(
                  controller: priceController,
                  style: const TextStyle(),
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: "Price",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),

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
                              FirebaseFirestore.instance
                                  .collection('items')
                                  .doc()
                                  .set(
                                {
                                  'productName': productNameController.text,
                                  'description': descriptionController.text,
                                  'price': priceController.text,
                                },
                              );
                              productNameController.clear();
                              priceController.clear();
                              descriptionController.clear();
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
                // CrudServices.storeUserData(),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('items')
                        .snapshots(),
                    builder: ((context, snapshot) {
                      return snapshot.data!.docs.isEmpty
                          ? const Text("No record")
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: ((context, index) {
                                return ListTile(
                                  title: Text(snapshot.data!.docs[index]
                                      ['productName']),
                                  subtitle: Text(snapshot.data!.docs[index]
                                      ['description']),
                                  trailing:
                                      Text(snapshot.data!.docs[index]['price']),
                                );
                              }));
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
