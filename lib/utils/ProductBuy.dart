import 'dart:typed_data';
import 'package:flutter/material.dart';

class ProductBuy extends StatefulWidget {
  final Uint8List? Picture;
  final String Name;
  final String Price;
  final String Qte;

  ProductBuy({
    Key? key,
    required this.Picture,
    required this.Name,
    required this.Price,
    required this.Qte,
  }) : super(key: key);

  @override
  _ProductBuyState createState() => _ProductBuyState();
}

class _ProductBuyState extends State<ProductBuy> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: widget.Picture != null
                ? Image.memory(widget.Picture!) // Display image from Uint8List
                : Image.asset("lib/icons/box.png")
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.Name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.Price} DZD",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${widget.Qte} PCS",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
