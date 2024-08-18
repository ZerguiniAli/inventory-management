import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String Name;
  final String Price;
  final Uint8List? Picture;

  ProductTile({
    Key? key,
    required this.Name,
    required this.Price,
    required this.Picture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 140,
      width: 40,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Container(
                  height: 140,
                  child: Picture != null
                      ? Image.memory(Picture!) // Display image from Uint8List
                      : Image.asset("lib/icons/box.png"), // Handle null Picture
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: Text(
                Name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: Text(
                "$Price DZD",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}