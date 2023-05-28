class Matriz {
  final int rows;
  final int columns;
  final List<List<int>> elements;

  Matriz(this.rows, this.columns, this.elements);

  Matriz adicao(Matriz outraMatriz) {
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

  Matriz subtracao(Matriz outraMatriz) {
    if (rows != outraMatriz.rows || columns != outraMatriz.columns) {
      throw Exception('As matrizes devem ter o mesmo número de linhas e colunas para serem subtraídas.');
    }

    List<List<int>> resultado = [];

    for (int i = 0; i < rows; i++) {
      List<int> linha = [];

      for (int j = 0; j < columns; j++) {
        linha.add(elements[i][j] - outraMatriz.elements[i][j]);
      }

      resultado.add(linha);
    }

    return Matriz(rows, columns, resultado);
  }


  Matriz multiplicacao(Matriz outraMatriz) {
    if (columns != outraMatriz.rows) {
      throw Exception('O número de colunas da primeira matriz deve ser igual ao número de linhas da segunda matriz para multiplicação de matrizes.');
    }

    List<List<int>> resultado = [];

    for (int i = 0; i < rows; i++) {
      List<int> linha = [];

      for (int j = 0; j < outraMatriz.columns; j++) {
        int soma = 0;

        for (int k = 0; k < columns; k++) {
          soma += elements[i][k] * outraMatriz.elements[k][j];
        }

        linha.add(soma);
      }

      resultado.add(linha);
    }

    return Matriz(rows, outraMatriz.columns, resultado);
  }

  Matriz multiplicacaoPorElemento(Matriz outraMatriz) {
    if (rows != outraMatriz.rows || columns != outraMatriz.columns) {
      throw Exception('As matrizes devem ter o mesmo número de linhas e colunas para multiplicação por elemento.');
    }

    List<List<int>> resultado = [];

    for (int i = 0; i < rows; i++) {
      List<int> linha = [];

      for (int j = 0; j < columns; j++) {
        linha.add(elements[i][j] * outraMatriz.elements[i][j]);
      }

      resultado.add(linha);
    }

    return Matriz(rows, columns, resultado);
  }

  Matriz multiplicacaoPorEscalar(int escalar) {
    List<List<int>> resultado = [];

    for (int i = 0; i < rows; i++) {
      List<int> linha = [];

      for (int j = 0; j < columns; j++) {
        linha.add(elements[i][j] * escalar);
      }

      resultado.add(linha);
    }

    return Matriz(rows, columns, resultado);
  }

  Matriz Inversao() {
    if (rows != columns) {
      throw Exception('A matriz deve ser quadrada para ter uma matriz inversa.');
    }

    int n = rows;

    // Criar uma matriz identidade do mesmo tamanho da matriz original.
    List<List<int>> identidade = List.generate(n, (i) => List<int>.filled(n, 0));
    for (int i = 0; i < n; i++) {
      identidade[i][i] = 1;
    }

    // Criar uma cópia da matriz original para manipulação.
    List<List<int>> matrizOriginal = List.generate(n, (i) => List<int>.from(elements[i]));

    // Realizar o processo de eliminação de Gauss-Jordan.
    for (int i = 0; i < n; i++) {
      // Dividir a linha atual pela diagonal principal para obter um pivô de 1.
      int pivot = matrizOriginal[i][i];
      for (int j = 0; j < n; j++) {
        matrizOriginal[i][j] ~/= pivot;
        identidade[i][j] ~/= pivot;
      }

      // Subtrair múltiplos da linha atual das outras linhas para zerar os elementos abaixo e acima do pivô.
      for (int k = 0; k < n; k++) {
        if (k != i) {
          int factor = matrizOriginal[k][i];
          for (int j = 0; j < n; j++) {
            matrizOriginal[k][j] -= factor * matrizOriginal[i][j];
            identidade[k][j] -= factor * identidade[i][j];
          }
        }
      }
    }

    // Retornar a matriz inversa.
    return Matriz(n, n, identidade);
  }

  /*double determinantee() {
    if (rows != columns) {
      throw Exception('A matriz deve ser quadrada para calcular o determinantee.');
    }

    int n = rows;
    List<List<int>> matriz = List.generate(n, (i) => List<int>.from(elements[i]));

    for (int i = 0; i < n - 1; i++) {
      for (int j = i + 1; j < n; j++) {
        double ratio = matriz[j][i] / matriz[i][i];
        for (int k = i; k < n; k++) {
          matriz[j][k] -= (ratio * matriz[i][k]).round();
        }
      }
    }

    double determinantee = 1;
    for (int i = 0; i < n; i++) {
      determinantee *= matriz[i][i];
    }

    return determinantee;
  }*/

  Matriz transposicao() {
    if (rows != columns) {
      throw Exception('A matriz deve ser quadrada para ser transposta.');
    }

    List<List<int>> resultado = [];

    for (int j = 0; j < columns; j++) {
      List<int> linha = [];

      for (int i = 0; i < rows; i++) {
        linha.add(elements[i][j]);
      }

      resultado.add(linha);
    }

    return Matriz(columns, rows, resultado);
  }

  Matriz determinante(List<List<int>> matrix) {
    if (matrix.length != matrix[0].length) {
      throw Exception('A matriz não é quadrada. O determinante não pode ser calculado.');
    }

    int size = matrix.length;
    int det = 0;
    List<List<int>> coluna = [];
    List<int> linha = [];

    // Caso base para matriz 1x1
    if (size == 1) {
      det = matrix[0][0];
      linha.add(det);
      coluna.add(linha);

      return Matriz(1, 1, coluna);
    }

    // Caso base para matriz 2x2
    if (size == 2) {
      det = (matrix[0][0] * matrix[1][1]) - (matrix[0][1] * matrix[1][0]);
      linha.add(det);
      coluna.add(linha);

      return Matriz(1, 1, coluna);
    }

    // Calcular o determinante por cofatores
    for (int col = 0; col < size; col++) {
      int cofactor = (col % 2 == 0) ? 1 : -1;
      Matriz subDeterminante = determinante(getSubMatrix(matrix, 0, col));
      det += cofactor * matrix[0][col] * subDeterminante.elements[0][0];
    }

    linha.add(det);
    coluna.add(linha);

    return Matriz(1, 1, coluna);
  }

// Função auxiliar para obter a submatriz excluindo a linha e coluna especificadas
  List<List<int>> getSubMatrix(List<List<int>> matrix, int row, int col) {
    List<List<int>> subMatrix = [];

    for (int i = 1; i < matrix.length; i++) {
      List<int> rowValues = [];

      for (int j = 0; j < matrix[i].length; j++) {
        if (j != col) {
          rowValues.add(matrix[i][j]);
        }
      }

      subMatrix.add(rowValues);
    }

    return subMatrix;
  }
}
