import 'calculador_billetes.dart';

/// Modelo que representa el estado del cajero automático
/// Maneja el inventario de billetes y las operaciones
class CajeroAutomatico {
  final String id;
  final String ubicacion;
  final Map<int, int> inventarioBilletes; // Denominación -> Cantidad disponible
  final bool activo;
  final double limiteRetiroMaximo;
  final double limiteRetiroMinimo;
  final List<String> transaccionesRecientes;

  const CajeroAutomatico({
    required this.id,
    required this.ubicacion,
    required this.inventarioBilletes,
    this.activo = true,
    this.limiteRetiroMaximo = 2000000, // $2,000,000
    this.limiteRetiroMinimo = 10000, // $10,000
    this.transaccionesRecientes = const [],
  });

  /// Denominaciones de billetes permitidas
  static const List<int> denominacionesPermitidas = [10000, 20000, 50000, 100000];

  /// Factory para crear un cajero con inventario inicial
  factory CajeroAutomatico.inicial({
    String id = 'CAJ001',
    String ubicacion = 'Universidad Popular del César',
  }) {
    return CajeroAutomatico(
      id: id,
      ubicacion: ubicacion,
      inventarioBilletes: {
        10000: 100, // 100 billetes de $10,000
        20000: 80, // 80 billetes de $20,000
        50000: 50, // 50 billetes de $50,000
        100000: 30, // 30 billetes de $100,000
      },
    );
  }

  /// Verifica si es posible realizar un retiro por el monto especificado
  ResultadoVerificacion verificarRetiro(double monto) {
    // Validar que el monto esté en el rango permitido
    if (monto < limiteRetiroMinimo) {
      return ResultadoVerificacion(
        posible: false,
        mensaje: 'El monto mínimo de retiro es \$${_formatearMonto(limiteRetiroMinimo)}',
      );
    }

    if (monto > limiteRetiroMaximo) {
      return ResultadoVerificacion(
        posible: false,
        mensaje: 'El monto máximo de retiro es \$${_formatearMonto(limiteRetiroMaximo)}',
      );
    }

    // Verificar si el cajero está activo
    if (!activo) {
      return ResultadoVerificacion(
        posible: false,
        mensaje: 'El cajero automático no está disponible en este momento',
      );
    }

    // Calcular billetes necesarios usando metodología del acarreo
    final billetesCalculados =
        CalculadorBilletes.calcularBilletes(monto.toInt(), denominacionesPermitidas) ?? {};

    if (billetesCalculados.isEmpty) {
      return ResultadoVerificacion(
        posible: false,
        mensaje: 'No se puede entregar el monto solicitado. Use múltiplos de \$10,000',
        codigoError: 'MONTO_INVALIDO',
      );
    }

    // Verificar disponibilidad de billetes en inventario
    for (final entry in billetesCalculados.entries) {
      final denominacion = entry.key;
      final cantidadNecesaria = entry.value;
      final cantidadDisponible = inventarioBilletes[denominacion] ?? 0;

      if (cantidadNecesaria > cantidadDisponible) {
        return ResultadoVerificacion(
          posible: false,
          mensaje: 'No hay suficientes billetes de \$${_formatearMonto(denominacion.toDouble())}',
          codigoError: 'BILLETES_INSUFICIENTES',
        );
      }
    }

    return ResultadoVerificacion(
      posible: true,
      mensaje: 'Retiro posible',
      billetesNecesarios: billetesCalculados,
    );
  }

  /// Simula la entrega de billetes y actualiza el inventario
  CajeroAutomatico entregarBilletes(Map<int, int> billetesEntregados) {
    final nuevoInventario = Map<int, int>.from(inventarioBilletes);

    billetesEntregados.forEach((denominacion, cantidad) {
      nuevoInventario[denominacion] = (nuevoInventario[denominacion] ?? 0) - cantidad;
    });

    return CajeroAutomatico(
      id: id,
      ubicacion: ubicacion,
      inventarioBilletes: nuevoInventario,
      activo: activo,
      limiteRetiroMaximo: limiteRetiroMaximo,
      limiteRetiroMinimo: limiteRetiroMinimo,
      transaccionesRecientes: transaccionesRecientes,
    );
  }

  /// Calcula cuántos retiros adicionales son posibles con el inventario actual
  int calcularRetirosRestantes(double monto) {
    if (!verificarRetiro(monto).posible) return 0;

    final billetesNecesarios =
        CalculadorBilletes.calcularBilletes(monto.toInt(), denominacionesPermitidas) ?? {};
    if (billetesNecesarios.isEmpty) return 0;

    int retirosMinimos = double.maxFinite.toInt();

    for (final entry in billetesNecesarios.entries) {
      final denominacion = entry.key;
      final cantidadPorRetiro = entry.value;
      final cantidadDisponible = inventarioBilletes[denominacion] ?? 0;

      final retirosConEsteDenominacion = cantidadDisponible ~/ cantidadPorRetiro;
      retirosMinimos = retirosMinimos < retirosConEsteDenominacion
          ? retirosMinimos
          : retirosConEsteDenominacion;
    }

    return retirosMinimos == double.maxFinite.toInt() ? 0 : retirosMinimos;
  }

  /// Calcula el total de dinero disponible en el cajero
  double get totalDisponible {
    return inventarioBilletes.entries
        .map((entry) => entry.key * entry.value)
        .fold(0.0, (sum, valor) => sum + valor);
  }

  /// Genera reporte del estado del cajero
  String generarReporteEstado() {
    final buffer = StringBuffer();

    buffer.writeln('=== ESTADO DEL CAJERO AUTOMÁTICO ===');
    buffer.writeln('ID: $id');
    buffer.writeln('Ubicación: $ubicacion');
    buffer.writeln('Estado: ${activo ? "ACTIVO" : "INACTIVO"}');
    buffer.writeln('Total disponible: \$${_formatearMonto(totalDisponible)}');
    buffer.writeln('\n=== INVENTARIO DE BILLETES ===');

    for (final denominacion in denominacionesPermitidas.reversed) {
      final cantidad = inventarioBilletes[denominacion] ?? 0;
      final valor = denominacion * cantidad;
      buffer.writeln(
        '\$${_formatearMonto(denominacion.toDouble())}: $cantidad billetes = \$${_formatearMonto(valor.toDouble())}',
      );
    }

    return buffer.toString();
  }

  String _formatearMonto(double monto) {
    return monto
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},');
  }

  /// Convierte a Map para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ubicacion': ubicacion,
      'inventarioBilletes': inventarioBilletes,
      'activo': activo,
      'limiteRetiroMaximo': limiteRetiroMaximo,
      'limiteRetiroMinimo': limiteRetiroMinimo,
      'transaccionesRecientes': transaccionesRecientes,
    };
  }

  /// Crea desde Map
  factory CajeroAutomatico.fromMap(Map<String, dynamic> map) {
    return CajeroAutomatico(
      id: map['id'] ?? '',
      ubicacion: map['ubicacion'] ?? '',
      inventarioBilletes: Map<int, int>.from(map['inventarioBilletes'] ?? {}),
      activo: map['activo'] ?? true,
      limiteRetiroMaximo: (map['limiteRetiroMaximo'] ?? 2000000).toDouble(),
      limiteRetiroMinimo: (map['limiteRetiroMinimo'] ?? 10000).toDouble(),
      transaccionesRecientes: List<String>.from(map['transaccionesRecientes'] ?? []),
    );
  }
}

/// Resultado de la verificación de un retiro
class ResultadoVerificacion {
  final bool posible;
  final String mensaje;
  final String? codigoError;
  final Map<int, int>? billetesNecesarios;

  const ResultadoVerificacion({
    required this.posible,
    required this.mensaje,
    this.codigoError,
    this.billetesNecesarios,
  });
}
