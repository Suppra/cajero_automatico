import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaccion_model.dart';
import '../models/cajero_model.dart';
import '../models/retiro_model.dart';

/// Servicio para manejar operaciones con Firebase
/// Gestiona autenticación y almacenamiento de transacciones
class FirebaseService {
  /// Guarda un retiro en Firestore
  static Future<bool> guardarRetiro(Retiro retiro) async {
    try {
      await _firestore.collection('retiros').doc(retiro.id).set(retiro.toMap());
      return true;
    } catch (e) {
      print('Error guardando retiro: $e');
      return false;
    }
  }

  /// Inicializa las colecciones base en Firestore si están vacías
  static Future<void> inicializarEstructuraBase() async {
    // Colecciones a crear
    final colecciones = ['usuarios', 'transacciones', 'retiros'];
    for (final col in colecciones) {
      final snapshot = await _firestore.collection(col).limit(1).get();
      if (snapshot.size == 0) {
        // Crear un documento de ejemplo para inicializar la colección
        await _firestore.collection(col).add({
          'init': true,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
    }
  }

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Colecciones en Firestore
  static const String _transaccionesCollection = 'transacciones';
  static const String _cajerosCollection = 'cajeros';
  static const String _estadisticasCollection = 'estadisticas';

  /// Autentica un usuario anónimo para usar la aplicación
  static Future<bool> autenticarUsuario() async {
    try {
      // Verificar si ya hay un usuario autenticado
      if (_auth.currentUser != null) {
        return true;
      }

      // Autenticar como usuario anónimo
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user != null;
    } catch (e) {
      print('Error en autenticación: $e');
      return false;
    }
  }

  /// Guarda una transacción en Firestore
  static Future<bool> guardarTransaccion(Transaccion transaccion) async {
    try {
      // Agregar el reporte detallado al map
      final map = transaccion.toMap();
      map['reporteDetallado'] = transaccion.generarReporte();
      await _firestore.collection(_transaccionesCollection).doc(transaccion.id).set(map);

      // Actualizar estadísticas
      await _actualizarEstadisticas(transaccion);

      return true;
    } catch (e) {
      print('Error guardando transacción: $e');
      return false;
    }
  }

  /// Obtiene las transacciones recientes
  static Future<List<Transaccion>> obtenerTransaccionesRecientes({int limite = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_transaccionesCollection)
          .orderBy('fechaHora', descending: true)
          .limit(limite)
          .get();

      return querySnapshot.docs.map((doc) => Transaccion.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error obteniendo transacciones: $e');
      return [];
    }
  }

  /// Guarda el estado del cajero automático
  static Future<bool> guardarEstadoCajero(CajeroAutomatico cajero) async {
    try {
      await _firestore.collection(_cajerosCollection).doc(cajero.id).set(cajero.toMap());

      return true;
    } catch (e) {
      print('Error guardando estado del cajero: $e');
      return false;
    }
  }

  /// Obtiene el estado del cajero automático
  static Future<CajeroAutomatico?> obtenerEstadoCajero(String cajeroId) async {
    try {
      final docSnapshot = await _firestore.collection(_cajerosCollection).doc(cajeroId).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return CajeroAutomatico.fromMap(docSnapshot.data()!);
      }

      return null;
    } catch (e) {
      print('Error obteniendo estado del cajero: $e');
      return null;
    }
  }

  /// Obtiene estadísticas de uso
  static Future<Map<String, dynamic>> obtenerEstadisticas() async {
    try {
      final docSnapshot = await _firestore.collection(_estadisticasCollection).doc('general').get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return docSnapshot.data()!;
      }

      return {
        'totalTransacciones': 0,
        'transaccionesExitosas': 0,
        'montoTotalRetirado': 0.0,
        'tipoRetiroMasFrecuente': '',
        'ultimaActualizacion': DateTime.now().millisecondsSinceEpoch,
      };
    } catch (e) {
      print('Error obteniendo estadísticas: $e');
      return {};
    }
  }

  /// Actualiza las estadísticas después de cada transacción
  static Future<void> _actualizarEstadisticas(Transaccion transaccion) async {
    try {
      final estadisticasRef = _firestore.collection(_estadisticasCollection).doc('general');

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(estadisticasRef);

        Map<String, dynamic> estadisticas = {};
        if (snapshot.exists && snapshot.data() != null) {
          estadisticas = snapshot.data()!;
        }

        // Actualizar contadores
        estadisticas['totalTransacciones'] = (estadisticas['totalTransacciones'] ?? 0) + 1;

        if (transaccion.exitosa) {
          estadisticas['transaccionesExitosas'] = (estadisticas['transaccionesExitosas'] ?? 0) + 1;
          estadisticas['montoTotalRetirado'] =
              (estadisticas['montoTotalRetirado'] ?? 0.0) + transaccion.monto;
        }

        // Actualizar tipo más frecuente
        final contadorTipos = Map<String, int>.from(estadisticas['contadorTipos'] ?? {});
        final tipoString = transaccion.tipoRetiro.toString();
        contadorTipos[tipoString] = (contadorTipos[tipoString] ?? 0) + 1;
        estadisticas['contadorTipos'] = contadorTipos;

        // Encontrar el tipo más frecuente
        String tipoMasFrecuente = '';
        int maxCount = 0;
        contadorTipos.forEach((tipo, count) {
          if (count > maxCount) {
            maxCount = count;
            tipoMasFrecuente = tipo;
          }
        });
        estadisticas['tipoRetiroMasFrecuente'] = tipoMasFrecuente;
        estadisticas['ultimaActualizacion'] = DateTime.now().millisecondsSinceEpoch;

        transaction.set(estadisticasRef, estadisticas);
      });
    } catch (e) {
      print('Error actualizando estadísticas: $e');
    }
  }

  /// Obtiene transacciones por tipo de retiro
  static Future<List<Transaccion>> obtenerTransaccionesPorTipo(String tipoRetiro) async {
    try {
      final querySnapshot = await _firestore
          .collection(_transaccionesCollection)
          .where('tipoRetiro', isEqualTo: tipoRetiro)
          .orderBy('fechaHora', descending: true)
          .limit(50)
          .get();

      return querySnapshot.docs.map((doc) => Transaccion.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error obteniendo transacciones por tipo: $e');
      return [];
    }
  }

  /// Limpia las transacciones antiguas (más de 30 días)
  static Future<void> limpiarTransaccionesAntiguas() async {
    try {
      final hace30Dias = DateTime.now().subtract(Duration(days: 30));
      final querySnapshot = await _firestore
          .collection(_transaccionesCollection)
          .where('fechaHora', isLessThan: hace30Dias.millisecondsSinceEpoch)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('Limpieza completada: ${querySnapshot.docs.length} transacciones eliminadas');
    } catch (e) {
      print('Error en limpieza de transacciones: $e');
    }
  }

  /// Cierra la sesión del usuario
  static Future<void> cerrarSesion() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error cerrando sesión: $e');
    }
  }

  /// Verifica si hay conexión a internet
  static Future<bool> verificarConexion() async {
    try {
      await _firestore.enableNetwork();
      return true;
    } catch (e) {
      print('Sin conexión a internet: $e');
      return false;
    }
  }
}
