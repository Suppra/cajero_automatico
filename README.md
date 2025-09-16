# 🏦 Cajero Automático - Universidad Popular del César

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Integrated-orange.svg)](https://firebase.google.com/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-green.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-Academic-red.svg)](#)

## 📖 Descripción del Proyecto

Sistema completo de **cajero automático** desarrollado en **Flutter** con integración a **Firebase**, implementando el patrón **MVC (Modelo-Vista-Controlador)** y la **metodología del acarreo** para cálculo optimizado de billetes.

### 🎯 Características Principales

- ✅ **3 tipos de retiros** con validaciones específicas
- ✅ **Arquitectura MVC** bien definida y documentada
- ✅ **Metodología del acarreo** para optimización de billetes
- ✅ **Interfaz moderna** con Material Design
- ✅ **Validaciones robustas** para cada tipo de transacción
- ✅ **Integración Firebase** para persistencia de datos
- ✅ **Código académico** completamente documentado

## 🏛️ Arquitectura MVC

```
┌─────────────┐    ┌─────────────────┐    ┌─────────────┐
│   MODELO    │    │   CONTROLADOR   │    │    VISTA    │
│             │    │                 │    │             │
│  - Datos    │◄──►│  - Lógica de    │◄──►│  - Interfaz │
│  - Lógica   │    │    negocio      │    │  - Usuario  │
│  - Reglas   │    │  - Validaciones │    │  - UI/UX    │
└─────────────┘    └─────────────────┘    └─────────────┘
```

## 💰 Tipos de Retiro Soportados

| Tipo | Múltiplo | Monto Mínimo | Monto Máximo | Validación Especial |
|------|----------|--------------|--------------|---------------------|
| **NEQUI** | $10,000 | $10,000 | $600,000 | Clave temporal (4 dígitos) |
| **Ahorro a la Mano** | $20,000 | $20,000 | $400,000 | Documento de identidad |
| **Cuenta de Ahorros** | $50,000 | $50,000 | $2,000,000 | Número de cuenta + PIN |

## 🧮 Metodología del Acarreo

Algoritmo **greedy** que calcula la **menor cantidad de billetes** necesarios:

```dart
// Ejemplo: Retiro de $170,000
1. $100,000 → 1 billete  (Restante: $70,000)
2. $50,000  → 1 billete  (Restante: $20,000)  
3. $20,000  → 1 billete  (Restante: $0)

Resultado: 3 billetes total
```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada
├── models/                      # 📊 MODELOS
│   ├── cajero_model.dart       # Estado del cajero
│   ├── retiro_model.dart       # Tipos de retiro
│   └── transaccion_model.dart  # Registro de transacciones
├── controllers/                 # 🎮 CONTROLADORES  
│   └── retiro_controller.dart  # Lógica principal
├── views/                       # 🎨 VISTAS
│   ├── home_screen.dart        # Pantalla principal
│   ├── retiro_nequi_screen.dart
│   ├── retiro_ahorro_mano_screen.dart
│   ├── retiro_cuenta_ahorro_screen.dart
│   └── resultado_retiro_screen.dart
├── services/                    # 🔧 SERVICIOS
│   └── firebase_service.dart   # Integración Firebase
└── utils/                       # 🛠️ UTILIDADES
    └── validadores.dart        # Sistema de validaciones
```

## 🚀 Instalación y Ejecución

### Prerrequisitos

- **Flutter SDK** 3.0+
- **Android Studio** o **VS Code**
- **Git**

### Pasos de Instalación

```bash
# 1. Clonar el repositorio
git clone <repository-url>
cd cajero_automatico

# 2. Instalar dependencias
flutter pub get

# 3. Verificar configuración
flutter doctor

# 4. Ejecutar la aplicación
flutter run

# 5. Compilar APK (opcional)
flutter build apk --debug
```

## 🔥 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Gestión de estado
  provider: ^6.1.2
  
  # Firebase
  firebase_core: ^3.15.2
  cloud_firestore: ^5.6.12
  firebase_auth: ^5.7.0
  
  # Utilidades
  intl: ^0.19.0
```

## 📱 Capturas de Pantalla

### Pantalla Principal
- Selección de tipo de retiro
- Información del cajero
- Navegación intuitiva

### Proceso de Retiro
- Formularios validados
- Cálculo automático de billetes  
- Confirmación de transacción

### Resultado Final
- Recibo detallado
- Billetes entregados
- Estado de la transacción

## 🧪 Casos de Uso de Ejemplo

### Retiro NEQUI - $120,000
```
Entrada: Monto = $120,000, Clave = "1234"
Validación: ✅ Múltiplo de $10,000
Cálculo: 1×$100,000 + 1×$20,000 = 2 billetes
Resultado: Transacción exitosa
```

### Retiro Ahorro a la Mano - $80,000  
```
Entrada: Monto = $80,000, CC = "12345678"
Validación: ✅ Múltiplo de $20,000
Cálculo: 1×$50,000 + 1×$20,000 + 1×$10,000 = 3 billetes
Resultado: Transacción exitosa
```

## 🎓 Objetivos Académicos

### Conceptos Implementados
- **Patrones de Diseño**: MVC, Provider, Factory, Strategy
- **Principios SOLID**: Separación de responsabilidades
- **Algoritmos**: Greedy para optimización
- **Validaciones**: Cascada con short-circuit
- **Gestión de Estado**: Reactivo con notificaciones

### Competencias Desarrolladas
- Desarrollo móvil multiplataforma
- Integración con servicios en la nube
- Implementación de algoritmos financieros
- Documentación técnica profesional
- Testing y validación de software

## 📚 Documentación Completa

Consulta el archivo [`DOCUMENTACION_ACADEMICA.md`](./DOCUMENTACION_ACADEMICA.md) para:

- 📐 **Análisis detallado de arquitectura MVC**
- 🧮 **Explicación matemática de la metodología del acarreo**  
- 💻 **Análisis línea por línea del código**
- 📖 **Manual de usuario completo**
- 🔧 **Guía de instalación paso a paso**
- 🎯 **Conclusiones y aprendizajes académicos**

## 🤝 Contribuciones

Este es un **proyecto académico** de la **Universidad Popular del César**. Las contribuciones están limitadas a:

- Corrección de errores documentados
- Mejoras en la documentación  
- Optimizaciones de rendimiento
- Casos de prueba adicionales

## 👨‍💻 Autor

**Estudiante de Sistemas de Información Empresarial**  
Universidad Popular del César  
Proyecto Académico - Cajero Automático

## 📄 Licencia

Este proyecto tiene fines **académicos y educativos**. No está destinado para uso comercial.

---

### 🎯 Estado del Proyecto

- ✅ **Compilación exitosa**: APK generado correctamente
- ✅ **Funcionalidad completa**: Todos los tipos de retiro implementados
- ✅ **Documentación completa**: Guías técnicas y de usuario
- ✅ **Código limpio**: Siguiendo mejores prácticas
- ✅ **Arquitectura sólida**: MVC bien implementado

**¡Listo para presentación académica! 🎓**ico

Cajero Automático - Proyecto Académico UPC

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
