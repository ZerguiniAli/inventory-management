import 'package:mysql1/mysql1.dart';

class Mysql {
  late MySqlConnection _conn;

  Mysql() {
    connect();
  }

  Future<void> connect() async {
    var settings = ConnectionSettings(
      host: '127.0.0.1',
      port: 3306,
      user: 'root',
      db: 'gestiondestock',
    );

    _conn = await MySqlConnection.connect(settings);
  }

  MySqlConnection get connection => _conn;
}
