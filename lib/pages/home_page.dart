import 'package:flutter/material.dart';
import 'package:matrixyy/dialogs/custom_alert_dialog2.1.dart';
import '../dialogs/custom_alert_dialog1.1.dart';
import '../widgets/containers.dart';
import '../widgets/containers2.dart';

class HomePage extends StatefulWidget {
  final String? matriz1; //recebendo a variavel matriz, colocando no construtor
  final String? matriz2;

  const HomePage({super.key, this.matriz1, this.matriz2});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> items = ['adicao', 'subracao', 'multiplicacao', 'divisao'];
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    final matriz1 = widget.matriz1;
    final matriz2 = widget.matriz2;

    final myHistoricTile = GestureDetector(
      onTap: () {
        //ação ao clicar no card
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.073,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 2,
              color: Color.fromRGBO(23, 23, 23, 1),
            ),
          ),
          gradient: RadialGradient(
            colors: [
              Color.fromRGBO(16, 16, 16, 1),
              Color.fromRGBO(7, 7, 7, 1),
            ],
            radius: 3,
            center: Alignment.center,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.add,
              color: Color.fromRGBO(217, 217, 217, 1),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Adicao',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Soma a matriz X e Y',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                        color: Color.fromRGBO(100, 92, 92, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    final myAppBarContainer = Container(
      //'appbar'
      height: MediaQuery.of(context).size.height * 0.13,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(128, 67, 0, 1),
            Color.fromRGBO(65, 32, 0, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('bem vindo mulekot'),
            Icon(Icons.person),
          ],
        ),
      ),
    );
    final myBlackContainer = Container(
      // container preto
      height: MediaQuery.of(context).size.height * 0.14,
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 27.5,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Text(
                'Operacao',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 8.0),
                color: Colors.white,
                child: DropdownButton<String>(
                  value: selectedOption,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedOption = newValue;
                    });
                  },
                  hint: const Text(
                    'selecione',
                    style: TextStyle(color: Colors.white),
                  ),
                  items: items
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 9,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.029,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.amber),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Column(children: [
                              Text('$matriz1'),
                              const SizedBox(
                                height: 20,
                              ),
                              Text('$matriz2'),
                            ]),
                          );
                        });
                  },
                  child: const Text(
                    'Calcular',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

    void showCustomDialog1() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog();
        },
      );
    }

    void showCustomDialog2() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog3();
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          myAppBarContainer,
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Stack(
                  children: [
/*Quanto ao uso do top, bottom, left e right em Positioned, essas propriedades são usadas para definir a 
posição de um widget filho dentro do Stack, especificando as distâncias a partir das bordas do Stack. 
No entanto, ao usar o Positioned.fill, o widget filho ocupará todo o espaço disponível dentro do Stack, 
portanto, não é necessário especificar as propriedades top, bottom, left e right. 
*/
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Row(
                      //matrizes
                      children: [
                        InkWell(
                          //animacao
                          onTap: () {
                            showCustomDialog1();
                          },
                          child: MyContainer(
                            text1: matriz1,
                          ),
                        ),
                        InkWell(
                          //animacao
                          onTap: () {
                            showCustomDialog2();
                          },
                          child: MyContainer2(
                            text2: matriz2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                myBlackContainer,
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(7, 7, 7, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Historico',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          //remove padding padrao do listview
                          padding: EdgeInsets.zero,
                          children: [
                            myHistoricTile,
                            const SizedBox(
                              height: 10,
                            ),
                            myHistoricTile,
                            const SizedBox(
                              height: 10,
                            ),
                            myHistoricTile,
                            const SizedBox(
                              height: 10,
                            ),
                            myHistoricTile,
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
