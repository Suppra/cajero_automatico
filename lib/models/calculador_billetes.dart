class CalculadorBilletes {
  static bool montoValido(int monto, List<int> denominaciones) {
    if (monto <= 0) return false;
    // El monto debe ser múltiplo del menor billete permitido
    final menor = denominaciones.reduce((a, b) => a < b ? a : b);
    return monto % menor == 0;
  }

  static Map<int, int>? calcularBilletes(int monto, List<int> denominaciones) {
    if (!montoValido(monto, denominaciones)) {
      return null;
    }
    denominaciones = List.from(denominaciones)..sort(); // menor a mayor
    List<List<int>> matriz = [];
    int suma = 0;
    bool alcanzado = false;
    int totalRows = 0;
    while (!alcanzado) {
      List<int> fila = List.generate(totalRows, (_) => 0, growable: true);
      bool sePudoSumar = false;
      int sumaTemporal = suma;
      for (int j = totalRows; j < denominaciones.length; j++) {
        if (sumaTemporal + denominaciones[j] <= monto) {
          fila.add(1);
          sumaTemporal += denominaciones[j];
          sePudoSumar = true;
          if (sumaTemporal == monto) {
            alcanzado = true;
            suma = sumaTemporal;
            break;
          }
        } else {
          fila.add(0);
        }
      }
      suma = sumaTemporal;
      matriz.add(fila);
      if (!sePudoSumar && fila.sublist(totalRows).every((v) => v == 0)) {
        if (fila.sublist(totalRows).any((v) => v == 1)) {
          totalRows += 1;
        } else {
          totalRows = 0;
        }
      } else {
        totalRows += 1;
      }
    }
    if (matriz.isEmpty) return null;
    Map<int, int> resultado = {for (var d in denominaciones) d: 0};
    for (var fila in matriz) {
      for (int j = 0; j < fila.length; j++) {
        if (fila[j] == 1 && j < denominaciones.length) {
          resultado[denominaciones[j]] = resultado[denominaciones[j]]! + 1;
        }
      }
    }
    return resultado;
  }
}
