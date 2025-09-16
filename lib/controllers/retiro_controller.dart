import 'package:flutter/foundation.dart';
import '../models/retiro_model.dart';
import '../models/transaccion_model.dart';
import '../models/cajero_model.dart';
import '../services/firebase_service.dart';
import '../utils/validadores.dart';
import 'dart:math';

/// Controlador principal para manejar las operaciones de retiro
/// Implementa la lógica de negocio siguiendo el patrón MVC
class RetiroController extends ChangeNotifier {
  // Estado del cajero automático
  CajeroAutomatico _cajero = CajeroAutomatico.inicial();

  // Estado de la transacción actual
  TipoRetiro? _tipoRetiroSeleccionado;
  String _numeroIdentificacion = '';
  String _clave = '';
  double _monto = 0.0;
  bool _procesandoRetiro = false;
  String? _mensajeError;
  bool _debeRegresarAlInicio = false;
  Transaccion? _ultimaTransaccion;

  // Lista de montos predefinidos
  final List<double> _montosPredefindios = [
    50000, // $50,000
    100000, // $100,000
    200000, // $200,000
    300000, // $300,000
    500000, // $500,000
  ];

  // Getters
  CajeroAutomatico get cajero => _cajero;
  TipoRetiro? get tipoRetiroSeleccionado => _tipoRetiroSeleccionado;
  String get numeroIdentificacion => _numeroIdentificacion;
  String get clave => _clave;
  double get monto => _monto;
  bool get procesandoRetiro => _procesandoRetiro;
  String? get mensajeError => _mensajeError;
  bool get debeRegresarAlInicio => _debeRegresarAlInicio;
  Transaccion? get ultimaTransaccion => _ultimaTransaccion;
  List<double> get montosPredefindios => _montosPredefindios;

  /// Inicializa el controlador cargando el estado del cajero
  Future<void> inicializar() async {
    try {
      // Autenticar usuario
      final autenticado = await FirebaseService.autenticarUsuario();
      if (!autenticado) {
        _mostrarError('Error de autenticación');
        return;
      }

      // Cargar estado del cajero desde Firebase
      final estadoCajero = await FirebaseService.obtenerEstadoCajero('CAJ001');
      if (estadoCajero != null) {
        _cajero = estadoCajero;
      } else {
        // Si no existe, crear uno nuevo y guardarlo
        _cajero = CajeroAutomatico.inicial();
        await FirebaseService.guardarEstadoCajero(_cajero);
      }

      notifyListeners();
    } catch (e) {
      _mostrarError('Error inicializando cajero: $e');
    }
  }

  /// Selecciona el tipo de retiro
  void seleccionarTipoRetiro(TipoRetiro tipo) {
    if (kDebugMode) {
      print('DEBUG: Seleccionando tipo de retiro: $tipo');
    }
    _tipoRetiroSeleccionado = tipo;
    _limpiarDatos();
    notifyListeners();
  }

  /// Actualiza el número de identificación y lo valida
  void actualizarNumeroIdentificacion(String numero) {
    _numeroIdentificacion = numero;
    _mensajeError = null;

    // Validar según el tipo de retiro
    if (_tipoRetiroSeleccionado != null) {
      final resultado = _validarNumeroSegunTipo(numero, _tipoRetiroSeleccionado!);
      if (!resultado.valido) {
        _mostrarError(resultado.mensaje);
      }
    }

    notifyListeners();
  }

  /// Actualiza la clave y la valida
  void actualizarClave(String clave) {
    _clave = clave;
    _mensajeError = null;

    if (_tipoRetiroSeleccionado != null) {
      final resultado = ValidadoresRetiro.validarClave(clave, _tipoRetiroSeleccionado!);
      if (!resultado.valido) {
        _mostrarError(resultado.mensaje);
      }
    }

    notifyListeners();
  }

  /// Actualiza el monto sin validar (para permitir escritura)
  void actualizarMonto(double monto) {
    _monto = monto;
    _mensajeError = null;
    _debeRegresarAlInicio = false;
    notifyListeners();
  }

  /// Valida el monto cuando el usuario termina de escribir o intenta procesar
  void validarMontoFinal() {
    if (_monto <= 0) return;

    // Debug temporal
    if (kDebugMode) {
      print('DEBUG: Validando monto $_monto para tipo $_tipoRetiroSeleccionado');
    }

    final resultado = ValidadoresRetiro.validarMonto(_monto.toString(), _tipoRetiroSeleccionado);

    // Debug temporal
    if (kDebugMode) {
      print(
        'DEBUG: Resultado validación: ${resultado.valido}, mensaje: ${resultado.mensaje}, código: ${resultado.codigoError}',
      );
    }

    if (!resultado.valido) {
      _mostrarError(resultado.mensaje);

      // Si es un error de múltiplo, cancelar todo el proceso
      if (resultado.codigoError == 'MONTO_NO_MULTIPLO') {
        _debeRegresarAlInicio = true;
        _limpiarDatos();
      }
    }
    notifyListeners();
  }

  /// Genera una clave temporal para retiros NEQUI
  String generarClaveTemporalNequi() {
    final random = Random();
    final clave = List.generate(6, (index) => random.nextInt(10)).join();
    _clave = clave;
    notifyListeners();
    return clave;
  }

  /// Procesa el retiro completo
  Future<bool> procesarRetiro() async {
    if (_tipoRetiroSeleccionado == null) {
      _mostrarError('Seleccione un tipo de retiro');
      return false;
    }

    _procesandoRetiro = true;
    _mensajeError = null;
    notifyListeners();

    try {
      // Validar todos los campos
      final validacionCompleta = _validarDatosCompletos();
      if (!validacionCompleta.valido) {
        _mostrarError(validacionCompleta.mensaje);

        // Si es un error de múltiplo durante el procesamiento, cancelar todo
        if (validacionCompleta.codigoError == 'MONTO_NO_MULTIPLO') {
          _debeRegresarAlInicio = true;
          _limpiarDatos();
        }
        return false;
      }

      // Verificar si el cajero puede realizar el retiro
      final verificacion = _cajero.verificarRetiro(_monto);
      if (!verificacion.posible) {
        _mostrarError(verificacion.mensaje);
        return false;
      }

      // Crear la transacción
      final transaccionId = _generarIdTransaccion();
      final transaccion = Transaccion(
        id: transaccionId,
        numeroIdentificacion: _numeroIdentificacion,
        tipoRetiro: _tipoRetiroSeleccionado!,
        monto: _monto,
        fechaHora: DateTime.now(),
        billetesEntregados: verificacion.billetesNecesarios ?? {},
        exitosa: true,
        referencia: _generarReferencia(),
      );

      // Actualizar inventario del cajero
      _cajero = _cajero.entregarBilletes(verificacion.billetesNecesarios ?? {});

      // Guardar en Firebase
      await Future.wait([
        FirebaseService.guardarTransaccion(transaccion),
        FirebaseService.guardarRetiro(
          Retiro(
            id: transaccion.id,
            tipo: transaccion.tipoRetiro,
            numeroIdentificacion: transaccion.numeroIdentificacion,
            monto: transaccion.monto,
            clave: _clave,
            fechaHora: transaccion.fechaHora,
            billetes: transaccion.billetesEntregados,
            exitoso: transaccion.exitosa,
            mensajeError: transaccion.mensajeError,
          ),
        ),
        FirebaseService.guardarEstadoCajero(_cajero),
      ]);

      _ultimaTransaccion = transaccion;
      _limpiarDatos();

      return true;
    } catch (e) {
      _mostrarError('Error procesando retiro: $e');
      return false;
    } finally {
      _procesandoRetiro = false;
      notifyListeners();
    }
  }

  /// Calcula retiros restantes para un monto específico
  int calcularRetirosRestantes(double monto) {
    return _cajero.calcularRetirosRestantes(monto);
  }

  /// Obtiene el reporte de la última transacción
  String? obtenerReporteUltimaTransaccion() {
    return _ultimaTransaccion?.generarReporte();
  }

  /// Obtiene el estado actual del cajero
  String obtenerEstadoCajero() {
    return _cajero.generarReporteEstado();
  }

  /// Valida el número según el tipo de retiro
  ResultadoValidacion _validarNumeroSegunTipo(String numero, TipoRetiro tipo) {
    switch (tipo) {
      case TipoRetiro.nequi:
        return ValidadoresRetiro.validarNumeroNequi(numero);
      case TipoRetiro.ahorroMano:
        return ValidadoresRetiro.validarNumeroAhorroMano(numero);
      case TipoRetiro.cuentaAhorro:
        return ValidadoresRetiro.validarNumeroCuentaAhorro(numero);
    }
  }

  /// Valida que todos los datos estén completos y correctos
  ResultadoValidacion _validarDatosCompletos() {
    if (_tipoRetiroSeleccionado == null) {
      return ResultadoValidacion(valido: false, mensaje: 'Seleccione un tipo de retiro');
    }

    // Validar número de identificación
    final validacionNumero = _validarNumeroSegunTipo(
      _numeroIdentificacion,
      _tipoRetiroSeleccionado!,
    );
    if (!validacionNumero.valido) {
      return validacionNumero;
    }

    // Validar clave
    final validacionClave = ValidadoresRetiro.validarClave(_clave, _tipoRetiroSeleccionado!);
    if (!validacionClave.valido) {
      return validacionClave;
    }

    // Validar monto
    final validacionMonto = ValidadoresRetiro.validarMonto(
      _monto.toString(),
      _tipoRetiroSeleccionado,
    );
    if (!validacionMonto.valido) {
      return validacionMonto;
    }

    return ResultadoValidacion(valido: true, mensaje: 'Datos válidos');
  }

  /// Genera un ID único para la transacción
  String _generarIdTransaccion() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999).toString().padLeft(4, '0');
    return 'TRX$timestamp$random';
  }

  /// Genera una referencia única para la transacción
  String _generarReferencia() {
    final random = Random();
    final letras = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final referencia =
        List.generate(3, (index) => letras[random.nextInt(26)]).join() +
        List.generate(6, (index) => random.nextInt(10)).join();
    return referencia;
  }

  /// Limpia todos los datos del formulario
  void _limpiarDatos() {
    _numeroIdentificacion = '';
    _clave = '';
    _monto = 0.0;
    _mensajeError = null;
  }

  /// Resetea la flag de regreso al inicio
  void resetearRegresarAlInicio() {
    _debeRegresarAlInicio = false;
    notifyListeners();
  }

  /// Muestra un mensaje de error
  void _mostrarError(String mensaje) {
    _mensajeError = mensaje;
    if (kDebugMode) {
      print('Error: $mensaje');
    }
  }

  /// Limpia el mensaje de error
  void limpiarError() {
    _mensajeError = null;
    notifyListeners();
  }
}
