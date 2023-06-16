import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:matrixy/pages/carregamento_calc.dart';
import '../data/database.dart';
import '../matrix/matriz.dart';
import 'package:lottie/lottie.dart';

class User {
  String name;
  String selectedSex;
  String? images;

  User({
    required this.name,
    required this.selectedSex,
    required this.images,
  });
}

class UserAdapter extends TypeAdapter<User> {
  @override
  User read(BinaryReader reader) {
    final fieldsCount = reader.readByte();
    Map<dynamic, dynamic> fields = {};

    for (var i = 0; i < fieldsCount; i++) {
      final key = reader.readByte();
      final dynamic value = reader.read();

      fields[key] = value;
    }

    return User(
      name: fields[0] as String,
      selectedSex: fields[1] as String,
      images: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeByte(3); // Número de campos no objeto User

    writer.writeByte(0); // Índice 0 do campo name
    writer.write(obj.name);

    writer.writeByte(1); // Índice 1 do campo selectedSex
    writer.write(obj.selectedSex);

    writer.writeByte(2); // Índice 0 do campo name
    writer.write(obj.images);
  }

  @override
  int get typeId => 1; // Identificador exclusivo para o tipo User
}

class MatrizOperation {
  Matriz? matriz1;
  Matriz? matriz2;
  String? title;
  Matriz? result;
  Matriz? result2;
  String? icon;

  MatrizOperation({
    this.matriz1,
    this.matriz2,
    this.title,
    this.result,
    this.result2,
    this.icon,
  });
}

class MatrizOperationAdapter extends TypeAdapter<MatrizOperation> {
  @override
  MatrizOperation read(BinaryReader reader) {
    Matriz? matriz1 = reader.read(); // Leia o objeto Matriz
    Matriz? matriz2 = reader.read(); // Leia o objeto Matriz
    String? title = reader.read(); // Leia a string
    Matriz? result = reader.read(); // Leia o objeto Matriz
    Matriz? result2 = reader.read(); // Leia o objeto Matriz
    String? icon = reader.read(); // Leia a string

    return MatrizOperation(
      matriz1: matriz1,
      matriz2: matriz2,
      title: title,
      result: result,
      result2: result2,
      icon: icon,
    );
  }

  @override
  void write(BinaryWriter writer, MatrizOperation obj) {
    writer.write(obj.matriz1); // Escreva o objeto Matriz
    writer.write(obj.matriz2); // Escreva o objeto Matriz
    writer.write(obj.title); // Escreva a string
    writer.write(obj.result); // Escreva o objeto Matriz
    writer.write(obj.result2); // Escreva o objeto Matriz
    writer.write(obj.icon); // Escreva a string
  }

  @override
  int get typeId => 0; // Identificador único para o adaptador
}

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({
    super.key,
    this.user,
  });

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
    if (db.userData.isEmpty) {
      db.createInitialDateUser();
    } else {
      //ja existe informacao
      db.loadDataUser();
    }
    super.initState();
  }

  void deleteTile(int index) {
    setState(() {
      db.matrizHistory.removeAt(index);
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
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.user?.selectedSex == 'M')
                  Text('Bem-Vindo ${widget.user?.name}', style: const TextStyle(fontSize: 16),),
                if (widget.user?.selectedSex == 'F')
                  Text('Bem-Vinda ${widget.user?.name}', style: const TextStyle(fontSize: 16),),
                if (widget.user?.selectedSex == null)
                  Text('Bem-Vindo(a) ${widget.user?.name}', style: const TextStyle(fontSize: 16),),

                // Verifique se os dados da imagem são válidos antes de exibi-la
                if (widget.user?.images != null)
                  Image.asset(
                    widget.user!.images!,
                    width: 45, // Defina a largura desejada para a imagem
                    height: 45, // Defina a altura desejada para a imagem
                  )
                else
                  Image.asset(
                    'lib/assets/imageNull.png',
                    width: 50, // Defina a largura desejada para a imagem
                    height: 50, // Defina a altura desejada para a imagem
                  )
              ],
            ),
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
                            item[item.keys.elementAt(4)]!);
                        break;
                      case 'Inversão':
                        operacao(matriz1, matriz2, item.keys.elementAt(5),
                            item[item.keys.elementAt(5)]!);
                        break;
                      case 'Determinante':
                        operacao(matriz1, matriz2, item.keys.elementAt(6),
                            item[item.keys.elementAt(6)]!);
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
      backgroundColor: const Color.fromRGBO(217, 214, 214, 1.0),
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
                          'Histórico',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemCount: db.matrizHistory.length,
                        itemBuilder: (context, index) {
                          MatrizOperation operation = db.matrizHistory[index];
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
                                                Row(
                                                  children: [
                                                    Text(
                                                      operation.title!,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                operation.matriz1 != null &&
                                                        operation.matriz2 !=
                                                            null &&
                                                        (operation.title! == 'Transposição' ||
                                                            operation.title! ==
                                                                'Inversão' ||
                                                            operation.title! ==
                                                                'Determinante')
                                                    ? Row(
                                                        children: [
                                                          const Text(
                                                            'Resultado X:',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 9,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      210,
                                                                      210,
                                                                      210,
                                                                      1.0),
                                                            ),
                                                          ),
                                                          DataTable(
                                                            columns:
                                                                _buildColumns(
                                                                    operation
                                                                        .result!
                                                                        .columns),
                                                            rows: _buildRows(
                                                                operation
                                                                    .result!
                                                                    .elements),
                                                            columnSpacing: 8,
                                                            dataRowHeight: 16,
                                                            headingRowHeight: 0,
                                                            dataTextStyle:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      210,
                                                                      210,
                                                                      210,
                                                                      1.0),
                                                            ),
                                                          ),
                                                          const Text(
                                                            'Resultado Y:',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 9,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      210,
                                                                      210,
                                                                      210,
                                                                      1.0),
                                                            ),
                                                          ),
                                                          DataTable(
                                                            columns: _buildColumns(
                                                                operation
                                                                    .result2!
                                                                    .columns),
                                                            rows: _buildRows(
                                                                operation
                                                                    .result2!
                                                                    .elements),
                                                            columnSpacing: 8,
                                                            dataRowHeight: 16,
                                                            headingRowHeight: 0,
                                                            dataTextStyle:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      210,
                                                                      210,
                                                                      210,
                                                                      1.0),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : operation.matriz1 ==
                                                                null &&
                                                            operation.matriz2 !=
                                                                null &&
                                                            (operation
                                                                        .title! ==
                                                                    'Transposição' ||
                                                                operation
                                                                        .title! ==
                                                                    'Inversão' ||
                                                                operation
                                                                        .title! ==
                                                                    'Determinante')
                                                        ? Row(
                                                            children: [
                                                              const Text(
                                                                'Resultado:',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 9,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          210,
                                                                          210,
                                                                          210,
                                                                          1.0),
                                                                ),
                                                              ),
                                                              DataTable(
                                                                columns: _buildColumns(
                                                                    operation
                                                                        .result2!
                                                                        .columns),
                                                                rows: _buildRows(
                                                                    operation
                                                                        .result2!
                                                                        .elements),
                                                                columnSpacing:
                                                                    8,
                                                                dataRowHeight:
                                                                    16,
                                                                headingRowHeight:
                                                                    0,
                                                                dataTextStyle:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          210,
                                                                          210,
                                                                          210,
                                                                          1.0),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Row(
                                                            children: [
                                                              const Text(
                                                                'Resultado:',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 9,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          210,
                                                                          210,
                                                                          210,
                                                                          1.0),
                                                                ),
                                                              ),
                                                              DataTable(
                                                                columns: _buildColumns(
                                                                    operation
                                                                        .result!
                                                                        .columns),
                                                                rows: _buildRows(
                                                                    operation
                                                                        .result!
                                                                        .elements),
                                                                columnSpacing:
                                                                    8,
                                                                dataRowHeight:
                                                                    16,
                                                                headingRowHeight:
                                                                    0,
                                                                dataTextStyle:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          210,
                                                                          210,
                                                                          210,
                                                                          1.0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Row(
                                        children: [
                                          Icon(
                                            Icons.verified,
                                            color: Colors.blue,
                                            size: 28,
                                          ),
                                          SizedBox(width: 8),
                                          Text('Histórico:'),
                                        ],
                                      ), //Text(operation.title!),
                                      content: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.calculate,
                                                    color: Colors.orange,
                                                    size: 32,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(operation.title!),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              operation.matriz1 != null &&
                                                      operation.matriz2 != null
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          8.0),
                                                              child: Text(
                                                                'Matriz X:',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 12,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          150,
                                                                          150,
                                                                          150,
                                                                          1.0),
                                                                ),
                                                              ),
                                                            ),
                                                            DataTable(
                                                              columns: _buildColumns(
                                                                  operation
                                                                      .matriz1!
                                                                      .columns),
                                                              rows: _buildRows(
                                                                  operation
                                                                      .matriz1!
                                                                      .elements),
                                                              columnSpacing: 8,
                                                              dataRowHeight: 16,
                                                              headingRowHeight:
                                                                  0,
                                                              dataTextStyle:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        150,
                                                                        150,
                                                                        150,
                                                                        1.0),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          8.0),
                                                              child: Text(
                                                                'Matriz Y:',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 12,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          150,
                                                                          150,
                                                                          150,
                                                                          1.0),
                                                                ),
                                                              ),
                                                            ),
                                                            DataTable(
                                                              columns: _buildColumns(
                                                                  operation
                                                                      .matriz2!
                                                                      .columns),
                                                              rows: _buildRows(
                                                                  operation
                                                                      .matriz2!
                                                                      .elements),
                                                              columnSpacing: 8,
                                                              dataRowHeight: 16,
                                                              headingRowHeight:
                                                                  0,
                                                              dataTextStyle:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        150,
                                                                        150,
                                                                        150,
                                                                        1.0),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  : operation.matriz1 == null &&
                                                          operation.matriz2 !=
                                                              null
                                                      ? Row(
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          8.0),
                                                              child: Text(
                                                                'Matriz:',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 9,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          150,
                                                                          150,
                                                                          150,
                                                                          1.0),
                                                                ),
                                                              ),
                                                            ),
                                                            DataTable(
                                                              columns: _buildColumns(
                                                                  operation
                                                                      .matriz2!
                                                                      .columns),
                                                              rows: _buildRows(
                                                                  operation
                                                                      .matriz2!
                                                                      .elements),
                                                              columnSpacing: 8,
                                                              dataRowHeight: 16,
                                                              headingRowHeight:
                                                                  0,
                                                              dataTextStyle:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        150,
                                                                        150,
                                                                        150,
                                                                        1.0),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Row(
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          8.0),
                                                              child: Text(
                                                                'Matriz:',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 9,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          150,
                                                                          150,
                                                                          150,
                                                                          1.0),
                                                                ),
                                                              ),
                                                            ),
                                                            DataTable(
                                                              columns: _buildColumns(
                                                                  operation
                                                                      .matriz1!
                                                                      .columns),
                                                              rows: _buildRows(
                                                                  operation
                                                                      .matriz1!
                                                                      .elements),
                                                              columnSpacing: 8,
                                                              dataRowHeight: 16,
                                                              headingRowHeight:
                                                                  0,
                                                              dataTextStyle:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        150,
                                                                        150,
                                                                        150,
                                                                        1.0),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              operation.matriz1 != null &&
                                                      operation.matriz2 !=
                                                          null &&
                                                      (operation.title! ==
                                                              'Transposição' ||
                                                          operation.title! ==
                                                              'Inversão' ||
                                                          operation.title! ==
                                                              'Determinante')
                                                  ? Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                right: MediaQuery.of(context).size.width * 0.5,),
                                                          child: const Text(
                                                            'Resultado X:',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 9,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      19,
                                                                      19,
                                                                      19,
                                                                      1.0),
                                                            ),
                                                          ),
                                                        ),
                                                        DataTable(
                                                          columns:
                                                              _buildColumns(
                                                                  operation
                                                                      .result!
                                                                      .columns),
                                                          rows: _buildRows(
                                                              operation.result!
                                                                  .elements),
                                                          columnSpacing: 8,
                                                          dataRowHeight: 16,
                                                          headingRowHeight: 0,
                                                          dataTextStyle:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromRGBO(
                                                                    19,
                                                                    19,
                                                                    19,
                                                                    1.0),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 18.0, right: MediaQuery.of(context).size.width * 0.5,),
                                                          child: const Text(
                                                            'Resultado Y:',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 9,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      19,
                                                                      19,
                                                                      19,
                                                                      1.0),
                                                            ),
                                                          ),
                                                        ),
                                                        DataTable(
                                                          columns:
                                                              _buildColumns(
                                                                  operation
                                                                      .result2!
                                                                      .columns),
                                                          rows: _buildRows(
                                                              operation.result2!
                                                                  .elements),
                                                          columnSpacing: 8,
                                                          dataRowHeight: 16,
                                                          headingRowHeight: 0,
                                                          dataTextStyle:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromRGBO(
                                                                    19,
                                                                    19,
                                                                    19,
                                                                    1.0),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : operation.matriz1 == null &&
                                                          operation.matriz2 !=
                                                              null &&
                                                          (operation.title! ==
                                                                  'Transposição' ||
                                                              operation
                                                                      .title! ==
                                                                  'Inversão' ||
                                                              operation
                                                                      .title! ==
                                                                  'Determinante')
                                                      ? Row(
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          8.0),
                                                              child: Text(
                                                                'Resultado:',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 9,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          19,
                                                                          19,
                                                                          19,
                                                                          1.0),
                                                                ),
                                                              ),
                                                            ),
                                                            DataTable(
                                                              columns: _buildColumns(
                                                                  operation
                                                                      .result!
                                                                      .columns),
                                                              rows: _buildRows(
                                                                  operation
                                                                      .result!
                                                                      .elements),
                                                              columnSpacing: 8,
                                                              dataRowHeight: 16,
                                                              headingRowHeight:
                                                                  0,
                                                              dataTextStyle:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        19,
                                                                        19,
                                                                        19,
                                                                        1.0),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Row(
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          8.0),
                                                              child: Text(
                                                                'Resultado:',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 9,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          19,
                                                                          19,
                                                                          19,
                                                                          1.0),
                                                                ),
                                                              ),
                                                            ),
                                                            DataTable(
                                                              columns: _buildColumns(
                                                                  operation
                                                                      .result!
                                                                      .columns),
                                                              rows: _buildRows(
                                                                  operation
                                                                      .result!
                                                                      .elements),
                                                              columnSpacing: 8,
                                                              dataRowHeight: 16,
                                                              headingRowHeight:
                                                                  0,
                                                              dataTextStyle:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        19,
                                                                        19,
                                                                        19,
                                                                        1.0),
                                                              ),
                                                            ),
                                                          ],
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

  List<MatrizOperation> matrixHistory = [];

  void operacao(Matriz? matriz1, Matriz? matriz2, int chave, String valor) {
    if (matriz1 == null &&
        matriz2 == null &&
        (chave == 4 || chave == 5 || chave == 6)) {
      return alerta('Formato inválido',
          'Deve-se preencher pelo menos uma matriz para realizar a ${valor.toLowerCase()}!');
    } else if ((matriz1 == null || matriz2 == null) &&
        (chave != 4 && chave != 5 && chave != 6)) {
      return alerta('Formato inválido',
          'Deve-se preencher ambas matrizes para realizar a ${valor.toLowerCase()}!');
    } else if (((matriz1 != null && matriz1.rows != matriz1.columns) ||
            (matriz2 != null && matriz2.rows != matriz2.columns)) &&
        (chave == 4 || chave == 5 || chave == 6)) {
      return alerta("Estrutura inválida!",
          "Para cálculo de ${valor.toLowerCase()} a matriz deve ser quadrada");
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
          Future.delayed(const Duration(milliseconds: 3000), () {
            Navigator.of(context).pop();
            titulo = 'Adição';
            // Continue com o cálculo aqui
            matriz = matriz1!.adicao(matriz2!);
            matrizes.add(matriz);
            titulos.add(titulo);

            String icone = 'lib/assets/botao_adicao.png';

            // Após calcular a matriz resultante, adicione a operação ao histórico
            MatrizOperation operation = MatrizOperation(
              matriz1: matriz1,
              matriz2: matriz2,
              title: titulo,
              result: matriz,
              icon: icone,
            );
            //adicionando o objeto na lsita

            setState(() {
              db.matrizHistory.add(operation);
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
          Future.delayed(const Duration(milliseconds: 3000), () {
            Navigator.of(context).pop();
            titulo = 'Subtração';
            // Continue com o cálculo aqui
            matriz = matriz1!.subtracao(matriz2!);
            matrizes.add(matriz);
            titulos.add(titulo);

            String icone = 'lib/assets/botao_subtracao.png';

            // Após calcular a matriz resultante, adicione a operação ao histórico
            MatrizOperation operation = MatrizOperation(
              matriz1: matriz1,
              matriz2: matriz2,
              title: titulo,
              result: matriz,
              icon: icone,
            );
            setState(() {
              db.matrizHistory.add(operation);
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
            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.of(context).pop();
              titulo = 'Multiplicação';
              // Continue com o cálculo aqui
              matriz = matriz1!.multiplicacaoPorElemento(matriz2!);
              matrizes.add(matriz);
              titulos.add(titulo);

              String icone = 'lib/assets/botao_multiplicacao.png';
              // Após calcular a matriz resultante, adicione a operação ao histórico
              MatrizOperation operation = MatrizOperation(
                matriz1: matriz1,
                matriz2: matriz2,
                title: titulo,
                result: matriz,
                icon: icone,
              );

              setState(() {
                db.matrizHistory.add(operation);
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
            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.of(context).pop();
              titulo = 'Multiplicação';
              // Continue com o cálculo aqui
              matriz = matriz1!.multiplicacao(matriz2!);
              matrizes.add(matriz);
              titulos.add(titulo);

              String icone = 'lib/assets/botao_multiplicacao.png';

              MatrizOperation operation = MatrizOperation(
                matriz1: matriz1,
                matriz2: matriz2,
                title: titulo,
                result: matriz,
                icon: icone,
              );

              setState(() {
                db.matrizHistory.add(operation);
              });

              db.updateDataBase();

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
            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.of(context).pop();
              titulo = 'Multiplicação';
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

              String icone = 'lib/assets/botao_multiplicacao.png';

              MatrizOperation operation = MatrizOperation(
                matriz1: matriz1,
                matriz2: matriz2,
                title: titulo,
                result: matriz,
                icon: icone,
              );

              setState(() {
                db.matrizHistory.add(operation);
              });

              db.updateDataBase();

              resultado(matrizes, titulos);
            });

            return CarragamentoCalc();
          },
        );
      } else {
        alerta("Estrutura inválida!",
            "Para cálculo de ${valor.toLowerCase()} as matrizes devem possuir a mesma estrutura ou o número de colunas da matriz X igual ao número de linhas da matriz Y (vice-versa) ou uma das matrizes multiplicadas por um valor único (escalar)");
      }
    } else if (chave == 4) {
      String icone = 'lib/assets/botao_transposicao.png';
      if (matriz1 != null && matriz2 != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.of(context).pop();
              titulo = 'Transposição';
              matriz = matriz1.transposicao();
              matrizes.add(matriz);
              titulos.add(titulo);

              matriz = matriz2.transposicao();
              matrizes.add(matriz);
              titulos.add(titulo);

              MatrizOperation operation = MatrizOperation(
                matriz1: matriz1,
                matriz2: matriz2,
                title: titulo,
                result: matrizes[0],
                result2: matrizes[1],
                icon: icone,
              );

              setState(() {
                db.matrizHistory.add(operation);
              });

              db.updateDataBase();

              resultado(matrizes, titulos);
            });

            return CarragamentoCalc();
          },
        );
      } else if (matriz1 != null && matriz2 == null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.of(context).pop();
              titulo = 'Transposição';
              matriz = matriz1.transposicao();
              matrizes.add(matriz);
              titulos.add(titulo);

              MatrizOperation operation = MatrizOperation(
                matriz1: matriz1,
                title: titulo,
                result: matriz,
                icon: icone,
              );

              setState(() {
                db.matrizHistory.add(operation);
              });

              db.updateDataBase();

              resultado(matrizes, titulos);
            });

            return CarragamentoCalc();
          },
        );
      } else if (matriz1 == null && matriz2 != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.of(context).pop();
              try {
                titulo = 'Transposição';
                matriz = matriz2.transposicao();
                matrizes.add(matriz);
                titulos.add(titulo);

                MatrizOperation operation = MatrizOperation(
                  matriz2: matriz2,
                  title: titulo,
                  result2: matriz,
                  icon: icone,
                );

                setState(() {
                  db.matrizHistory.add(operation);
                });

                db.updateDataBase();

                resultado(matrizes, titulos);
              } catch (exception) {
                alerta('Ops...',
                    exception.toString().replaceAll('Exception: ', ''));
              }
            });

            return CarragamentoCalc();
          },
        );
      }
    } else if (chave == 5) {
      String icone = 'lib/assets/botao_inversao.png';
      if (matriz1 != null && matriz2 != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.of(context).pop();
              try {
                titulo = 'Inversão';
                matriz = matriz1.inversao();
                matrizes.add(matriz);
                titulos.add(titulo);

                matriz = matriz2.inversao();
                matrizes.add(matriz);
                titulos.add(titulo);

                MatrizOperation operation = MatrizOperation(
                  matriz1: matriz1,
                  matriz2: matriz2,
                  title: titulo,
                  result: matrizes[0],
                  result2: matrizes[1],
                  icon: icone,
                );

                setState(() {
                  db.matrizHistory.add(operation);
                });

                db.updateDataBase();

                resultado(matrizes, titulos);
              } catch (exception) {
                alerta('Ops...',
                    exception.toString().replaceAll('Exception: ', ''));
              }
            });

            return CarragamentoCalc();
          },
        );
      } else if (matriz1 != null && matriz2 == null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.of(context).pop();

              try {
                titulo = 'Inversão';
                matriz = matriz1.inversao();
                matrizes.add(matriz);
                titulos.add(titulo);

                MatrizOperation operation = MatrizOperation(
                  matriz1: matriz1,
                  title: titulo,
                  result: matriz,
                  icon: icone,
                );

                setState(() {
                  db.matrizHistory.add(operation);
                });

                db.updateDataBase();

                resultado(matrizes, titulos);
              } catch (exception) {
                alerta('Ops...',
                    exception.toString().replaceAll('Exception: ', ''));
              }
            });

            return CarragamentoCalc();
          },
        );
      } else if (matriz1 == null && matriz2 != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.of(context).pop();
              titulo = 'Inversão';
              matriz = matriz2.inversao();
              matrizes.add(matriz);
              titulos.add(titulo);

              MatrizOperation operation = MatrizOperation(
                matriz2: matriz2,
                title: titulo,
                result2: matriz,
                icon: icone,
              );

              setState(() {
                db.matrizHistory.add(operation);
              });

              db.updateDataBase();

              resultado(matrizes, titulos);
            });

            return CarragamentoCalc();
          },
        );
      }
    } else if (chave == 6) {
      String icone = 'lib/assets/botao_determinante.png';
      if (matriz1 != null && matriz2 != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.of(context).pop();
              titulo = 'Determinante';
              matriz = matriz1.determinante(matriz1.elements);
              matrizes.add(matriz);
              titulos.add(titulo);

              titulo = 'Determinante';
              matriz = matriz2.determinante(matriz2.elements);
              matrizes.add(matriz);
              titulos.add(titulo);

              MatrizOperation operation = MatrizOperation(
                matriz1: matriz1,
                matriz2: matriz2,
                title: titulo,
                result: matrizes[0],
                result2: matrizes[1],
                icon: icone,
              );

              setState(() {
                db.matrizHistory.add(operation);
              });

              db.updateDataBase();

              resultado(matrizes, titulos);
            });

            return CarragamentoCalc();
          },
        );
      } else if (matriz1 != null && matriz2 == null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.of(context).pop();
              String titulo = 'Determinante';
              Matriz matriz;
              matriz = matriz1.determinante(matriz1.elements);
              matrizes.add(matriz);
              titulos.add(titulo);

              MatrizOperation operation = MatrizOperation(
                matriz1: matriz1,
                title: titulo,
                result: matriz,
                icon: icone,
              );

              setState(() {
                db.matrizHistory.add(operation);
              });

              db.updateDataBase();

              resultado(matrizes, titulos);
            });

            return CarragamentoCalc();
          },
        );
      } else if (matriz1 == null && matriz2 != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.of(context).pop();
              titulo = 'Determinante';
              matriz = matriz2.determinante(matriz2.elements);
              matrizes.add(matriz);
              titulos.add(titulo);

              MatrizOperation operation = MatrizOperation(
                matriz2: matriz2,
                title: titulo,
                result2: matriz,
                icon: icone,
              );

              setState(() {
                db.matrizHistory.add(operation);
              });

              db.updateDataBase();

              resultado(matrizes, titulos);
            });

            return CarragamentoCalc();
          },
        );
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
          title: const Row(
            children: [
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
