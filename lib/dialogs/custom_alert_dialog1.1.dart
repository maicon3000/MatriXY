import 'package:flutter/material.dart';
import 'custom_alert_dialog1.2.dart';

class CustomAlertDialog extends StatefulWidget {
  CustomAlertDialog({
    super.key,
    this.selectedLine1,
    this.selectedColumn1,
  });

  int? selectedLine1;
  int? selectedColumn1;

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  /*essas variaveis nao podem estar dentro do metodo build, 
  A cada reconstrução do widget, essas variáveis são redefinidas para os valores 
  iniciais definidos no build(), o que faz com que a seleção não seja mantida.*/

  //tem que estar na classe _Custom como campos de estado
  //lista de valores disponiveis nos dropdownbuttons
  List<int> line = [1, 2, 3, 4, 5];
  List<int> column = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    void showCustomDialog(int? mySelectedLine1, int? mySelectedColumn1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog2(
            selectedLine1: mySelectedLine1,
            selectedColumn1: mySelectedColumn1,
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
                  value: widget.selectedLine1,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      widget.selectedLine1 = newValue;
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
                  value: widget.selectedColumn1,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      widget.selectedColumn1 = newValue;
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
                      widget.selectedLine1, widget.selectedColumn1);
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
