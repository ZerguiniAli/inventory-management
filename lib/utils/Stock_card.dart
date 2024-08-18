import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StockCard extends StatelessWidget {
  final Uint8List? Picture;
  final String CodeBare, Name, DateExp, Quantite, prixAchatTotal, prixAchatPiece, prixVente;
  const StockCard({super.key, required this.CodeBare, required this.Picture, required this.Name, required this.DateExp, required this.Quantite, required this.prixAchatTotal, required this.prixAchatPiece, required this.prixVente});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Container(
                  height: 120,
                  child: Picture != null
                      ? Image.memory(Picture!) // Display image from Uint8List
                      : Image.asset("lib/icons/box.png"), // Handle null Picture
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Code Bare :", style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                ),),
                Text(CodeBare)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Nom de produit :", style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),),
                Text(Name)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date d'expiration :", style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),),
                Text(DateExp)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Quantite :", style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),),
                Text(Quantite)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Prix d'achat total :", style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),),
                Row(
                  children: [
                    Text(prixAchatTotal),
                    SizedBox(width: 5,),
                    Text("DZD", style: TextStyle(
                        color: Colors.orange
                    ),)
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Prix achat par piece:", style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),),
                Row(
                  children: [
                    Text(prixAchatPiece),
                    SizedBox(width: 5,),
                    Text("DZD", style: TextStyle(
                        color: Colors.orange
                    ),)
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Prix de vente :", style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),),
                Row(
                  children: [
                    Text(prixVente, style: TextStyle(
                        color: double.parse(prixVente)> double.parse(prixAchatPiece) ? Colors.green : Colors.red
                    ),),
                    SizedBox(width: 5,),
                    Text("DZD", style: TextStyle(
                        color: Colors.orange
                    ),)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
