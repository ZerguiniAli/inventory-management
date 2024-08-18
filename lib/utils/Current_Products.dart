import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zing/DB/mysqlConnection.dart';
import 'package:zing/utils/ProductBuy.dart';

class CurrentProducts extends StatefulWidget {
  final List productsBuying;
  const CurrentProducts({Key? key, required this.productsBuying}) : super(key: key);

  @override
  _CurrentProductsState createState() => _CurrentProductsState();
}

class _CurrentProductsState extends State<CurrentProducts> {
  final TextEditingController changeQte = TextEditingController();

  num ProductTotalPrice(index) {
    num PTP = 0;
    PTP = widget.productsBuying[index][2] * widget.productsBuying[index][3];
    return PTP;
  }

  num _total() {
    num total = 0;
    for (int i = 0; i < widget.productsBuying.length; i++) {
      total += ProductTotalPrice(i);
    }
    return total;
  }

  Future<void> Pay (String baarcode) async{
    print (widget.productsBuying[2]);
    try{
      var mysql = Mysql();
      await mysql.connect();
      // final results =
    }on Exception catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      child: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Current Order",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              child: ListView.builder(
                itemCount: widget.productsBuying.length,
                itemBuilder: (context, index) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Change The Quantite of ${widget.productsBuying[index][1]}",
                                  style: TextStyle(fontSize: 16),),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                actions: [
                                  TextField(
                                    decoration: InputDecoration(
                                        hintText: "value",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        )
                                    ),
                                    controller: changeQte,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: TextButton(onPressed: () {
                                      String qte = changeQte.text;
                                      num QTE = int.parse(qte);
                                      setState(() {
                                        widget.productsBuying[index][3] = QTE;
                                        Navigator.of(context).pop();
                                        changeQte.clear();
                                      });
                                    }, child: Text("Save")),
                                  )
                                ],
                              );
                            });
                      },
                      child: ProductBuy(
                        Picture: widget.productsBuying[index][0],
                        Name: widget.productsBuying[index][1],
                        Price: ProductTotalPrice(index).toString(),
                        Qte: widget.productsBuying[index][3].toString(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "${_total()} DZD",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: MaterialButton(
                onPressed: (){Pay("asd");},
                color: Colors.orange,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Pay",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
