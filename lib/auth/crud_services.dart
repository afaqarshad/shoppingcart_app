import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingcart_app/utils/app_toast.dart';

class CrudServices {
  static storeUserData() {
    Expanded(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('items').snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.docs.isEmpty
                  ? const Text("No Record")
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data!.docs[index]['item']),
                          subtitle: Text(snapshot.data!.docs[index]['price']),
                          trailing: SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      var docID = snapshot.data!.docs[index].id;
                                      print(docID);

                                      FirebaseFirestore.instance
                                          .collection('items')
                                          .doc(docID)
                                          .delete();
                                      AppToast.successToast(
                                          masg: "Item Deleted");
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      var docID = snapshot.data!.docs[index].id;
                                      print(docID);
                                      FirebaseFirestore.instance
                                          .collection('items')
                                          .doc(docID)
                                          .set(
                                        {
                                          'item': "abc",
                                          'price': "90",
                                        },
                                      );
                                      AppToast.successToast(
                                          masg: "Item Update");
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return const Text("Some thing wrong");
            }
          })),
    );
  }
}
