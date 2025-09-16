/// Modelo que representa un retiro en el cajero automático
/// Siguiendo la metodología del acarreo especificada en el proyecto académico
class Retiro {
  final String id;
  final TipoRetiro tipo;
  final String numeroIdentificacion;
  final double monto;
  final String clave;
  final DateTime fechaHora;
  final Map<int, int> billetes; // Denominación -> Cantidad
  final bool exitoso;
  final String? mensajeError;

  const Retiro({
    required this.id,
    required this.tipo,
    required this.numeroIdentificacion,
    required this.monto,
    required this.clave,
    required this.fechaHora,
    required this.billetes,
    this.exitoso = false,
    this.mensajeError,
  });

  /// Convierte el modelo a Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo.toString(),
      'numeroIdentificacion': numeroIdentificacion,
      'monto': monto,
      'clave': clave,
      'fechaHora': fechaHora.millisecondsSinceEpoch,
      'billetes': billetes,
      'exitoso': exitoso,
      'mensajeError': mensajeError,
    };
  }

  /// Crea un modelo desde Map de Firebase
  factory Retiro.fromMap(Map<String, dynamic> map) {
    return Retiro(
      id: map['id'] ?? '',
      tipo: TipoRetiro.values.firstWhere(
        (e) => e.toString() == map['tipo'],
        orElse: () => TipoRetiro.nequi,
      ),
      numeroIdentificacion: map['numeroIdentificacion'] ?? '',
      monto: (map['monto'] ?? 0).toDouble(),
      clave: map['clave'] ?? '',
      fechaHora: DateTime.fromMillisecondsSinceEpoch(map['fechaHora'] ?? 0),
      billetes: Map<int, int>.from(map['billetes'] ?? {}),
      exitoso: map['exitoso'] ?? false,
      mensajeError: map['mensajeError'],
    );
  }

  /// Calcula el total de billetes entregados
  int get totalBilletes => billetes.values.fold(0, (sum, cantidad) => sum + cantidad);

  /// Verifica si el retiro es válido según las reglas de billetes
  bool get esMontoValido {
    const billetesPermitidos = [10000, 20000, 50000, 100000];
    return _puedeEntregarse(monto.toInt(), billetesPermitidos);
  }

  /// Algoritmo de la metodología del acarreo para calcular billetes
  static bool _puedeEntregarse(int monto, List<int> denominaciones) {
    if (monto <= 0) return false;
    
    for (int denominacion in denominaciones.reversed) {
      while (monto >= denominacion) {
        monto -= denominacion;
      }
    }
    
    return monto == 0;
  }

  @override
  String toString() {
    return 'Retiro{tipo: $tipo, monto: $monto, billetes: $billetes}';
  }
}

/// Enumeración de los tipos de retiro disponibles
enum TipoRetiro {
  nequi,        // Retiro por número de celular (10 dígitos)
  ahorroMano,   // Retiro estilo ahorro a la mano (11 dígitos, inicia 0 o 1, segundo dígito 3)  
  cuentaAhorro  // Retiro por cuenta de ahorros (11 dígitos)
}

extension TipoRetiroExtension on TipoRetiro {
  /// Nombre descriptivo del tipo de retiro
  String get nombre {
    switch (this) {
      case TipoRetiro.nequi:
        return 'NEQUI - Retiro con Celular';
      case TipoRetiro.ahorroMano:
        return 'Ahorro a la Mano';
      case TipoRetiro.cuentaAhorro:
        return 'Cuenta de Ahorros';
    }
  }

  /// Descripción de las validaciones para cada tipo
  String get descripcionValidacion {
    switch (this) {
      case TipoRetiro.nequi:
        return 'Número de celular de 10 dígitos, solo números';
      case TipoRetiro.ahorroMano:
        return 'Número de 11 dígitos, debe iniciar con 0 o 1, segundo dígito debe ser 3';
      case TipoRetiro.cuentaAhorro:
        return 'Número de cuenta de 11 dígitos, solo números del 0-9';
    }
  }

  /// Longitud de la clave para cada tipo de retiro
  int get longitudClave {
    switch (this) {
      case TipoRetiro.nequi:
        return 6; // Clave temporal visible
      case TipoRetiro.ahorroMano:
      case TipoRetiro.cuentaAhorro:
        return 4; // Clave oculta
    }
  }

  /// Indica si la clave debe ser visible temporalmente
  bool get claveVisible {
    return this == TipoRetiro.nequi;
  }
}