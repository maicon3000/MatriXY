import 'package:hive/hive.dart';

class HistoricDataBase {
  //separando a homePage das coisas relacionadas a database

  //reference our box
  final _myBox = Hive.box('mybox');

  //criando a lista, vamos usar essa lá na homepage( instanciando essa classe)
  List<dynamic> matrixHistory = [];

  //rodar se for a primeira vez abrindo o app
  void createInitialDate() {
    matrixHistory = [];
  }

  //carregar o banco se ja tivermos informacoes no
  void loadData() {
    matrixHistory = _myBox.get('HISTORICLIST', defaultValue: []);
  }

  //atualizar o banco
  void updateDataBase() {
    _myBox.put('HISTORICLIST', matrixHistory);
  }
}
