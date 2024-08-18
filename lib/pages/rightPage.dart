import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:zing/utils/Current_Products.dart';
import 'package:zing/utils/list_page.dart';
import '../DB/mysqlConnection.dart';
import 'package:mysql1/mysql1.dart';

class SellPage extends StatefulWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  State<SellPage> createState() => _RightSideState();
}

class _RightSideState extends State<SellPage> {
  List _productsBuying = [];

  void addToProductsBuying(Uint8List? picture, String name, int price, String barcode) {
    setState(() {
      // Check if the product already exists in the productsBuying list
      bool productExists = false;
      for (var product in _productsBuying) {
        if (product[1] == name) { // Check product name
          product[3]++; // Increase quantity
          productExists = true;
          break;
        }
      }
      // If the product doesn't exist, add a new entry
      if (!productExists) {
        _productsBuying.add([picture, name, price, 1]);
      }
    });
  }


  Future<void> handleBarcodeScan(String barcode) async {
    try {
      // Use the existing Mysql connection
      var mysql = Mysql();
      await mysql.connect();

      // Query the database for the product information
      final result = await mysql.connection.query('SELECT nom_produit, CAST(prix_vente AS SIGNED) AS prix_vente, image FROM produits WHERE code_barre = ?', [barcode]);
      if (result.isNotEmpty) {
        final row = result.first;
        final name = row['nom_produit'] as String;
        final price = row['prix_vente'] as int;
        final image = row['image'];

        // Convert the Blob data to Uint8List (if available)
        Uint8List? imageData;
        if (image is Blob) {
          imageData = Uint8List.fromList(image.toBytes());
        }
        // Add the product to the _productsBuying list
        addToProductsBuying(imageData, name, price, barcode);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Produit non trouvé'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on Exception catch (e) {
      // Handle any exceptions that occurred during the database query
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[200],
              child: BarcodeKeyboardListener(
                onBarcodeScanned: handleBarcodeScan,
                child: ListPage(
                  onProductSelected: addToProductsBuying,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: CurrentProducts(productsBuying: _productsBuying),
            ),
          )
        ],
      ),
    );
  }
}