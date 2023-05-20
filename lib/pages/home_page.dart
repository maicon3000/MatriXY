import 'package:flutter/material.dart';

import '../matrix/matrix.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //INSTANCIANDO DUAS MATRIZES
  Matrix? matrix1;
  Matrix? matrix2;

  //DropdowButton DE CALCULAR
  List<String> items = ['adicao', 'subracao', 'multiplicacao', 'divisao'];
  String? selectedOption;

  //DropdowButton DO PRIMEIRO DIÁLOGO
  List<int> line = [1, 2, 3, 4, 5];
  List<int> column = [1, 2, 3, 4, 5];

  //PARA MUDAR INSTANTANEAMENTE O VALOR SELECIONADO NO DropdownMenuItem
  ValueNotifier<int?> selectedRows = ValueNotifier<int?>(null);
  ValueNotifier<int?> selectedColumns = ValueNotifier<int?>(null);

  @override
  Widget build(BuildContext context) {
    //CADA TILE DO HISTORICO

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
    //APPBAR

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
    //CONTAINER DE ESCOLHER OPERAÇÃO

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
                  onPressed: () {},
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

    //DIALOGO DOS ELEMENTOS
    void openElementsDialog(int containerIndex, int rows, int columns) {
      showDialog(
        context: context,
        builder: (context) {
          List<List<TextEditingController>> controllers = List.generate(
            rows,
            (_) => List.generate(columns, (_) => TextEditingController()),
          );

          return AlertDialog(
            title: Text('Matrix ${containerIndex + 1}'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  const Text('Enter matrix elements:'),
                  const SizedBox(height: 16),
                  Table(
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: List.generate(rows, (row) {
                      return TableRow(
                        children: List.generate(columns, (column) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: TextField(
                              controller: controllers[row][column],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  List<List<int>> elements = List.generate(
                    rows,
                    (row) => List.generate(
                      columns,
                      (column) =>
                          int.tryParse(
                            controllers[row][column].text.trim(),
                          ) ??
                          0,
                    ),
                  );

                  Matrix matrix = Matrix(rows, columns, elements);

                  setState(() {
                    if (containerIndex == 0) {
                      matrix1 = matrix;
                    } else {
                      matrix2 = matrix;
                    }
                  });

                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    //DIALOGO DO TAMANHO DA MATRIZ
    void openMatrixDialog(int containerIndex) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Matrix ${containerIndex + 1}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text('Entre com o tamanho da matriz'),
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Rows:'),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ValueListenableBuilder<int?>(
                        valueListenable: selectedRows,
                        builder: (context, value, child) {
                          return DropdownButton<int>(
                            isExpanded: true,
                            value: value,
                            onChanged: (newValue) {
                              selectedRows.value = newValue;
                            },
                            hint: const Text(
                              'selecione',
                              style: TextStyle(color: Colors.black),
                            ),
                            items: line
                                .map<DropdownMenuItem<int>>(
                                  (value) => DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Columns:'),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ValueListenableBuilder<int?>(
                        valueListenable: selectedColumns,
                        builder: (context, value, child) {
                          return DropdownButton<int>(
                            isExpanded: true,
                            value: value,
                            onChanged: (newValue) {
                              selectedColumns.value = newValue;
                            },
                            hint: const Text(
                              'selecione',
                              style: TextStyle(color: Colors.black),
                            ),
                            items: column
                                .map<DropdownMenuItem<int>>(
                                  (value) => DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openElementsDialog(containerIndex, selectedRows.value!,
                      selectedColumns.value!);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    //CONTAINER COM AS MATRIZES
    Widget buildMatrixContainer(int containerIndex, Matrix? matrix) {
      return InkWell(
        onTap: () {
          openMatrixDialog(containerIndex);
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.24,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(155, 115, 61, 1),
                Color.fromRGBO(253, 173, 65, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              topLeft: Radius.circular(30),
              topRight: Radius.circular(15),
            ),
          ),
          child: Center(
            child: matrix != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Matrix ${containerIndex + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('${matrix.rows}x${matrix.columns}'),
                      const SizedBox(height: 8),
                      const Text('Elements:'),
                      const SizedBox(height: 8),
                      for (var row in matrix.elements) Text(row.join('  ')),
                    ],
                  )
                : Text(
                    'Matrix ${containerIndex + 1}\nClick to add matrix',
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
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
                        buildMatrixContainer(0, matrix1),
                        buildMatrixContainer(1, matrix2),
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
