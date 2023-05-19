import 'package:flutter/material.dart';

import '../pages/home_page.dart';

class CustomAlertDialog2 extends StatefulWidget {
  const CustomAlertDialog2(
      {super.key, this.selectedLine1, this.selectedColumn1, this.matriz1});
  final int? selectedLine1;
  final int? selectedColumn1;
  final int? matriz1;
  @override
  State<CustomAlertDialog2> createState() => _CustomAlertDialog2State();
}

class _CustomAlertDialog2State extends State<CustomAlertDialog2> {
  @override
  void initState() {
    super.initState();
    initializeMatrix();
  }

  List<List<int?>> matrixValues = [];

  void initializeMatrix() {
    matrixValues = List.generate(
      widget.selectedLine1!,
      (_) => List.generate(widget.selectedColumn1!, (_) => null),
    );
  }

//pegar cada elemento da matriz e inserir. quebrar linha quando acabar o numero de colunas.
  String printMatrix1() {
    final buffer = StringBuffer();
    for (int i = 0; i < widget.selectedLine1!; i++) {
      for (int j = 0; j < widget.selectedColumn1!; j++) {
        final value = matrixValues[i][j];
        buffer.write('$value\t\t\t');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  //texfield, ajustar posicoes, capturar dados das texfield, printar a matriz resultante num container

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        color: const Color.fromARGB(255, 190, 185, 198),
        width: 400,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      'Valores da matriz: ${widget.selectedLine1} x ${widget.selectedColumn1}'),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  ...List.generate(widget.selectedLine1!, (lineIndex) {
                    matrixValues.add([]);
                    final lineNumber = lineIndex + 1;
                    return SizedBox(
                      height: 80,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.selectedColumn1,
                        itemBuilder: (context, columnIndex) {
                          final columnNumber = columnIndex + 1;
                          return Row(
                            children: [
                              const SizedBox(width: 5),
                              Text('L$lineNumber C$columnNumber'),
                              const SizedBox(width: 5),
                              Stack(
                                children: [
                                  Positioned(
                                    top: 1,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.3),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          top: BorderSide(width: 0.4),
                                          left: BorderSide(width: 0.6),
                                          right: BorderSide(width: 0.6),
                                          bottom: BorderSide.none),
                                    ),
                                    height: 30,
                                    width: 60,
                                    child: TextField(
                                      onChanged: (value) {
                                        int parsedValue =
                                            int.tryParse(value) ?? 0;
                                        setState(() {
                                          matrixValues[lineIndex][columnIndex] =
                                              parsedValue;
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 5,
                              )
                            ],
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(253, 173, 65, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      elevation: 0,
                      shadowColor: Colors.black.withOpacity(0.2),
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      final result1 = printMatrix1();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          //passando a matriz formatada pra tela homepage
                          builder: (context) => HomePage(
                            matriz1: result1,
                          ),
                          //se criei esse parametro nomeado na HomePage
                          //até qnd chama-lo na main, terá que instanciar
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(253, 173, 65, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      elevation: 0,
                      shadowColor: Colors.black.withOpacity(0.2),
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: const Text('Ok'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
