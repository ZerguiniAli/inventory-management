import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../DB/mysqlConnection.dart';
import 'ProductName.dart';
import 'package:mysql1/mysql1.dart';

class ListPage extends StatefulWidget {
  final Function(Uint8List?, String, int, String) onProductSelected;
  const ListPage({Key? key, required this.onProductSelected}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<List<dynamic>> products = [];
  List<List<dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products when the widget initializes
  }

  Future<void> fetchProducts() async {
    try {
      var mysql = Mysql();
      await mysql.connect();

      var results = await mysql.connection.query('SELECT * FROM produits');
      if (results.isNotEmpty) {
        setState(() {
          products = results.map((row) {
            final imageData = row['image'];
            Uint8List? pict;
            if (imageData is Blob) {
              pict = Uint8List.fromList(imageData.toBytes());
            }
            return [
              pict, // Picture
              row['nom_produit'], // Name
              row['prix_vente'], // Price
              row['code_barre']
            ];
          }).toList();
          filteredProducts = List.from(products); // Initialize filteredProducts with all products
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void searchProducts(String query) {
    setState(() {
      filteredProducts = products.where((product) {
        final productName = product[1].toString().toLowerCase();
        final barcode = product[3].toString().toLowerCase();
        return productName.contains(query.toLowerCase()) || barcode.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to Zing",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Discover whatever you want easily",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              Container(
                width: 350,
                height: 50,
                child: TextField(
                  onChanged: searchProducts, // Call searchProducts when text changes
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0), // Adjust vertical padding
                    prefixIconConstraints: BoxConstraints(minWidth: 40),
                    hintText:
                    "Search Product", // Adjust icon size,
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, // Remove all border sides
                      borderRadius:
                      BorderRadius.circular(5), // Remove border radius
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none, // Remove all border sides when focused
                      borderRadius:
                      BorderRadius.circular(5), // Remove border radius
                    ),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        widget.onProductSelected(
                          filteredProducts[index][0] as Uint8List?, // Picture
                          filteredProducts[index][1], // Name
                          int.parse(filteredProducts[index][2]), // Price
                          filteredProducts[index][3],
                        );
                      },
                      child: ProductTile(
                        Name: filteredProducts[index][1],
                        Price: filteredProducts[index][2],
                        Picture: filteredProducts[index][0] as Uint8List?, // Pass the Uint8List? data
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
