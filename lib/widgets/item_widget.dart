import 'package:bill_app/models/bill_model.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  /*String product;
  double price;
  String type;
  ItemWidget({
    required this.product,
    required this.price,
    required this.type,
  });*/

  BillModel billProduct;
  ItemWidget({
    required this.billProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          Icons.shopping_cart,
        ),
        title: Text(billProduct.product),
        subtitle: Text(billProduct.type),
        trailing: Text("S/ ${billProduct.price}"),
      ),
    );
  }
}
