import 'retiro_model.dart';

/// Modelo que representa una transacción bancaria
/// Incluye información detallada sobre el retiro realizado
class Transaccion {
  final String id;
  final String numeroIdentificacion;
  final TipoRetiro tipoRetiro;
  final double monto;
  final DateTime fechaHora;
  final Map<int, int> billetesEntregados;
  final bool exitosa;
  final String? codigoError;
  final String? mensajeError;
  final String? referencia;

  const Transaccion({
    required this.id,
    required this.numeroIdentificacion,
    required this.tipoRetiro,
    required this.monto,
    required this.fechaHora,
    required this.billetesEntregados,
    this.exitosa = false,
    this.codigoError,
    this.mensajeError,
    this.referencia,
  });

  /// Convierte la transacción a Map para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numeroIdentificacion': numeroIdentificacion,
      'tipoRetiro': tipoRetiro.toString(),
      'monto': monto,
      'fechaHora': fechaHora.millisecondsSinceEpoch,
      'billetesEntregados': billetesEntregados,
      'exitosa': exitosa,
      'codigoError': codigoError,
      'mensajeError': mensajeError,
      'referencia': referencia,
    };
  }

  /// Crea una transacción desde Map
  factory Transaccion.fromMap(Map<String, dynamic> map) {
    return Transaccion(
      id: map['id'] ?? '',
      numeroIdentificacion: map['numeroIdentificacion'] ?? '',
      tipoRetiro: TipoRetiro.values.firstWhere(
        (e) => e.toString() == map['tipoRetiro'],
        orElse: () => TipoRetiro.nequi,
      ),
      monto: (map['monto'] ?? 0).toDouble(),
      fechaHora: DateTime.fromMillisecondsSinceEpoch(map['fechaHora'] ?? 0),
      billetesEntregados: Map<int, int>.from(map['billetesEntregados'] ?? {}),
      exitosa: map['exitosa'] ?? false,
      codigoError: map['codigoError'],
      mensajeError: map['mensajeError'],
      referencia: map['referencia'],
    );
  }

  /// Genera un reporte detallado de la transacción
  String generarReporte() {
    final buffer = StringBuffer();
    
    buffer.writeln('=== COMPROBANTE DE TRANSACCIÓN ===');
    buffer.writeln('Fecha: ${_formatearFecha(fechaHora)}');
    buffer.writeln('Hora: ${_formatearHora(fechaHora)}');
    buffer.writeln('Tipo: ${tipoRetiro.nombre}');
    buffer.writeln('Identificación: ${_formatearIdentificacion()}');
    buffer.writeln('Monto: \$${_formatearMonto(monto)}');
    
    if (exitosa) {
      buffer.writeln('\n=== BILLETES ENTREGADOS ===');
      billetesEntregados.forEach((denominacion, cantidad) {
        if (cantidad > 0) {
          buffer.writeln('\$${_formatearMonto(denominacion.toDouble())} x $cantidad = \$${_formatearMonto((denominacion * cantidad).toDouble())}');
        }
      });
      buffer.writeln('\nTotal billetes: ${billetesEntregados.values.fold(0, (sum, qty) => sum + qty)}');
    } else {
      buffer.writeln('\n=== ERROR ===');
      buffer.writeln('Código: ${codigoError ?? 'N/A'}');
      buffer.writeln('Mensaje: ${mensajeError ?? 'Error desconocido'}');
    }
    
    if (referencia != null) {
      buffer.writeln('\nReferencia: $referencia');
    }
    
    buffer.writeln('\n=== UNIVERSIDAD POPULAR DEL CÉSAR ===');
    
    return buffer.toString();
  }

  /// Formatea la identificación según el tipo de retiro
  String _formatearIdentificacion() {
    switch (tipoRetiro) {
      case TipoRetiro.nequi:
        return '0$numeroIdentificacion'; // Agrega 0 al inicio para NEQUI
      case TipoRetiro.ahorroMano:
      case TipoRetiro.cuentaAhorro:
        return numeroIdentificacion;
    }
  }

  /// Formatea fecha en formato colombiano
  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  /// Formatea hora en formato 12 horas
  String _formatearHora(DateTime fecha) {
    final hora = fecha.hour > 12 ? fecha.hour - 12 : fecha.hour;
    final periodo = fecha.hour >= 12 ? 'PM' : 'AM';
    return '${hora.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')} $periodo';
  }

  /// Formatea monto con separadores de miles
  String _formatearMonto(double monto) {
    return monto.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }

  @override
  String toString() {
    return 'Transaccion{id: $id, monto: $monto, exitosa: $exitosa}';
  }
}

