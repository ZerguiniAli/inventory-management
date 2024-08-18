import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:zing/DB/mysqlConnection.dart';
import 'package:zing/pages/rightPage.dart';
import 'package:zing/pages/stock_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedItemIndex = 1; // Track the index of the selected item
  int selectedIndexPage = 0;

  List Pages = [
    [1,SellPage()],
    [2,StockPage()]
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: 80,
                  child: Center(
                    child: Container(
                      height: 40,
                      child: Image.asset('lib/icons/logo.png'),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: 80,
                  child: Column(
                    children: [
                      Gap(50),
                      buildItem(0, 'lib/icons/house.png'),
                      Gap(25),
                      buildItem(1, 'lib/icons/dashboards.png'),
                      Gap(25),
                      buildItem(2, 'lib/icons/stock.png'),
                      Gap(25),
                      buildItem(3, 'lib/icons/delivered.png'),
                      Gap(25),
                      buildItem(4, 'lib/icons/employment.png'),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildItem(4, 'lib/icons/setting.png'),
                      Gap(25),
                      buildItem(5, 'lib/icons/logout.png'),
                    ],
                  ),
                ),
              )
            ],
          ),
          Expanded(child: Pages[selectedIndexPage][1]),
        ],
      ),
    );
  }

  Widget buildItem(int index, String imagePath) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Set cursor to pointer
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedItemIndex = index;
            selectedIndexPage = index - 1;// Update the selected item index
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300), // Duration for the animation
          padding: EdgeInsets.only(top: 5, left: 5, right: 5),
          height: 30,
          color: Colors.transparent,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              selectedItemIndex == index ? Colors.orange : Colors.black87,
              BlendMode.srcIn,
            ),
            child: Image.asset(
              imagePath,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ),
    );
  }
}
