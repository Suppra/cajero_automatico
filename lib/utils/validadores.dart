import 'package:flutter/foundation.dart';
import '../models/retiro_model.dart';

/// Validadores para los diferentes tipos de retiro del cajero automático
/// Implementa las reglas específicas definidas en el proyecto académico
class ValidadoresRetiro {
  /// Valida número de celular para retiro tipo NEQUI
  /// Debe ser exactamente 10 dígitos, solo números
  static ResultadoValidacion validarNumeroNequi(String numero) {
    // Remover espacios y caracteres especiales
    final numeroLimpio = numero.replaceAll(RegExp(r'[^0-9]'), '');

    // Validar longitud exacta de 10 dígitos
    if (numeroLimpio.length != 10) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'El número de celular debe tener exactamente 10 dígitos',
        codigoError: 'LONGITUD_INVALIDA',
      );
    }

    // Validar que solo contenga números
    if (!RegExp(r'^[0-9]+$').hasMatch(numeroLimpio)) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'El número de celular solo puede contener números',
        codigoError: 'CARACTERES_INVALIDOS',
      );
    }

    // Validar que inicie con 3 (números celulares en Colombia)
    if (!numeroLimpio.startsWith('3')) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'El número de celular debe iniciar con 3',
        codigoError: 'PREFIJO_INVALIDO',
      );
    }

    return ResultadoValidacion(
      valido: true,
      mensaje: 'Número de celular válido',
      valorLimpio: numeroLimpio,
    );
  }

  /// Valida vector para retiro tipo Ahorro a la Mano
  /// Debe ser 11 dígitos, iniciar con 0 o 1 (no 2-9), segundo dígito obligatorio 3
  static ResultadoValidacion validarNumeroAhorroMano(String numero) {
    // Remover espacios y caracteres especiales
    final numeroLimpio = numero.replaceAll(RegExp(r'[^0-9]'), '');

    // Validar longitud exacta de 11 dígitos
    if (numeroLimpio.length != 11) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'El vector debe tener exactamente 11 dígitos',
        codigoError: 'LONGITUD_INVALIDA',
      );
    }

    // Validar que solo contenga números del 0-9 (no caracteres alfabéticos ni especiales)
    if (!RegExp(r'^[0-9]+$').hasMatch(numeroLimpio)) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'El vector no debe contener caracteres alfabéticos ni especiales',
        codigoError: 'CARACTERES_INVALIDOS',
      );
    }

    // Validar que el primer dígito sea 0 o 1 (NO se permite 2-9)
    final primerDigito = numeroLimpio[0];
    if (primerDigito != '0' && primerDigito != '1') {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'El primer dígito debe ser 0 o 1. No se permiten números del 2 al 9',
        codigoError: 'PRIMER_DIGITO_INVALIDO',
      );
    }

    // Validar que el segundo dígito sea obligatoriamente 3
    final segundoDigito = numeroLimpio[1];
    if (segundoDigito != '3') {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'El segundo dígito debe ser obligatoriamente 3',
        codigoError: 'SEGUNDO_DIGITO_INVALIDO',
      );
    }

    return ResultadoValidacion(
      valido: true,
      mensaje: 'Vector de ahorro a la mano válido',
      valorLimpio: numeroLimpio,
    );
  }

  /// Valida número de cuenta de ahorros
  /// Debe ser 11 dígitos, solo números del 0-9
  static ResultadoValidacion validarNumeroCuentaAhorro(String numero) {
    // Remover espacios y caracteres especiales
    final numeroLimpio = numero.replaceAll(RegExp(r'[^0-9]'), '');

    // Validar longitud exacta de 11 dígitos
    if (numeroLimpio.length != 11) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'El número de cuenta debe tener exactamente 11 dígitos',
        codigoError: 'LONGITUD_INVALIDA',
      );
    }

    // Validar que solo contenga números del 0-9
    if (!RegExp(r'^[0-9]+$').hasMatch(numeroLimpio)) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'El número de cuenta solo puede contener números del 0 al 9',
        codigoError: 'CARACTERES_INVALIDOS',
      );
    }

    // Validar que no sea todo ceros
    if (numeroLimpio == '00000000000') {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'El número de cuenta no puede ser todo ceros',
        codigoError: 'CUENTA_INVALIDA',
      );
    }

    return ResultadoValidacion(
      valido: true,
      mensaje: 'Número de cuenta válido',
      valorLimpio: numeroLimpio,
    );
  }

  /// Valida clave según el tipo de retiro
  static ResultadoValidacion validarClave(String clave, TipoRetiro tipo) {
    // Remover espacios
    final claveLimpia = clave.replaceAll(' ', '');

    // Validar que solo contenga números
    if (!RegExp(r'^[0-9]+$').hasMatch(claveLimpia)) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'La clave solo puede contener números',
        codigoError: 'CLAVE_CARACTERES_INVALIDOS',
      );
    }

    // Validar longitud según el tipo
    final longitudEsperada = tipo.longitudClave;
    if (claveLimpia.length != longitudEsperada) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'La clave debe tener exactamente $longitudEsperada dígitos',
        codigoError: 'CLAVE_LONGITUD_INVALIDA',
      );
    }

    return ResultadoValidacion(valido: true, mensaje: 'Clave válida', valorLimpio: claveLimpia);
  }

  /// Valida monto de retiro
  static ResultadoValidacion validarMonto(String montoStr, [TipoRetiro? tipoRetiro]) {
    // Remover caracteres no numéricos excepto punto y coma
    final montoLimpio = montoStr.replaceAll(RegExp(r'[^\d.,]'), '');

    if (montoLimpio.isEmpty) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'Ingrese un monto válido',
        codigoError: 'MONTO_VACIO',
      );
    }

    // Convertir a número
    double? monto;
    try {
      // Reemplazar comas por puntos para parsing
      final montoParaParsing = montoLimpio.replaceAll(',', '.');
      monto = double.parse(montoParaParsing);
    } catch (e) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'Formato de monto inválido',
        codigoError: 'MONTO_FORMATO_INVALIDO',
      );
    }

    // Validar que sea positivo
    if (monto <= 0) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'El monto debe ser mayor a cero',
        codigoError: 'MONTO_NEGATIVO',
      );
    }

    // Validar monto mínimo universal
    const montoMinimo = 10000.0;
    if (monto < montoMinimo) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'El monto mínimo es \$${_formatearMonto(montoMinimo)}',
        codigoError: 'MONTO_MINIMO_NO_ALCANZADO',
      );
    }

    // Validar monto máximo universal
    const montoMaximo = 2000000.0;
    if (monto > montoMaximo) {
      return ResultadoValidacion(
        valido: false,
        mensaje: 'El monto máximo es \$${_formatearMonto(montoMaximo)}',
        codigoError: 'MONTO_MAXIMO_EXCEDIDO',
      );
    }

    // Validar si el monto se puede formar exactamente con billetes de 10k, 20k, 50k, 100k
    final denominaciones = [100000, 50000, 20000, 10000];
    int montoRestante = monto.round();
    for (final billete in denominaciones) {
      final cantidad = montoRestante ~/ billete;
      montoRestante -= cantidad * billete;
    }
    if (kDebugMode) {
      print('DEBUG Validador: monto=$monto, montoRestante=$montoRestante');
    }
    if (montoRestante != 0) {
      return ResultadoValidacion(
        valido: false,
        mensaje:
            'El monto no se puede entregar con billetes de \$10,000, \$20,000, \$50,000 y \$100,000',
        codigoError: 'MONTO_NO_FORMABLE',
      );
    }

    return ResultadoValidacion(valido: true, mensaje: 'Monto válido', valorNumerico: monto);
  }

  /// Formatea un monto con separadores de miles
  static String _formatearMonto(double monto) {
    return monto
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},');
  }
}

/// Resultado de una validación
class ResultadoValidacion {
  final bool valido;
  final String mensaje;
  final String? codigoError;
  final String? valorLimpio;
  final double? valorNumerico;

  const ResultadoValidacion({
    required this.valido,
    required this.mensaje,
    this.codigoError,
    this.valorLimpio,
    this.valorNumerico,
  });

  @override
  String toString() {
    return 'ResultadoValidacion{valido: $valido, mensaje: $mensaje}';
  }
}
