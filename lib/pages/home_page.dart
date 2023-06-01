import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:matrixy/pages/carregamento_calc.dart';
import '../data/database.dart';
import '../matrix/matriz.dart';
import 'package:lottie/lottie.dart';

class MatrixOperation {
  Matriz? matriz1;
  Matriz? matriz2;
  String? title;
  Matriz? result;
  String? icon;

  MatrixOperation({
    this.matriz1,
    this.matriz2,
    this.title,
    this.result,
    this.icon,
  });
}

class MatrixOperationAdapter extends TypeAdapter<MatrixOperation> {
  @override
  MatrixOperation read(BinaryReader reader) {
    Matriz? matriz1 = reader.read(); // Leia o objeto Matriz
    Matriz? matriz2 = reader.read(); // Leia o objeto Matriz
    String? title = reader.read(); // Leia a string
    Matriz? result = reader.read(); // Leia o objeto Matriz
    String? icon = reader.read(); // Leia a string

    return MatrixOperation(
      matriz1: matriz1,
      matriz2: matriz2,
      title: title,
      result: result,
      icon: icon,
    );
  }

  @override
  void write(BinaryWriter writer, MatrixOperation obj) {
    writer.write(obj.matriz1); // Escreva o objeto Matriz
    writer.write(obj.matriz2); // Escreva o objeto Matriz
    writer.write(obj.title); // Escreva a string
    writer.write(obj.result); // Escreva o objeto Matriz
    writer.write(obj.icon); // Escreva a string
  }

  @override
  int get typeId => 0; // Identificador único para o adaptador
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');

  HistoricDataBase db = HistoricDataBase();

  @override //quando o app rodar pela primeira vez, checaremos:
  void initState() {
    //se abriu pela primeira vez, crie o padrao
    if (_myBox.get('HISTORICLIST') == null) {
      db.createInitialDate();
    } else {
      //ja existe informacao
      db.loadData();
    }
    super.initState();
  }

  void deleteTile(int index) {
    setState(() {
      db.matrixHistory.removeAt(index);
    });
    db.updateDataBase();
  }

  Matriz? matriz1;
  Matriz? matriz2;

  Map<int, String> item = {
    0: 'Selecione',
    1: 'Adição',
    2: 'Subtração',
    3: 'Multiplicação',
    4: 'Transposição',
    5: 'Inversão',
    6: 'Determinante'
  };

  String? selectedOption;

  List<int> row = [1, 2, 3, 4, 5];
  List<int> column = [1, 2, 3, 4, 5];

  ValueNotifier<int?> selectedRows = ValueNotifier<int?>(1);
  ValueNotifier<int?> selectedColumns = ValueNotifier<int?>(1);

  @override
  Widget build(BuildContext context) {
    //CADA TILE DO HISTORICO

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
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Bem-Vindo mulekot'),
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
                'Operação',
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: DropdownButton<String>(
                    value: selectedOption ?? item[item.keys.first],
                    isExpanded: true,
                    elevation: 16,
                    underline: Container(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedOption = newValue;
                      });
                    },
                    items: item.entries
                        .map<DropdownMenuItem<String>>(
                          (entry) => DropdownMenuItem<String>(
                            value: entry.value,
                            child: Text(
                              entry.value,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                  ),
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
                    switch (selectedOption) {
                      case 'Adição':
                        operacao(matriz1, matriz2, item.keys.elementAt(1),
                            item[item.keys.elementAt(1)]!);
                        break;
                      case 'Subtração':
                        operacao(matriz1, matriz2, item.keys.elementAt(2),
                            item[item.keys.elementAt(2)]!);
                        break;
                      case 'Multiplicação':
                        operacao(matriz1, matriz2, item.keys.elementAt(3),
                            item[item.keys.elementAt(3)]!);
                        break;
                      case 'Transposição':
                        operacao(matriz1, matriz2, item.keys.elementAt(4),
                            item[item.keys.elementAt(5)]!);
                        break;
                      case 'Inversão':
                        operacao(matriz1, matriz2, item.keys.elementAt(5),
                            item[item.keys.elementAt(6)]!);
                        break;
                      case 'Determinante':
                        operacao(matriz1, matriz2, item.keys.elementAt(6),
                            item[item.keys.elementAt(4)]!);
                        break;
                      default:
                        alerta('Opção inválida',
                            'Deve-se selecionar uma operação!');
                    }
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

    //DIALOGO DOS ELEMENTOS
    void openElementsDialog(int containerIndex, int rows, int columns) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          List<List<TextEditingController>> controllers = List.generate(
            rows,
            (_) => List.generate(columns, (_) => TextEditingController()),
          );

          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Matriz ${containerIndex + 1}'),
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
            content: SingleChildScrollView(
              child: Column(
                children: [
                  const Text('Entre com os elementos da matriz:'),
                  const SizedBox(height: 16),
                  Table(
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: List.generate(rows, (row) {
                      return TableRow(
                        children: List.generate(columns, (column) {
                          return SizedBox(
                            width: 50,
                            height: 30,
                            child: TextField(
                              controller: controllers[row][column],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(3),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
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
                child: const Text('Cancelar'),
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

                  Matriz matriz = Matriz(rows, columns, elements);

                  setState(() {
                    if (containerIndex == 0) {
                      matriz1 = matriz;
                    } else {
                      matriz2 = matriz;
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
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Matriz ${containerIndex + 1}'),
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                            value: value ?? row[0],
                            onChanged: (newValue) {
                              selectedRows.value = newValue;
                            },
                            items: row
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
                    const Text('Colunas:'),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ValueListenableBuilder<int?>(
                        valueListenable: selectedColumns,
                        builder: (context, value, child) {
                          return DropdownButton<int>(
                            isExpanded: true,
                            value: value ?? column[0],
                            onChanged: (newValue) {
                              selectedColumns.value = newValue;
                            },
                            hint: const Text(
                              'Selecione',
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
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openElementsDialog(
                    containerIndex,
                    selectedRows.value!,
                    selectedColumns.value!,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    //CONTAINER COM AS MATRIZES
    Widget buildMatrixContainer(
        int containerIndex, Matriz? matriz, double left, double right) {
      return InkWell(
        onTap: () {
          openMatrixDialog(containerIndex);
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.24,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(155, 115, 61, 1),
                Color.fromRGBO(253, 173, 65, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomRight: const Radius.circular(15),
              bottomLeft: const Radius.circular(15),
              topLeft: Radius.circular(left),
              topRight: Radius.circular(right),
            ),
          ),
          child: Center(
            child: matriz != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 27.0),
                                child: Text(
                                  'Matriz ${(containerIndex + 1) == 1 ? 'X' : 'Y'}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (containerIndex == 0) {
                                    matriz1 = null;
                                  } else {
                                    matriz2 = null;
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  width: 19,
                                  height: 19,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          235, 64, 52, 0.7),
                                      width: 2.0,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      DataTable(
                        columns: _buildColumns(matriz.columns),
                        rows: _buildRows(matriz.elements),
                        columnSpacing: 3,
                        dataRowHeight: 24,
                        headingRowHeight: 0,
                      ),
                    ],
                  )
                : Text(
                    'Clique para adicionar a\nMatriz ${(containerIndex + 1) == 1 ? 'X' : 'Y'}',
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
                        buildMatrixContainer(0, matriz1, 30, 15),
                        buildMatrixContainer(1, matriz2, 15, 30),
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
                  color: Color.fromRGBO(23, 23, 23, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
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
                          child: ListView.builder(
                        itemCount: db.matrixHistory.length,
                        itemBuilder: (context, index) {
                          MatrixOperation operation = db.matrixHistory[index];
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) => deleteTile(index),
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red,
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              child: Column(
                                children: [
                                  Container(
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: Image.asset(
                                            operation.icon!,
                                            width: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  operation.title!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Matriz X: ${operation.matriz1}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 10,
                                                    color: Color.fromRGBO(
                                                        100, 92, 92, 1),
                                                  ),
                                                ),
                                                Text(
                                                  'Matriz Y: ${operation.matriz2}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 10,
                                                    color: Color.fromRGBO(
                                                        100, 92, 92, 1),
                                                  ),
                                                ),
                                                Text(
                                                  'Resultado: ${operation.result}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 10,
                                                    color: Color.fromRGBO(
                                                        100, 92, 92, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(operation.title!),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              /*
                                              separar fazer com text + DataTable
                                               */
                                              Text(
                                                'Matriz X:\n${operation.matriz1}',
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                              Text(
                                                'Matriz Y:\n${operation.matriz2}',
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                              Text(
                                                'Resultado:\n${operation.result}',
                                                style: const TextStyle(
                                                    fontSize: 28),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          child: const Text('Fechar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ))
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

  List<DataColumn> _buildColumns(int? columnCount) {
    return List.generate(
      columnCount!,
      (index) => const DataColumn(
        label: Text(''),
      ),
    );
  }

  List<DataRow> _buildRows(List<List<int>> elements) {
    return elements.map((row) {
      return DataRow(
        cells: row.map((element) {
          return DataCell(
            Text(
              element.toString(),
              style: const TextStyle(fontFamily: 'RobotoMono'),
            ),
          );
        }).toList(),
      );
    }).toList();
  }

  List<MatrixOperation> matrixHistory = [];

  void operacao(Matriz? matriz1, Matriz? matriz2, int chave, String valor) {
    if (matriz1 == null && matriz2 == null && (chave == 5 || chave == 6)) {
      return alerta('Formato inválido',
          'Deve-se preencher pelo menos uma matriz para realizar a ${valor.toLowerCase()}!');
    } else if ((matriz1 == null || matriz2 == null) &&
        (chave != 4 && chave != 5 && chave != 6)) {
      return alerta('Formato inválido',
          'Deve-se preencher ambas matrizes para realizar a ${valor.toLowerCase()}!');
    }

    Matriz matriz;
    String titulo;
    List<Matriz> matrizes = [];
    List<String> titulos = [];

    //CALCULO PARA QUANDO SELECIONAR ADIÇÃO
    if (chave == 1 && temMesmaEstrutura(matriz1, matriz2)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            Navigator.of(context).pop();
            titulo = 'Adição';
            // Continue com o cálculo aqui
            matriz = matriz1!.adicao(matriz2!);
            matrizes.add(matriz);
            titulos.add(titulo);

            String icone = 'lib/assets/cruz.png';

            // Após calcular a matriz resultante, adicione a operação ao histórico
            MatrixOperation operation = MatrixOperation(
              matriz1: matriz1,
              matriz2: matriz2,
              title: titulo,
              result: matriz,
              icon: icone,
            );
            //adicionando o objeto na lsita

            setState(() {
              db.matrixHistory.add(operation);
            });

            db.updateDataBase();

            resultado(matrizes, titulos);
          });

          return CarragamentoCalc();
        },
      );
    } else if (chave == 2 && temMesmaEstrutura(matriz1, matriz2)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            Navigator.of(context).pop();
            titulo = 'Subtração';
            // Continue com o cálculo aqui
            matriz = matriz1!.subtracao(matriz2!);
            matrizes.add(matriz);
            titulos.add(titulo);

            String icone = 'lib/assets/menos.png';

            // Após calcular a matriz resultante, adicione a operação ao histórico
            MatrixOperation operation = MatrixOperation(
              matriz1: matriz1,
              matriz2: matriz2,
              title: titulo,
              result: matriz,
              icon: icone,
            );
            setState(() {
              matrixHistory.add(operation);
            });

            db.updateDataBase();

            resultado(matrizes, titulos);
          });

          return CarragamentoCalc();
        },
      );
    } else if (chave == 3) {
      if (temMesmaEstrutura(matriz1, matriz2)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 1000), () {
              Navigator.of(context).pop();
              titulo = 'Matriz X*Y';
              // Continue com o cálculo aqui
              matriz = matriz1!.multiplicacaoPorElemento(matriz2!);
              matrizes.add(matriz);
              titulos.add(titulo);

              String icone = 'lib/assets/multiplique-o-sinal-matematico.png';
              // Após calcular a matriz resultante, adicione a operação ao histórico
              MatrixOperation operation = MatrixOperation(
                matriz1: matriz1,
                matriz2: matriz2,
                title: titulo,
                result: matriz,
                icon: icone,
              );
              setState(() {
                matrixHistory.add(operation);
              });

              db.updateDataBase();

              resultado(matrizes, titulos);
            });

            return CarragamentoCalc();
          },
        );
      } else if (matriz1?.columns == matriz2?.rows) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 5000), () {
              Navigator.of(context).pop();
              titulo = 'Matriz X*Y';
              // Continue com o cálculo aqui
              matriz = matriz1!.multiplicacao(matriz2!);
              matrizes.add(matriz);
              titulos.add(titulo);
              resultado(matrizes, titulos);
            });

            return CarragamentoCalc();
          },
        );
      } else if ((matriz1?.columns == 1 && matriz1?.rows == 1) ||
          (matriz2?.columns == 1 && matriz2?.rows == 1)) {
        int escalar;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 5000), () {
              Navigator.of(context).pop();
              titulo = 'Matriz X*Y';
              // Continue com o cálculo aqui
              if (matriz1?.columns == 1 && matriz1?.rows == 1) {
                escalar = matriz1!.elements[0][0];
                matriz = matriz2!.multiplicacaoPorEscalar(escalar);
              } else {
                escalar = matriz2!.elements[0][0];
                matriz = matriz1!.multiplicacaoPorEscalar(escalar);
              }

              matrizes.add(matriz);
              titulos.add(titulo);
              resultado(matrizes, titulos);
            });

            return CarragamentoCalc();
          },
        );
      } else {
        alerta("Estrutura inválida!",
            "Para cálculo de ${valor.toLowerCase()} as matrizes devem possuir a mesma estrutura ou o número de colunas da matriz X igual ao número de linhas da matriz Y (vice-versa) ou uma das matrizes multiplicadas por um valor único (escalar)");
      }
    } else if (chave == 6) {
      if (matriz1 != null &&
          matriz2 != null &&
          matriz1.rows == matriz1.columns &&
          matriz2.rows == matriz2.columns) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 5000), () {
              Navigator.of(context).pop();
              titulo = '|Matriz X|';
              matriz = matriz1.determinante(matriz1.elements);
              matrizes.add(matriz);
              titulos.add(titulo);

              titulo = '|Matriz Y|';
              matriz = matriz2.determinante(matriz2.elements);
              matrizes.add(matriz);
              titulos.add(titulo);
              //TO DO: Chamar o calculo para as duas matrizes
              //matriz = matriz2!.determinante(matriz2!.elements);
              resultado(matrizes, titulos);
            });

            return CarragamentoCalc();
          },
        );
      } else if (matriz1 != null &&
          matriz2 == null &&
          matriz1.rows == matriz1.columns) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 5000), () {
              Navigator.of(context).pop();
              String titulo = '|Matriz X|';
              Matriz matriz;
              matriz = matriz1.determinante(matriz1.elements);
              matrizes.add(matriz);
              titulos.add(titulo);
              resultado(matrizes, titulos);
            });

            return CarragamentoCalc();
          },
        );
      } else if (matriz1 == null &&
          matriz2 != null &&
          matriz2.rows == matriz2.columns) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 5000), () {
              Navigator.of(context).pop();
              titulo = '|Matriz Y|';
              matriz = matriz2.determinante(matriz2.elements);
              matrizes.add(matriz);
              titulos.add(titulo);
              resultado(matrizes, titulos);
            });

            return CarragamentoCalc();
          },
        );
      } else {
        alerta("Estrutura inválida!",
            "Para cálculo de determinante a matriz deve ser quadrada");
      }
    } else {
      alerta("Estrutura inválida!",
          "Para cálculo de ${valor.toLowerCase()} as matrizes devem possuir a mesma estrutura");
    }
  }

  void alerta(String titulo, String mensagem) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Lottie.network(
                'https://assets7.lottiefiles.com/packages/lf20_9s5vox93.json',
                //https://assets1.lottiefiles.com/packages/lf20_0P6TnSO6YK.json
                width: 70,
                height: 70,
                repeat: true,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Text(titulo),
            ],
          ),
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool temMesmaEstrutura(Matriz? matriz1, Matriz? matriz2) {
    if (matriz1?.rows != matriz2?.rows) {
      return false;
    } else if (matriz1?.columns != matriz2?.columns) {
      return false;
    }
    return true;
  }

  bool colunaMatriz1IgualLinhaMatriz2(Matriz matriz1, Matriz matriz2) {
    if (matriz1.columns == matriz2.rows) return true;
    return false;
  }

  void resultado(List<Matriz?> matrizes, List<String> titulos) {
    assert(matrizes.length <= 2 && titulos.length <= 2);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(
                Icons.verified,
                color: Colors.green,
                size: 36,
              ),
              SizedBox(width: 8),
              Text('Resultado:'),
            ],
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < matrizes.length; i++)
                Column(
                  children: [
                    Text(
                      titulos[i],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DataTable(
                      columns: _buildColumns(matrizes[i]!.columns),
                      rows: _buildRows(matrizes[i]!.elements),
                      columnSpacing: 3,
                      dataRowHeight: 24,
                      headingRowHeight: 0,
                    ),
                    if (i < matrizes.length - 1) const Divider(),
                  ],
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
