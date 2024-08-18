import 'package:flutter/material.dart';
import 'package:zing/DB/mysqlConnection.dart';
import 'package:zing/pages/home.dart';

class Login extends StatelessWidget {
  Login({Key? key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) async {
    var db = Mysql(); // Initialize MySQL connection
    await db.connect(); // Connect to the database

    // Fetch username and password from text fields
    String username = usernameController.text;
    String password = passwordController.text;

    // Perform database query to check username and password
    var result = await db.connection.query(
      'SELECT * FROM login WHERE Username = ? AND Password = ?',
      [username, password],
    );

    // If the query result is not empty, login is successful
    if (result.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      // Handle login failure (e.g., show error message)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid username or password.'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          padding: EdgeInsets.all(40),
          height: 400,
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40,
                width: 40,
                margin: EdgeInsets.only(bottom: 20),
                child: Image.asset("lib/icons/logo.png"),
              ),
              Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Nom d utilisateur",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Mot de passe",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () => login(context),
                color: Colors.orange,
                height: 50,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "LogIn",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
