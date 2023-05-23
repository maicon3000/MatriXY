class Matriz {
  final int rows;
  final int columns;
  final List<List<int>> elements;

  Matriz(this.rows, this.columns, this.elements);

  Matriz somar(Matriz outraMatriz) {
    if (rows != outraMatriz.rows || columns != outraMatriz.columns) {
      throw Exception('As matrizes devem ter o mesmo número de linhas e colunas para serem somadas.');
    }

    List<List<int>> resultado = [];

    for (int i = 0; i < rows; i++) {
      List<int> linha = [];

      for (int j = 0; j < columns; j++) {
        linha.add(elements[i][j] + outraMatriz.elements[i][j]);
      }

      resultado.add(linha);
    }

    return Matriz(rows, columns, resultado);
  }
}
