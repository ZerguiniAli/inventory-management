import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:zing/utils/Stock_card.dart';
import '../DB/mysqlConnection.dart';
import '../utils/add_product_dialog.dart';
import '../utils/stock_product.dart';

class StockPage extends StatefulWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
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

      var results = await mysql.connection.query('SELECT * FROM produits ORDER BY `produits`.`nom_produit` ASC');
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
              row['code_barre'],
              row['nom_produit'], // Name
              row['date_expiration'], // Price
              row['quantite'],
              row['prix_achat_total'],
              row['prix_achat_par_piece'],
              row['prix_vente'],
            ];
          }).toList();
          filteredProducts = List.from(products); // Initialize filteredProducts with all products
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.only(top: 30, left: 50, right: 50, bottom: 10),
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Stock",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 450,
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          prefixIconConstraints: BoxConstraints(minWidth: 40),
                          hintText: "Search Product",
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: MaterialButton(
                        onPressed:() {
                          showDialog(
                            context: context,
                            builder: (context) => AddProductDialog(),
                          );
                        },
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: GridView.custom(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12.0, // Spacing between rows
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 200 / 176, // Aspect ratio of StockCard
                ),
                childrenDelegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return StockCard(
                      Picture: filteredProducts[index][0],
                      CodeBare: filteredProducts[index][1],
                      Name: filteredProducts[index][2],
                      DateExp: filteredProducts[index][3],
                      Quantite: filteredProducts[index][4].toString(),
                      prixAchatPiece: filteredProducts[index][6].toString(),
                      prixAchatTotal: filteredProducts[index][5].toString(),
                      prixVente: filteredProducts[index][7].toString(),
                    ); // Return the StockCard widget
                  },
                  childCount: filteredProducts.length,
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
