import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String name;
  final String description;
  final int price;
  CartModel(this.name, this.description, this.price);
  List<CartModel>? _items;

  List<CartModel> get items => _items!;

  final Stream<QuerySnapshot> itemstream =
      FirebaseFirestore.instance.collection('items').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('items');
  Future<void> getData() async {}
}
