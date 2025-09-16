# 🔥 CONFIGURACIÓN FIREBASE - PASO A PASO

## 📋 **REQUISITOS PREVIOS**

### ✅ **Verificar que tienes:**
- [x] Proyecto Flutter del cajero automático
- [x] Cuenta de Google (Gmail)
- [x] Acceso a internet
- [x] Android Studio instalado
- [x] Flutter CLI funcionando

---

## 🚀 **PASO 1: CREAR PROYECTO EN FIREBASE CONSOLE**

### **1.1 Acceder a Firebase Console**
1. Ve a: https://console.firebase.google.com/
2. **Iniciar sesión** con tu cuenta de Google
3. Hacer clic en **"Agregar proyecto"** o **"Create a project"**

### **1.2 Configurar Proyecto**
1. **Nombre del proyecto:** `cajero-automatico-upc`
2. **Identificador del proyecto:** Se genera automáticamente
3. Hacer clic en **"Continuar"**

### **1.3 Google Analytics (Opcional)**
1. **Activar Google Analytics:** ✅ (Recomendado)
2. **Seleccionar cuenta Analytics:** Default Account for Firebase
3. Hacer clic en **"Crear proyecto"**
4. **Esperar** que se complete la creación (2-3 minutos)

---

## 📱 **PASO 2: CONFIGURAR APLICACIÓN ANDROID**

### **2.1 Agregar App Android**
1. En la consola Firebase, hacer clic en el **icono de Android** 🤖
2. **Nombre del paquete Android:** `com.universidadpopular.cajero_automatico`
3. **Alias de la app:** `Cajero Automático UPC`
4. **SHA-1 (Opcional):** Dejar vacío por ahora
5. Hacer clic en **"Registrar app"**

### **2.2 Descargar google-services.json**
1. **Descargar** el archivo `google-services.json`
2. **Guardar** el archivo en tu computadora (Escritorio temporal)
3. **NO CERRAR** la ventana todavía

---

## 📂 **PASO 3: INTEGRAR FIREBASE EN EL PROYECTO**

### **3.1 Colocar google-services.json**
1. **Copiar** el archivo `google-services.json` descargado
2. **Pegar** en la carpeta:
   ```
   C:\Users\Crist\Cajero\cajero_automatico\android\app\
   ```
3. **Verificar** que está en la ubicación correcta:
   ```
   android/
   └── app/
       ├── build.gradle.kts
       └── google-services.json  ← Debe estar aquí
   ```

### **3.2 Configurar build.gradle del proyecto**
Abrir: `android/build.gradle.kts` y verificar que contenga:

```kotlin
plugins {
    id("com.android.application") version "8.1.4" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
    id("com.google.gms.google-services") version "4.4.0" apply false
}
```

### **3.3 Configurar build.gradle de la app**
Abrir: `android/app/build.gradle.kts` y verificar que contenga:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // ← Esta línea debe estar
}
```

---

## 🔧 **PASO 4: INSTALAR FIREBASE CLI**

### **4.1 Instalar Firebase CLI**
```bash
# Opción 1: Con npm (si tienes Node.js)
npm install -g firebase-tools

# Opción 2: Descargar desde web
# Ve a: https://firebase.google.com/docs/cli#install_the_firebase_cli
```

### **4.2 Iniciar sesión en Firebase**
```bash
firebase login
```
1. Se abrirá el navegador
2. **Iniciar sesión** con tu cuenta de Google
3. **Permitir** acceso a Firebase CLI
4. Regresar a la terminal

### **4.3 Verificar instalación**
```bash
firebase projects:list
```
Debe mostrar tu proyecto `cajero-automatico-upc`

---

## ⚡ **PASO 5: CONFIGURAR FLUTTERFIRE**

### **5.1 Instalar FlutterFire CLI**
```bash
dart pub global activate flutterfire_cli
```

### **5.2 Configurar FlutterFire en el proyecto**
```bash
# Navegar al directorio del proyecto
cd "C:\Users\Crist\Cajero\cajero_automatico"

# Configurar Firebase
flutterfire configure
```

### **5.3 Seleccionar opciones:**
1. **Seleccionar proyecto:** `cajero-automatico-upc`
2. **Plataformas:** Seleccionar `android` (usar espacios para seleccionar)
3. **Bundle ID Android:** Confirmar `com.universidadpopular.cajero_automatico`
4. **Presionar Enter** para continuar

---

## 📄 **PASO 6: VERIFICAR ARCHIVOS GENERADOS**

### **6.1 firebase_options.dart**
Verificar que se creó: `lib/firebase_options.dart`

### **6.2 Actualizar main.dart**
El archivo ya está configurado, pero verificar que contenga:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const CajeroAutomaticoApp());
}
```

---

## 🗄️ **PASO 7: CONFIGURAR FIRESTORE**

### **7.1 Activar Firestore en Console**
1. En Firebase Console, ir a **"Firestore Database"**
2. Hacer clic en **"Crear base de datos"**
3. **Modo:** Seleccionar **"Empezar en modo de prueba"**
4. **Ubicación:** Seleccionar `us-central1` (más cercana)
5. Hacer clic en **"Listo"**

### **7.2 Configurar reglas de seguridad (Temporal)**
En la pestaña **"Reglas"** de Firestore, usar:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir lectura y escritura para desarrollo
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**⚠️ IMPORTANTE:** Estas reglas son SOLO para desarrollo. Para producción debes usar reglas más estrictas.

---

## 🔐 **PASO 8: CONFIGURAR AUTHENTICATION (Opcional)**

### **8.1 Activar Authentication**
1. En Firebase Console, ir a **"Authentication"**
2. Hacer clic en **"Comenzar"**
3. En la pestaña **"Sign-in method"**
4. **Habilitar "Anónimo"** para pruebas básicas

---

## 🧪 **PASO 9: PROBAR LA CONFIGURACIÓN**

### **9.1 Verificar dependencias**
```bash
flutter pub get
```

### **9.2 Compilar la aplicación**
```bash
flutter build apk --debug
```

### **9.3 Ejecutar y probar**
```bash
flutter run
```

### **9.4 Verificar en Firebase Console**
1. Ve a **"Firestore Database"**
2. Realiza una transacción en la app
3. Verifica que aparezcan datos en la colección `transacciones`

---

## 📊 **PASO 10: VERIFICAR ESTRUCTURA DE DATOS**

### **10.1 Colecciones esperadas:**

#### **transacciones/**
```json
{
  "id": "auto-generated-id",
  "monto": 120000,
  "tipo": "nequi", 
  "billetes": {
    "100000": 1,
    "20000": 1
  },
  "fechaHora": "2025-09-15T18:30:00Z",
  "exitosa": true,
  "datosAdicionales": {
    "claveTemporal": "1234"
  }
}
```

#### **cajero_estado/**
```json
{
  "inventario": {
    "100000": 50,
    "50000": 100,
    "20000": 200,
    "10000": 300,
    "5000": 400
  },
  "ultimaActualizacion": "2025-09-15T18:30:00Z"
}
```

---

## 🔧 **TROUBLESHOOTING**

### **❌ Error: "google-services.json not found"**
**Solución:**
- Verificar que `google-services.json` está en `android/app/`
- Ejecutar `flutter clean && flutter pub get`

### **❌ Error: "Firebase project not configured"**
**Solución:**
```bash
flutterfire configure --force
```

### **❌ Error: "Build failed"**
**Solución:**
1. Verificar que `google-services` plugin está en `build.gradle`
2. Limpiar proyecto: `flutter clean`
3. Reinstalar dependencias: `flutter pub get`

### **❌ Error: "Permission denied" en Firestore**
**Solución:**
- Verificar reglas de Firestore (Paso 7.2)
- Asegurar que están en "modo de prueba"

---

## ✅ **VERIFICACIÓN FINAL**

### **Checklist de configuración completa:**
- [x] Proyecto creado en Firebase Console
- [x] App Android registrada
- [x] `google-services.json` en `android/app/`
- [x] `firebase_options.dart` generado
- [x] Firestore activado
- [x] App compila sin errores
- [x] Datos se guardan en Firestore

---

## 🎯 **RESULTADO ESPERADO**

Después de completar todos los pasos:

1. ✅ **Firebase está configurado** correctamente
2. ✅ **Transacciones se guardan** en Firestore
3. ✅ **App funciona** con y sin internet
4. ✅ **Datos persisten** en la nube
5. ✅ **Listo para presentación** académica

---

## 📱 **COMANDOS RÁPIDOS PARA EJECUTAR**

```bash
# 1. Ir al directorio del proyecto
cd "C:\Users\Crist\Cajero\cajero_automatico"

# 2. Instalar dependencias
flutter pub get

# 3. Limpiar proyecto
flutter clean

# 4. Compilar
flutter build apk --debug

# 5. Ejecutar
flutter run
```

---

## 🚨 **IMPORTANTE PARA PRESENTACIÓN**

### **Para Demo Académico:**
- ✅ Firebase funciona pero **NO ES OBLIGATORIO**
- ✅ App funciona **offline** completamente
- ✅ Validaciones y algoritmos **no dependen** de Firebase
- ✅ Firebase es **EXTRA** para mostrar integración cloud

### **Si Firebase falla:**
- La app **sigue funcionando** normalmente
- Todas las **validaciones** y **cálculos** son locales
- Solo se perdería el **guardado en la nube**

---

**¡Con esta guía tendrás Firebase completamente configurado! 🔥🚀**

*Universidad Popular del César - Cajero Automático*  
*Configuración Firebase - Septiembre 15, 2025*