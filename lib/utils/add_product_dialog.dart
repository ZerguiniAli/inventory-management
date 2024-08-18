import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import '../DB/mysqlConnection.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({Key? key}) : super(key: key);

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  TextEditingController _dateController = TextEditingController();
  String? _imagePath;
  Uint8List? _imageBytes;
  String barcode = '';
  String productName = '';
  String expDate = '';
  String price = '';
  String quantity = '';
  String sellingPrice = '';

  void _saveProduct(BuildContext context) async {
    double Price = double.parse(price);
    double QTE = double.parse(quantity);
    double PiecePriceBought = Price / QTE ;
    try {
      // Connect to MySQL
      var mysql = Mysql();
      await mysql.connect();

      // Convert image file to bytes
      if (_imagePath != null) {
        _imageBytes = await File(_imagePath!).readAsBytes();
      }

      // Prepare the SQL query
      var result = await mysql.connection.query(
        'INSERT INTO Produits (code_barre, image, nom_produit, date_expiration, quantite, prix_achat_total, prix_achat_par_piece, prix_vente)'
          'VALUES (?, ?, ?, ?, ?, ?, ?, ?);',
        [barcode,_imageBytes, productName, expDate, quantity, price, PiecePriceBought, sellingPrice],
      );

      if (result.affectedRows! > 0) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product saved'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save product'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save product'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter un produit'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image selection
            GestureDetector(
              onTap: () async {
                FilePickerResult? result =
                await FilePicker.platform.pickFiles(
                  type: FileType.image,
                );

                if (result != null) {
                  setState(() {
                    _imagePath = result.files.single.path!;
                  });
                }
              },
              child: Container(
                height: 90,
                width: double.infinity,
                child: _imagePath != null
                    ? Image.file(
                  File(_imagePath!),
                  fit: BoxFit.contain,
                )
                    : Icon(Icons.add_a_photo, size: 50),
              ),
            ),
            SizedBox(height: 10),
            // Barcode text field
            BarcodeKeyboardListener(
              onBarcodeScanned: (code) {
                setState(() {
                  barcode = code;
                  print('Scanned barcode: $barcode');
                });
              },
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Code barre',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: barcode),
                onChanged: (value) {
                  barcode = value;
                },
              ),
            ),
            SizedBox(height: 10),
            // Product name text field
            TextField(
              onChanged: (value) {
                productName = value;
              },
              decoration: InputDecoration(
                labelText: 'Nom de Produit',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Expiry date text field
            TextField(
              controller: _dateController,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 10),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateController.text =
                        pickedDate.toString().substring(0, 10);
                    expDate = pickedDate.toString().substring(0, 10);
                  });
                }
              },
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date d expiration',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Price text field
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                price = value;
              },
              decoration: InputDecoration(
                labelText: 'Prix d achat total',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Quantity text field
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                quantity = value;
              },
              decoration: InputDecoration(
                labelText: 'Quantite',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Selling price text field
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                sellingPrice = value;
              },
              decoration: InputDecoration(
                labelText: 'Prix de vente',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            _saveProduct(context);
          },
          child: Text('Save'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}