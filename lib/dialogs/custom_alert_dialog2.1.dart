import 'package:flutter/material.dart';
import 'package:matrixyy/dialogs/custom_alert_dialog2.2.dart';

class CustomAlertDialog3 extends StatefulWidget {
  CustomAlertDialog3({
    super.key,
    this.selectedLine2,
    this.selectedColumn2,
  });

  int? selectedLine2;
  int? selectedColumn2;

  @override
  State<CustomAlertDialog3> createState() => _CustomAlertDialog3State();
}

class _CustomAlertDialog3State extends State<CustomAlertDialog3> {
  /*essas variaveis nao podem estar dentro do metodo build, 
  A cada reconstrução do widget, essas variáveis são redefinidas para os valores 
  iniciais definidos no build(), o que faz com que a seleção não seja mantida.*/

  //tem que estar na classe _Custom como campos de estado
  //lista de valores disponiveis nos dropdownbuttons
  List<int> line = [1, 2, 3, 4, 5];
  List<int> column = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    void showCustomDialog(int? mySelectedLine2, int? mySelectedColumn2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog4(
            selectedLine2: mySelectedLine2,
            selectedColumn2: mySelectedColumn2,
          );
        },
      );
    }

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
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
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Linhas'),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButton<int>(
                  value: widget.selectedLine2,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      widget.selectedLine2 = newValue;
                    });
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Colunas'),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButton<int>(
                  value: widget.selectedColumn2,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      widget.selectedColumn2 = newValue;
                    });
                  },
                  hint: const Text(
                    'selecione',
                    style: TextStyle(color: Colors.black),
                  ),
                  items: column
                      .map<DropdownMenuItem<int>>(
                        (int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(253, 173, 65, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  elevation: 0,
                  shadowColor: Colors.black.withOpacity(0.2),
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showCustomDialog(
                      widget.selectedLine2, widget.selectedColumn2);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(253, 173, 65, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  elevation: 0,
                  shadowColor: Colors.black.withOpacity(0.2),
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: const Text('Ok'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
