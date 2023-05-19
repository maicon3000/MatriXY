/*import 'package:flutter/material.dart';

import '../pages/home_page.dart';

class CustomAlertDialog2 extends StatefulWidget {
/*sizedBox necessario no primeiro listviubuilder do primeiro alert pq 
precisa saber a dimensao antes de abrir widget modal(alertDialog)
listview.builder é aninhamento, entao faz todos os dialogos
ao mesmo tempo.
nesse modelo, funciona a quantidade de linhas por dialogo
e a quantidade de dialogos atraves das colunas
ideia - gambiarra, usar stack pra fazer todas uma em cima da outra e ir
preenchendo aos poucos até sumir todas
ideia - IndexedStack pra alternar entre os dialogos*/
  const CustomAlertDialog2(
      {super.key, required this.selectedLine, required this.selectedColumn});
  final int? selectedLine;
  final int? selectedColumn;
  @override
  State<CustomAlertDialog2> createState() => _CustomAlertDialog2State();
}

class _CustomAlertDialog2State extends State<CustomAlertDialog2> {
  /*essas variaveis nao podem estar dentro do metodo build, 
  A cada reconstrução do widget, essas variáveis são redefinidas para os valores 
  iniciais definidos no build(), o que faz com que a seleção não seja mantida.*/

//maneira errada de inicializar uma matriz para inserir os numeros dinamicamente.
//List<List<int?>> matrixValues = [];
/*
A declaração de uma matriz vazia (List<List<int>> matriz = [];) cria uma matriz 
vazia sem nenhum elemento. Nesse caso, quando você tenta acessar um elemento 
específico usando a sintaxe matriz[i][j], ocorrerá um erro de índice fora do 
intervalo, pois não há elementos na matriz.

Por isso, é necessário gerar uma matriz nula com antecedência para evitar esse erro. 
A função List.generate() é utilizada para criar a matriz nula, em que todos os 
elementos são inicializados com o valor null. Dessa forma, quando você atribui 
um valor a um elemento específico da matriz (matriz[i][j] = parsedValue), 
o elemento correspondente é criado e armazena o valor corretamente.

 */

  @override
  void initState() {
    super.initState();
    initializeMatrix();
  }

  List<List<int?>> matrixValues = [];

  void initializeMatrix() {
    matrixValues = List.generate(
      widget.selectedLine!,
      (_) => List.generate(widget.selectedColumn!, (_) => null),
    );
  }

//pegar cada elemento da matriz e inserir. quebrar linha quando acabar o numero de colunas.
  String printMatrix() {
    final buffer = StringBuffer();
    for (int i = 0; i < widget.selectedLine!; i++) {
      for (int j = 0; j < widget.selectedColumn!; j++) {
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
                      'Valores da matriz: ${widget.selectedLine} x ${widget.selectedColumn}'),
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
                  ...List.generate(widget.selectedLine!, (lineIndex) {
                    matrixValues.add([]);
                    final lineNumber = lineIndex + 1;
                    return SizedBox(
                      height: 80,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.selectedColumn,
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
                      final result = printMatrix();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          //passando a matriz formatada pra tela homepage
                          builder: (context) => HomePage(matriz: result),
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


isso retornava todas os texts iguais.
para fzr dinamico, tipo com um for,usar incremento atraves do contador do proprio 
builder(index)
ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.selectedColumn,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Text('C${widget.selectedColumn}'),
                const SizedBox(
                  width: 2.0,
                )
              ],
            );
          },

          correto: 
          itemBuilder: (context, index) {
            final columnNumber = index + 1;
            return Row(
              children: [
                Text('C$columnNumber'),
                const SizedBox(
                  width: 2.0,
                )
              ],
            );

Criar os itens sob demanda usando o ListView.builder pode ser uma boa 
prática quando você tem uma lista dinâmica e potencialmente grande de itens. 
Nessa situação, o ListView.builder permite que você crie apenas os 
itens visíveis na tela, economizando recursos de memória.

No entanto, quando você tem uma lista estática e pequena de itens, 
não há uma grande preocupação com o uso de recursos de memória. 
Usar o ListView com List.generate simplifica o código e 
é perfeitamente aceitável.

AlertDialog(
      content: Container(
        color: Colors.deepPurple,
        height: 300,
        width: 300,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.selectedLine,
          itemBuilder: (context, lineIndex) {
            final lineNumber = lineIndex + 1;
            return SizedBox(
              height: 50, // Defina a altura desejada para cada linha
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.selectedColumn,
                itemBuilder: (context, columnIndex) {
                  final columnNumber = columnIndex + 1;
                  return Row(
                    children: [
                      Text('L$lineNumber C$columnNumber'),
                      Container(
                        color: Colors.purple,
                        width: 10.0,
                        height: 10,
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
    esse ultimo, está totalmente correto.
    foi usado listView.builder vertical para empilhar as linhas, e dentro, um listView.uilder horizontal para as colunas.
    como resultado, ficou uma matriz, 2d
    lembrar que amos os listView.builder precisam estar envolvidos em um container com tamanho fixo referente ao seu scrollDirection

porem, estava crashando na rolagem, pois havia conflito com a rolagem
entao troquei um dos listView.builder por List.generate
 


AlertDialog(
                            content: SizedBox(
                              width: 300,
                              height: 300,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.selectedLine,
                                itemBuilder: (context, lineIndex) {
                                  final lineNumber = lineIndex + 1;
                                  return Row(
                                    children: List.generate(
                                      widget.selectedColumn!,
                                      (columnIndex) {
                                        final columnNumber = columnIndex + 1;
                                        final value =
                                            matriz[lineIndex][columnIndex];
                                        return Text(
                                            'L$lineNumber C$columnNumber: $value');
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
 

 melhor opcao - Listview -> list.generate -> sizedbox -> listview.builder
  Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  ...List.generate(widget.selectedLine!, (lineIndex) {
                    matriz.add([]);
                    final lineNumber = lineIndex + 1;
                    return SizedBox(
                      height: 80,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.selectedColumn,
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
                                        final parsedValue =
                                            int.tryParse(value) ?? 0;
                                        matriz[lineIndex].add(parsedValue);
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
*/
