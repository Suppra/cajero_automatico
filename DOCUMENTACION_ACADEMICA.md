# CAJERO AUTOMÁTICO - DOCUMENTACIÓN ACADÉMICA
---

## CAMBIOS RECIENTES (Septiembre 2025)

### Mejoras en Retiro NEQUI y Seguridad

- Ahora, al realizar un retiro NEQUI, la clave temporal generada se muestra en pantalla con un botón para copiar fácilmente al portapapeles.
- Al presionar "Procesar Retiro", se abre un diálogo donde el usuario debe ingresar la clave temporal para validar la operación.
- El diálogo incluye un botón para pegar la clave desde el portapapeles, facilitando el flujo y evitando errores de digitación.
- Se mejoró la experiencia visual del diálogo y la card de clave temporal, mostrando mensajes de confirmación al copiar/pegar.
- Se eliminó el campo de clave temporal del formulario principal, ahora la validación es interactiva y más segura.

#### Ejemplo de flujo actualizado:
1. El usuario genera la clave temporal y la copia usando el icono en la card.
2. Al procesar el retiro, aparece un diálogo para ingresar la clave.
3. Puede pegar la clave copiada usando el botón de "pegar".
4. Si la clave es correcta, el retiro se procesa; si no, se muestra un mensaje de error.

Esto mejora la seguridad y la usabilidad del sistema, alineándose con buenas prácticas de UX y validación bancaria.
**Universidad Popular del César**
**Sistemas de Información Empresarial**
**Proyecto Académico**

---

## ÍNDICE

1. [Introducción](#introducción)
2. [Objetivos del Proyecto](#objetivos-del-proyecto)
3. [Arquitectura MVC](#arquitectura-mvc)
4. [Metodología del Acarreo](#metodología-del-acarreo)
5. [Estructura del Proyecto](#estructura-del-proyecto)
6. [Modelos de Datos](#modelos-de-datos)
7. [Controladores](#controladores)
8. [Vistas (UI)](#vistas-ui)
9. [Servicios](#servicios)
10. [Manual de Usuario]  String? _validarRetiroAhorroMano(int monto, Map<String, String>? datos) {
    // Múltiplos de $20,000
    if (monto % 20000 != 0) {
      return 'Los retiros Ahorro a la Mano deben ser múltiplos de \$20,000';
    }

    // Monto máximo
    if (monto > 400000) {
      return 'El monto máximo para Ahorro a la Mano es \$400,000';
    }

    // Validar vector de 11 dígitos
    String? vector = datos?['vector'];
    if (vector == null || vector.length != 11) {
      return 'El vector debe tener exactamente 11 dígitos';
    }

    // Validar primer dígito (solo 0 o 1, no 2-9)
    if (vector[0] != '0' && vector[0] != '1') {
      return 'El primer dígito debe ser 0 o 1 (no se permiten números del 2 al 9)';
    }

    // Validar segundo dígito (obligatorio 3)
    if (vector[1] != '3') {
      return 'El segundo dígito debe ser obligatoriamente 3';
    }

    // Validar que no contenga caracteres alfabéticos ni especiales
    if (!RegExp(r'^[0-9]+$').hasMatch(vector)) {
      return 'El vector no debe contener caracteres alfabéticos ni especiales';
    }

    // Validar clave secreta (4 dígitos)
    String? clave = datos?['clave'];
    if (clave == null || clave.length != 4 || !RegExp(r'^\d{4}$').hasMatch(clave)) {
      return 'La clave debe tener exactamente 4 dígitos';
    }

    return null; // Válido
  })
11. [Guía de Instalación](#guía-de-instalación)
12. [Análisis de Código](#análisis-de-código)
13. [Conclusiones](#conclusiones)

---

## INTRODUCCIÓN

Este proyecto implementa un **sistema completo de cajero automático** desarrollado en **Flutter** con integración a **Firebase**, siguiendo el patrón arquitectónico **Modelo-Vista-Controlador (MVC)** y aplicando la **metodología del acarreo** para el cálculo optimizado de billetes.

### Características Principales
- ✅ **3 tipos de retiros diferentes** con validaciones específicas
- ✅ **Cálculo automático de billetes** usando metodología del acarreo
- ✅ **Interfaz intuitiva** con Material Design
- ✅ **Validaciones robustas** para cada tipo de transacción
- ✅ **Arquitectura MVC** bien definida
- ✅ **Integración con Firebase** para persistencia
- ✅ **Código documentado** y fácil de entender

---

## OBJETIVOS DEL PROYECTO

### Objetivo General
Desarrollar un sistema de cajero automático funcional que demuestre la aplicación de conceptos de ingeniería de software, patrones de diseño y metodologías de cálculo financiero.

### Objetivos Específicos
1. **Implementar la arquitectura MVC** de forma clara y documentada
2. **Aplicar la metodología del acarreo** para optimización de billetes
3. **Crear una interfaz de usuario intuitiva** siguiendo principios de UX
4. **Desarrollar un sistema de validaciones robusto** para cada tipo de retiro
5. **Integrar tecnologías modernas** (Flutter + Firebase)
6. **Generar documentación académica** completa para estudio

---

## ARQUITECTURA MVC

### ¿Qué es MVC?
**MVC (Modelo-Vista-Controlador)** es un patrón de arquitectura de software que **separa la aplicación en tres componentes** interconectados:

```
┌─────────────┐    ┌─────────────────┐    ┌─────────────┐
│   MODELO    │    │   CONTROLADOR   │    │    VISTA    │
│             │    │                 │    │             │
│  - Datos    │◄──►│  - Lógica de    │◄──►│  - Interfaz │
│  - Lógica   │    │    negocio      │    │  - Usuario  │
│  - Reglas   │    │  - Validaciones │    │  - UI/UX    │
└─────────────┘    └─────────────────┘    └─────────────┘
```

### Implementación en Nuestro Proyecto

#### **MODELOS** (`lib/models/`)
- **`retiro_model.dart`**: Define los tipos de retiro y sus reglas
- **`transaccion_model.dart`**: Maneja el registro de transacciones
- **`cajero_model.dart`**: Controla el estado del cajero y billetes

#### **CONTROLADORES** (`lib/controllers/`)
- **`retiro_controller.dart`**: Coordina toda la lógica de negocio

#### **VISTAS** (`lib/views/`)
- **`home_screen.dart`**: Pantalla principal
- **`retiro_nequi_screen.dart`**: Interfaz para retiros NEQUI
- **`retiro_ahorro_mano_screen.dart`**: Interfaz para Ahorro a la Mano
- **`retiro_cuenta_ahorro_screen.dart`**: Interfaz para Cuenta de Ahorros
- **`resultado_retiro_screen.dart`**: Muestra resultados de transacciones

### Ventajas del MVC en Este Proyecto
1. **Separación clara de responsabilidades**
2. **Código más mantenible y escalable**
3. **Facilita las pruebas unitarias**
4. **Permite trabajo en equipo eficiente**
5. **Reutilización de componentes**

---

## METODOLOGÍA DEL ACARREO

### Concepto Teórico
La **metodología del acarreo** es un algoritmo optimizado para **calcular la combinación de billetes** que entrega el monto solicitado, priorizando el uso de billetes pequeños cuando existen varias combinaciones posibles.

### Principio Matemático
```
Algoritmo de acarreo modificado:
1. Generar todas las combinaciones posibles de billetes para el monto solicitado.
2. Seleccionar la combinación que utilice la menor cantidad de billetes grandes (priorizando billetes pequeños).
3. Si hay varias combinaciones equivalentes, se escoge la que maximiza el uso de billetes pequeños.
```

### Implementación en Código
```dart
class CalculadorBilletes {
  /// Calcula los billetes necesarios para un monto usando el algoritmo del acarreo modificado
  static Map<int, int> calcularBilletes(int monto) {
    if (monto <= 0) return {};
    Map<int, int>? mejorCombinacion;
    int menorCantidadBilletesGrandes = double.maxFinite.toInt();
    // Generar todas las combinaciones posibles de billetes
    for (int cant100k = 0; cant100k <= monto ~/ 100000; cant100k++) {
      for (int cant50k = 0; cant50k <= monto ~/ 50000; cant50k++) {
        for (int cant20k = 0; cant20k <= monto ~/ 20000; cant20k++) {
          int montoRestante = monto - (cant100k * 100000 + cant50k * 50000 + cant20k * 20000);
          if (montoRestante < 0) continue;
          if (montoRestante % 10000 != 0) continue;
          int cant10k = montoRestante ~/ 10000;
          int totalBilletesGrandes = cant100k + cant50k + cant20k;
          // Preferir la combinación con menos billetes grandes (más pequeños)
          if (cant100k * 100000 + cant50k * 50000 + cant20k * 20000 + cant10k * 10000 == monto) {
            if (totalBilletesGrandes < menorCantidadBilletesGrandes) {
              menorCantidadBilletesGrandes = totalBilletesGrandes;
              mejorCombinacion = {
                if (cant100k > 0) 100000: cant100k,
                if (cant50k > 0) 50000: cant50k,
                if (cant20k > 0) 20000: cant20k,
                if (cant10k > 0) 10000: cant10k,
              };
            }
          }
        }
      }
    }
    return mejorCombinacion ?? {};
  }
}
```

### Ejemplo Práctico
**Monto a retirar: $40,000**

```
Combinaciones posibles:
1. 2×$20,000 = $40,000 (2 billetes grandes)
2. 1×$20,000 + 2×$10,000 = $40,000 (1 billete grande, 2 pequeños)

El sistema selecciona la segunda opción: 1×$20,000 + 2×$10,000
```

### Nueva Regla de Validación de Montos

**El monto a retirar es válido si y solo si se puede formar exactamente con billetes de $10,000, $20,000, $50,000, $100,000 (sin usar billetes de $5,000).**

- Ejemplo válido: $220,000 → 2×$100,000 + 1×$20,000
- Ejemplo inválido: $145,000 → No se puede formar con las denominaciones disponibles

**No se valida por múltiplos fijos por tipo de retiro.**
La validación es universal para los tres tipos de retiro.

**Si el monto no se puede formar exactamente, el sistema cancela el proceso y regresa al inicio.**

---

## ESTRUCTURA DEL PROYECTO

```
cajero_automatico/
│
├── lib/
│   ├── main.dart                    # Punto de entrada de la aplicación
│   │
│   ├── models/                      # CAPA DE MODELO
│   │   ├── cajero_model.dart       # Estado del cajero y billetes
│   │   ├── retiro_model.dart       # Tipos de retiro y validaciones
│   │   └── transaccion_model.dart  # Registro de transacciones
│   │
│   ├── controllers/                 # CAPA DE CONTROLADOR
│   │   └── retiro_controller.dart  # Lógica de negocio principal
│   │
│   ├── views/                       # CAPA DE VISTA
│   │   ├── home_screen.dart        # Pantalla principal
│   │   ├── retiro_nequi_screen.dart
│   │   ├── retiro_ahorro_mano_screen.dart
│   │   ├── retiro_cuenta_ahorro_screen.dart
│   │   └── resultado_retiro_screen.dart
│   │
│   ├── services/                    # SERVICIOS EXTERNOS
│   │   └── firebase_service.dart   # Integración con Firebase
│   │
│   └── utils/                       # UTILIDADES
│       └── validadores.dart        # Sistema de validaciones
│
├── android/                         # Configuración Android
├── ios/                            # Configuración iOS
├── test/                           # Pruebas unitarias
├── pubspec.yaml                    # Dependencias del proyecto
└── README.md                       # Documentación básica
```

---

## MODELOS DE DATOS

### 1. Modelo de Retiro (`retiro_model.dart`)

```dart
enum TipoRetiro {
  nequi,           // Retiros NEQUI (múltiplos de $10,000)
  ahorroMano,      // Ahorro a la Mano (múltiplos de $20,000)
  cuentaAhorros    // Cuenta de Ahorros (múltiplos de $50,000)
}

class Retiro {
  final int monto;
  final TipoRetiro tipo;
  final Map<int, int> billetes;
  final DateTime fechaHora;

  // Validación de montos según tipo
  bool esMontoValido() {
    switch (tipo) {
      case TipoRetiro.nequi:
        return monto % 10000 == 0 && monto >= 10000;
      case TipoRetiro.ahorroMano:
        return monto % 20000 == 0 && monto >= 20000;
      case TipoRetiro.cuentaAhorros:
        return monto % 50000 == 0 && monto >= 50000;
    }
  }
}
```

### 2. Modelo de Cajero (`cajero_model.dart`)

```dart
class CajeroAutomatico {
  Map<int, int> inventarioBilletes;
  int totalDisponible;

  // Verifica disponibilidad de billetes
  bool tieneEfectivoSuficiente(int monto) {
    return totalDisponible >= monto;
  }

  // Actualiza inventario después de un retiro
  void actualizarInventario(Map<int, int> billetesEntregados) {
    billetesEntregados.forEach((denominacion, cantidad) {
      inventarioBilletes[denominacion] =
        (inventarioBilletes[denominacion] ?? 0) - cantidad;
    });
    _recalcularTotal();
  }
}
```

### 3. Modelo de Transacción (`transaccion_model.dart`)

```dart
class Transaccion {
  final String id;
  final int monto;
  final TipoRetiro tipo;
  final Map<int, int> billetes;
  final DateTime fechaHora;
  final bool exitosa;

  // Genera un recibo formateado
  String generarRecibo() {
    return '''
    ═══════════════════════════════════
           CAJERO AUTOMÁTICO UPC
    ═══════════════════════════════════

    Fecha: ${DateFormat('dd/MM/yyyy').format(fechaHora)}
    Hora:  ${DateFormat('HH:mm:ss').format(fechaHora)}
    Tipo:  ${tipo.descripcion}

    MONTO RETIRADO: \$${NumberFormat('#,###').format(monto)}

    BILLETES ENTREGADOS:
    ${_formatearBilletes()}

    Estado: ${exitosa ? 'EXITOSA' : 'FALLIDA'}
    ═══════════════════════════════════
    ''';
  }
}
```

---

## CONTROLADORES

### RetiroController (`retiro_controller.dart`)

El controlador principal implementa el patrón **Provider** para gestión de estado:

```dart
class RetiroController extends ChangeNotifier {
  // Estados de la aplicación
  CajeroAutomatico cajero;
  bool cargando = false;
  String? error;

  // Servicios
  final FirebaseService _firebaseService = FirebaseService();
  final ValidadoresService _validadores = ValidadoresService();

  /// Procesa un retiro completo
  Future<Transaccion?> procesarRetiro({
    required int monto,
    required TipoRetiro tipo,
    Map<String, String>? datosAdicionales,
  }) async {

    // 1. Validar entrada
    String? errorValidacion = _validadores.validarRetiro(monto, tipo, datosAdicionales);
    if (errorValidacion != null) {
      _mostrarError(errorValidacion);
      return null;
    }

    // 2. Verificar disponibilidad
    if (!cajero.tieneEfectivoSuficiente(monto)) {
      _mostrarError('Efectivo insuficiente en el cajero');
      return null;
    }

    // 3. Calcular billetes usando metodología del acarreo
    Map<int, int> billetesCalculados = CalculadorBilletes.calcular(monto);

    // 4. Verificar disponibilidad específica de billetes
    if (!_verificarDisponibilidadBilletes(billetesCalculados)) {
      _mostrarError('No hay billetes suficientes para esta denominación');
      return null;
    }

    try {
      // 5. Ejecutar transacción
      _setCargando(true);

      // Actualizar inventario local
      cajero.actualizarInventario(billetesCalculados);

      // Crear transacción
      Transaccion transaccion = Transaccion(
        id: _generarId(),
        monto: monto,
        tipo: tipo,
        billetes: billetesCalculados,
        fechaHora: DateTime.now(),
        exitosa: true,
      );

      // Guardar en Firebase
      await _firebaseService.guardarTransaccion(transaccion);

      return transaccion;

    } catch (e) {
      _mostrarError('Error al procesar la transacción: $e');
      return null;
    } finally {
      _setCargando(false);
    }
  }
}
```

### Gestión de Estado con Provider

```dart
// En main.dart - Configuración del Provider
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (context) => RetiroController()..inicializar(),
    ),
  ],
  child: MaterialApp(...)
)

// En las vistas - Consumo del estado
Consumer<RetiroController>(
  builder: (context, controller, child) {
    if (controller.cargando) {
      return CircularProgressIndicator();
    }

    return Column(
      children: [
        if (controller.error != null)
          ErrorWidget(controller.error!),
        // ... resto de la UI
      ],
    );
  },
)
```

---

## VISTAS (UI)

### Estructura de Navegación

```
SplashScreen (Carga inicial)
     ↓
HomeScreen (Menú principal)
     ├─→ RetiroNequiScreen
     ├─→ RetiroAhorroManoScreen
     ├─→ RetiroCuentaAhorroScreen
     └─→ EstadisticasScreen
          ↓
    ResultadoRetiroScreen (Resultado final)
```

### Componentes UI Reutilizables

#### 1. Botón de Tipo de Retiro
```dart
Widget _buildTipoRetiroButton({
  required String titulo,
  required String descripcion,
  required IconData icono,
  required VoidCallback onPressed,
}) {
  return Card(
    child: InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icono, size: 50, color: Colors.blue[800]),
            SizedBox(height: 15),
            Text(titulo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(descripcion, textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}
```

#### 2. Campo de Entrada con Validación
```dart
Widget _buildMontoInput() {
  return TextFormField(
    controller: _montoController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      _MontoInputFormatter(), // Formato de moneda
    ],
    decoration: InputDecoration(
      labelText: 'Monto a retirar',
      prefixText: '\$ ',
      suffixIcon: Icon(Icons.monetization_on),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Ingrese un monto válido';
      }
      int monto = int.tryParse(value.replaceAll(',', '')) ?? 0;
      return _validadores.validarMonto(monto, widget.tipoRetiro);
    },
  );
}
```

#### 3. Display de Billetes Calculados
```dart
Widget _buildBilletesDisplay(Map<int, int> billetes) {
  return Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Billetes a entregar:',
               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ...billetes.entries.map((entry) =>
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${NumberFormat('#,###').format(entry.key)}'),
                  Text('${entry.value} billetes'),
                ],
              ),
            ),
          ).toList(),
        ],
      ),
    ),
  );
}
```

---

## SERVICIOS

### Servicio de Firebase (`lib/services/firebase_service.dart`)

Encapsula la lógica de autenticación, almacenamiento y consulta en Firestore:

- Autenticación anónima
- Guardado de transacciones (incluye reporte detallado)
- Guardado de retiros (incluye billetes entregados y datos relevantes)
- Guardado del estado del cajero
- Consulta de transacciones recientes y estadísticas

**Ejemplo de uso:**
```dart
// Guardar transacción con reporte detallado
await FirebaseService.guardarTransaccion(transaccion);

// Guardar retiro con billetes entregados
await FirebaseService.guardarRetiro(retiro);
```

**Estructura en Firestore:**
- Colección `transacciones`: cada documento incluye todos los datos de la transacción y el campo `reporteDetallado`.
- Colección `retiros`: cada documento incluye los billetes entregados, tipo de retiro, monto, fecha y demás datos relevantes.
          .fold(0, (a, b) => a + b);

      return {
        'totalTransacciones': totalTransacciones,
        'montoTotal': montoTotal,
        'promedioTransaccion': totalTransacciones > 0
            ? (montoTotal / totalTransacciones).round()
            : 0,
      };
    } catch (e) {
      print('Error al obtener estadísticas: $e');
      return {'error': 'No se pudieron cargar las estadísticas'};
    }
  }
}
```

### Sistema de Validaciones (`utils/validadores.dart`)

```dart
class ValidadoresService {

  /// Valida un retiro según su tipo y datos
  String? validarRetiro(
    int monto,
    TipoRetiro tipo,
    Map<String, String>? datosAdicionales
  ) {

    // Validación de monto básico
    if (monto <= 0) {
      return 'El monto debe ser mayor a cero';
    }

    // Validaciones específicas por tipo
    switch (tipo) {
      case TipoRetiro.nequi:
        return _validarRetiroNequi(monto, datosAdicionales);
      case TipoRetiro.ahorroMano:
        return _validarRetiroAhorroMano(monto, datosAdicionales);
      case TipoRetiro.cuentaAhorros:
        return _validarRetiroCuentaAhorros(monto, datosAdicionales);
    }
  }

  String? _validarRetiroNequi(int monto, Map<String, String>? datos) {
    // Múltiplos de $10,000
    if (monto % 10000 != 0) {
      return 'Los retiros NEQUI deben ser múltiplos de \$10,000';
    }

    // Monto máximo
    if (monto > 600000) {
      return 'El monto máximo para NEQUI es \$600,000';
    }

    // Validar clave temporal (4 dígitos)
    String? clave = datos?['claveTemporal'];
    if (clave == null || clave.length != 4 || !RegExp(r'^\d{4}$').hasMatch(clave)) {
      return 'La clave temporal debe tener exactamente 4 dígitos';
    }

    return null; // Válido
  }
}
```

---

## MANUAL DE USUARIO

### Navegación Principal

#### Pantalla de Inicio
1. **Espere** a que cargue la aplicación (pantalla azul con logo)
2. **Seleccione** el tipo de retiro deseado:
   - **NEQUI**: Retiros rápidos con clave temporal
   - **Ahorro a la Mano**: Retiros con vector de 11 dígitos específico
   - **Cuenta de Ahorros**: Retiros de cuenta tradicional

### Proceso de Retiro NEQUI

#### Paso 1: Ingreso de Datos
1. **Ingrese el monto** (múltiplos de $10,000)
2. **Digite la clave temporal** de 4 dígitos
3. **Presione "Continuar"**

#### Paso 2: Confirmación
1. **Revise** el monto y billetes calculados
2. **Confirme** la transacción
3. **Espere** el procesamiento

#### Paso 3: Resultado
1. **Reciba** los billetes mostrados en pantalla
2. **Guarde** su recibo digital
3. **Presione "Finalizar"**

### Reglas de Validación por Tipo

| Tipo de Retiro | Monto Mínimo | Monto Máximo | Datos Requeridos |
|----------------|--------------|--------------|------------------|
| NEQUI | $10,000 | $600,000 | Clave temporal (6 dígitos, visible 60s) |
| Ahorro a la Mano | $20,000 | $400,000 | Vector 11 dígitos (inicia 0/1, 2do=3) + Clave 4 dígitos oculta |
| Cuenta de Ahorros | $50,000 | $2,000,000 | Número de cuenta (11 dígitos) + Clave 4 dígitos oculta |

**Regla universal:** El monto debe poder formarse exactamente con billetes de $10,000, $20,000, $50,000, $100,000.

### Mensajes de Error Comunes

| Error | Causa | Solución |
|-------|-------|-----------|
| "Monto no válido para este tipo de retiro" | El monto no se puede formar con las denominaciones disponibles | Ajustar el monto para que se pueda entregar con billetes de $10,000, $20,000, $50,000, $100,000 |
| "Clave temporal inválida" | Clave no tiene 4 dígitos | Verificar la clave en NEQUI |
| "Efectivo insuficiente" | Cajero sin billetes | Intentar con un monto menor |
| "Error de conexión" | Problema de red/Firebase | Verificar conexión a internet |

---

## GUÍA DE INSTALACIÓN

### Prerrequisitos

#### 1. Herramientas de Desarrollo
- **Flutter SDK** (versión 3.0+)
- **Android Studio** o **VS Code**
- **Git** para control de versiones

#### 2. Configuración de Android
```bash
# Verificar instalación de Flutter
flutter doctor

# Verificar dispositivos disponibles
flutter devices
```

### Instalación Paso a Paso

#### 1. Clonar el Proyecto
```bash
git clone <repository-url>
cd cajero_automatico
```

#### 2. Instalar Dependencias
```bash
# Descargar dependencias de Flutter
flutter pub get

# Verificar que no hay errores
flutter analyze
```

#### 3. Configurar Firebase (Opcional)
```bash
# Si se requiere Firebase en producción:
# 1. Crear proyecto en Firebase Console
# 2. Descargar google-services.json
# 3. Colocar en android/app/
```

#### 4. Compilar y Ejecutar
```bash
# Compilar APK de depuración
flutter build apk --debug

# Ejecutar en dispositivo/emulador
flutter run
```

### Estructura de Dependencias

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter

  # Estado y arquitectura
  provider: ^6.1.2

  # Firebase
  firebase_core: ^3.15.2
  cloud_firestore: ^5.6.12
  firebase_auth: ^5.7.0

  # UI y utilidades
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---

## ANÁLISIS DE CÓDIGO

### Patrones de Diseño Implementados

#### 1. **Model-View-Controller (MVC)**
```dart
// Separación clara de responsabilidades
Model      → Manejo de datos y lógica de negocio
View       → Interfaz de usuario y experiencia
Controller → Coordinación entre modelo y vista
```

#### 2. **Provider Pattern**
```dart
// Gestión de estado reactivo
ChangeNotifierProvider → Notifica cambios automáticamente
Consumer → Escucha cambios y actualiza UI
notifyListeners() → Dispara actualizaciones
```

#### 3. **Strategy Pattern**
```dart
// Diferentes estrategias de validación por tipo de retiro
abstract class ValidacionStrategy {
  String? validar(int monto, Map<String, String>? datos);
}

class ValidacionNequi implements ValidacionStrategy { ... }
class ValidacionAhorroMano implements ValidacionStrategy { ... }
```

#### 4. **Factory Pattern**
```dart
// Creación de objetos específicos según tipo
class RetiroFactory {
  static Retiro crear(TipoRetiro tipo, int monto) {
    switch (tipo) {
      case TipoRetiro.nequi:
        return RetiroNequi(monto);
      case TipoRetiro.ahorroMano:
        return RetiroAhorroMano(monto);
      // ...
    }
  }
}
```

### Principios SOLID Aplicados

#### **S - Single Responsibility Principle**
```dart
// Cada clase tiene una responsabilidad específica
class CalculadorBilletes {      // Solo calcula billetes
class ValidadoresService {      // Solo valida datos
class FirebaseService {         // Solo maneja Firebase
```

#### **O - Open/Closed Principle**
```dart
// Extensible sin modificar código existente
abstract class TipoRetiro {
  String get descripcion;
  bool validarMonto(int monto);
}

class NuevoTipoRetiro extends TipoRetiro {
  // Extensión sin modificar clases existentes
}
```

#### **L - Liskov Substitution Principle**
```dart
// Las subclases pueden reemplazar a la clase base
List<TipoRetiro> tipos = [
  RetiroNequi(),
  RetiroAhorroMano(),
  RetiroCuentaAhorros(),
];
// Todos funcionan igual en el contexto
```

#### **I - Interface Segregation Principle**
```dart
// Interfaces específicas en lugar de una grande
abstract class ValidadorMonto { ... }
abstract class ValidadorDatos { ... }
abstract class GeneradorRecibo { ... }
```

#### **D - Dependency Inversion Principle**
```dart
// Depende de abstracciones, no de implementaciones concretas
class RetiroController {
  final DatabaseService _database; // Abstracción
  final ValidadorService _validator; // Abstracción
}
```

### Algoritmos Clave

#### 1. **Algoritmo de Acarreo (Greedy)**
```dart
static Map<int, int> calcular(int monto) {
  // Complejidad: O(n) donde n = cantidad de denominaciones
  // Espacio: O(n) para almacenar resultado

  Map<int, int> resultado = {};
  int montoRestante = monto;

  // Iteración sobre denominaciones ordenadas (mayor a menor)
  for (int denominacion in DENOMINACIONES) {
    if (montoRestante >= denominacion) {
      int cantidad = montoRestante ~/ denominacion; // División entera
      resultado[denominacion] = cantidad;
      montoRestante -= (cantidad * denominacion);
    }
  }

  return resultado;
}
```

**Análisis de complejidad:**
- **Tiempo**: O(n) - lineal respecto a las denominaciones
- **Espacio**: O(n) - almacena resultado para cada denominación usada
- **Optimalidad**: Garantiza la solución óptima para este conjunto de denominaciones

#### 2. **Validación en Cascada**
```dart
String? validarRetiro(int monto, TipoRetiro tipo, Map<String, String>? datos) {
  // Validación por etapas con short-circuit

  // 1. Validación básica
  if (monto <= 0) return 'Monto inválido';

  // 2. Validación específica por tipo
  String? errorTipo = _validarPorTipo(monto, tipo);
  if (errorTipo != null) return errorTipo;

  // 3. Validación de datos adicionales
  String? errorDatos = _validarDatos(datos, tipo);
  if (errorDatos != null) return errorDatos;

  return null; // Todo válido
}
```

### Manejo de Estados

```dart
class RetiroController extends ChangeNotifier {
  // Estados posibles del controlador
  enum EstadoRetiro {
    inicial,      // Estado inicial
    validando,    // Validando datos ingresados
    calculando,   // Calculando billetes
    procesando,   // Procesando transacción
    completado,   // Transacción exitosa
    error,        // Error en el proceso
  }

  EstadoRetiro _estado = EstadoRetiro.inicial;

  void _cambiarEstado(EstadoRetiro nuevoEstado) {
    _estado = nuevoEstado;
    notifyListeners(); // Notifica a todos los Consumer
  }
}
```

---

## CONCLUSIONES

### Logros Técnicos

#### 1. **Arquitectura Sólida**
- ✅ **MVC bien implementado** con separación clara de responsabilidades
- ✅ **Código modular y reutilizable** siguiendo principios SOLID
- ✅ **Gestión de estado eficiente** con Provider pattern
- ✅ **Estructura escalable** que permite agregar nuevos tipos de retiro

#### 2. **Algoritmos Optimizados**
- ✅ **Metodología del acarreo** implementada correctamente
- ✅ **Complejidad algorítmica óptima** O(n) para cálculo de billetes
- ✅ **Validaciones robustas** que previenen errores comunes
- ✅ **Manejo de errores comprehensive** en todas las capas

#### 3. **Experiencia de Usuario**
- ✅ **Interfaz intuitiva** siguiendo Material Design guidelines
- ✅ **Feedback inmediato** en validaciones y procesos
- ✅ **Navegación fluida** entre pantallas
- ✅ **Mensajes de error claros** y accionables

#### 4. **Integración Tecnológica**
- ✅ **Flutter + Firebase** funcionando correctamente
- ✅ **Persistencia de datos** en la nube
- ✅ **Compilación exitosa** para Android
- ✅ **Código documentado** y mantenible

### Aprendizajes Académicos

#### **Ingeniería de Software**
- Aplicación práctica del patrón **MVC** en un proyecto real
- Implementación de **principios SOLID** para código limpio
- Uso de **patrones de diseño** apropiados para cada problema
- **Documentación técnica** completa y estructurada

#### **Algoritmos y Estructuras de Datos**
- Implementación del **algoritmo greedy** para optimización
- Uso eficiente de **Map** y **List** para almacenamiento
- **Análisis de complejidad** temporal y espacial
- **Validaciones algorítmicas** para diferentes casos de uso

#### **Desarrollo Mobile**
- Framework **Flutter** para desarrollo multiplataforma
- Gestión de **estado reactivo** con Provider
- Integración con **servicios en la nube** (Firebase)
- **Compilación y deployment** de aplicaciones móviles

#### **Metodologías Financieras**
- **Metodología del acarreo** para optimización de billetes
- **Validaciones bancarias** específicas por producto
- **Cálculos financieros** automatizados y precisos
- **Trazabilidad de transacciones** para auditoría

### Posibles Mejoras Futuras

#### **Funcionalidades Adicionales**
1. **Autenticación biométrica** para mayor seguridad
2. **Modo offline** para funcionamiento sin internet
3. **Reportes y estadísticas** más detallados
4. **Notificaciones push** para transacciones
5. **Soporte para múltiples monedas**

#### **Optimizaciones Técnicas**
1. **Cache local** para mejor rendimiento
2. **Pruebas unitarias** más exhaustivas
3. **CI/CD pipeline** para deployment automático
4. **Monitoreo y logging** avanzado
5. **Optimización de imágenes** y recursos

#### **Escalabilidad**
1. **Microservicios** para backend distribuido
2. **Load balancing** para alta disponibilidad
3. **Base de datos** más robusta (PostgreSQL)
4. **APIs REST** bien documentadas
5. **Containerización** con Docker

---

### Reflexión Final

Este proyecto demuestra la **aplicación exitosa de conceptos teóricos** de ingeniería de software en un **contexto práctico y real**. La implementación del patrón MVC, junto con la metodología del acarreo, no solo cumple con los objetivos académicos sino que **produce una solución funcional y profesional**.

El código resultante es **mantenible, escalable y bien documentado**, características esenciales en el desarrollo de software profesional. La integración de tecnologías modernas como Flutter y Firebase prepara al estudiante para enfrentar **proyectos reales en la industria**.

**La metodología del acarreo**, implementada como algoritmo greedy, demuestra cómo los **conceptos matemáticos** se traducen en **soluciones computacionales eficientes**, un aspecto fundamental en el desarrollo de sistemas financieros.

---

**Fin de la Documentación Académica**
*Universidad Popular del César - Sistemas de Información Empresarial*
*Cajero Automático con Metodología del Acarreo - Proyecto Flutter + Firebase*
