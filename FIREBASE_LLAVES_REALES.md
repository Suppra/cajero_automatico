# 🔑 OBTENER LLAVES REALES DE FIREBASE

## ⚠️ **IMPORTANTE**

El archivo `firebase_options.dart` actual contiene **llaves temporales de ejemplo**. Para que Firebase funcione completamente, necesitas **reemplazarlas con las llaves reales** de tu proyecto.

---

## 🚀 **MÉTODO AUTOMÁTICO (RECOMENDADO)**

### **Paso 1: Instalar FlutterFire CLI**
```bash
# Instalar Flutter Fire CLI
dart pub global activate flutterfire_cli

# Verificar instalación
flutterfire --version
```

### **Paso 2: Configurar automáticamente**
```bash
# En el directorio del proyecto
cd "C:\Users\Crist\Cajero\cajero_automatico"

# Configurar Firebase (reemplazará firebase_options.dart)
flutterfire configure --project=cajero-automatico-upc
```

### **Paso 3: Seleccionar opciones**
1. **Proyecto:** Seleccionar `cajero-automatico-upc`
2. **Plataformas:** Solo seleccionar `android`
3. **Bundle ID:** Confirmar `com.universidadpopular.cajero_automatico`

**✅ Esto generará automáticamente las llaves reales**

---

## 🔧 **MÉTODO MANUAL (SI EL AUTOMÁTICO FALLA)**

### **Paso 1: Obtener llaves de Firebase Console**

1. Ve a: https://console.firebase.google.com/
2. Selecciona tu proyecto: `cajero-automatico-upc`
3. Ve a **"Configuración del proyecto"** (⚙️ arriba izquierda)
4. Selecciona la pestaña **"General"**
5. En la sección **"Tus apps"**, encuentra la app Android
6. Hacer clic en el **icono de configuración** de la app Android

### **Paso 2: Copiar configuración Android**

Encontrarás valores como:
```javascript
const firebaseConfig = {
  apiKey: "AIzaSyD...",           // ← Copiar este valor
  authDomain: "cajero-auto...",
  projectId: "cajero-automatico-upc",  // ← Copiar este valor
  storageBucket: "cajero-auto...",     // ← Copiar este valor
  messagingSenderId: "123456789",      // ← Copiar este valor
  appId: "1:123456789:android:...",    // ← Copiar este valor
};
```

### **Paso 3: Reemplazar en firebase_options.dart**

Editar el archivo `lib/firebase_options.dart`:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyD...tu-api-key-real...',           // ← Pegar aquí
  appId: '1:123456789:android:tu-app-id-real',      // ← Pegar aquí  
  messagingSenderId: '123456789',                   // ← Pegar aquí
  projectId: 'cajero-automatico-upc',              // ← Pegar aquí
  storageBucket: 'cajero-automatico-upc.appspot.com', // ← Pegar aquí
);
```

---

## 📱 **VERIFICAR google-services.json**

### **Descargar archivo correcto:**
1. En Firebase Console → **Configuración del proyecto**
2. Sección **"Tus apps"** → App Android
3. Hacer clic en **"Descargar google-services.json"**
4. **Reemplazar** el archivo existente en:
   ```
   android/app/google-services.json
   ```

### **Verificar contenido:**
El archivo debe tener estructura similar a:
```json
{
  "project_info": {
    "project_number": "123456789",
    "project_id": "cajero-automatico-upc",
    "storage_bucket": "cajero-automatico-upc.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:123456789:android:...",
        "android_client_info": {
          "package_name": "com.universidadpopular.cajero_automatico"
        }
      }
    }
  ]
}
```

---

## 🧪 **PROBAR LA CONFIGURACIÓN**

### **Paso 1: Limpiar proyecto**
```bash
flutter clean
flutter pub get
```

### **Paso 2: Compilar**
```bash
flutter build apk --debug
```

### **Paso 3: Ejecutar y verificar logs**
```bash
flutter run
```

**Buscar en los logs:**
- ✅ `"Firebase inicializado correctamente"`
- ❌ `"Error al inicializar Firebase"`

### **Paso 4: Verificar Firestore**
1. Hacer una transacción en la app
2. Ve a Firebase Console → **Firestore Database**
3. Verificar que aparezcan datos en `transacciones`

---

## 🚨 **TROUBLESHOOTING**

### **Error: "Firebase project not found"**
**Causa:** Llaves incorrectas o proyecto no existe
**Solución:**
1. Verificar que el proyecto existe en Firebase Console
2. Usar `flutterfire configure` para regenerar automáticamente

### **Error: "google-services.json not found"**
**Causa:** Archivo no está en la ubicación correcta
**Solución:**
1. Verificar que está en `android/app/google-services.json`
2. Re-descargar desde Firebase Console

### **Error: "API key not valid"**
**Causa:** API key copiada incorrectamente
**Solución:**
1. Copiar de nuevo desde Firebase Console
2. Verificar que no hay espacios extra

---

## ✅ **ESTADO ACTUAL**

### **Con llaves temporales:**
- ✅ **App compila** sin errores
- ✅ **Funciona offline** completamente  
- ❌ **No guarda en Firebase**
- ✅ **Listo para demo académico**

### **Con llaves reales:**
- ✅ **App compila** sin errores
- ✅ **Funciona offline** completamente
- ✅ **Guarda transacciones** en Firebase
- ✅ **Integración cloud** completa

---

## 🎯 **PARA TU PRESENTACIÓN ACADÉMICA**

### **Opción A: Solo Demo Local**
- Mantener llaves temporales
- App funciona 100% offline
- Mostrar algoritmos y validaciones
- **Firebase NO es necesario** para la presentación

### **Opción B: Demo con Firebase**
- Configurar llaves reales
- Mostrar persistencia en la nube
- **Valor agregado** para la presentación
- Demostrar integración cloud

---

## 📋 **COMANDOS RÁPIDOS**

```bash
# Configurar Firebase automáticamente
flutterfire configure

# Si no funciona, usar método manual:
# 1. Copiar llaves de Firebase Console
# 2. Pegar en firebase_options.dart
# 3. Descargar nuevo google-services.json
# 4. Compilar y probar

# Verificar funcionamiento
flutter clean && flutter pub get && flutter run
```

---

**¡Con estas instrucciones podrás configurar Firebase completamente! 🔥**

*Nota: Si tienes dudas, el método automático con `flutterfire configure` es el más confiable.*

---

*Universidad Popular del César - Configuración Firebase Real*  
*Septiembre 15, 2025*