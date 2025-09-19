/// Calculador de billetes usando algoritmo de acarreo basado en el ejemplo en Python
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
    denominaciones = List.from(denominaciones)..sort((a, b) => b.compareTo(a)); // Orden descendente
    Map<int, int> resultado = {for (var d in denominaciones) d: 0};
    int restante = monto;
    for (final d in denominaciones) {
      resultado[d] = restante ~/ d;
      restante = restante % d;
    }
    if (restante != 0) return null;
    return resultado;
  }
}
