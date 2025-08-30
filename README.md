# 🧠 MindMate  

![Estado](https://img.shields.io/badge/estado-en%20desarrollo-yellow)  
![Flutter](https://img.shields.io/badge/flutter-3.24-02569B?logo=flutter)  
![Firebase](https://img.shields.io/badge/firebase-integrado-FFCA28?logo=firebase)  
![Contribuciones](https://img.shields.io/badge/contribuciones-bienvenidas-brightgreen)  
![Licencia](https://img.shields.io/badge/licencia-MIT-blue)  



## 🌱 ¿Qué es MindMate?

**MindMate** es una aplicación móvil **gamificada** diseñada para ayudarte a **gestionar la ansiedad**, mejorar tu **bienestar emocional** y progresar de forma divertida y consciente.  
Está construida en **Flutter + Firebase**, con un enfoque modular y escalable.

---

## ✨ Características principales

✅ **Técnicas rápidas** para aliviar ataques de ansiedad  
🎯 **Retos diarios** que refuerzan hábitos saludables  
🧩 **Ejercicios interactivos** (respiración, mindfulness, journaling)  
🏆 **Sistema de logros** desbloqueables con tu progreso  
📈 **Seguimiento emocional** y evolución personal  
🎧 **Sonidos relajantes y motivacionales**  
🤝 **Comunidad futura** (compartir mejoras y recibir apoyo)  
🔒 **Privacidad total y anonimato garantizado**  

---

## 🚀 Estado del proyecto

⚠️ Proyecto en **desarrollo activo**.  
Actualmente incluye:  

- ✅ **Arquitectura inicial con Flutter + Firebase**  
- ✅ **Sistema de rutas (GoRouter)**  
- ✅ **Splash Screen y Welcome Screen**  
- ✅ **Pantallas de login y registro avanzadas**  
- ✅ **Temas claro y oscuro personalizados**  
- 🚧 **Flujo de registro paso a paso con Riverpod** (en progreso)  
- 🚧 **Ejercicios y sonidos cargados desde Firestore + Storage**  

---

## 🛠️ Stack Tecnológico

| Tecnología   | Rol |
|--------------|------------------------------------------------|
| **Flutter**  | Desarrollo multiplataforma (iOS/Android) |
| **Firebase** | Backend (Firestore, Auth, Storage) |
| **Riverpod** | Gestión de estado y lógica reactiva |
| **GoRouter** | Navegación y control de rutas |
| **Cloud Storage** | Almacenamiento de sonidos y archivos |
| **Firestore DB** | Base de datos en tiempo real |

---

## 🧱 Arquitectura del Proyecto

```bash
lib/
├── core/            # Colores, temas, constantes, utils
├── router/          # Archivo de rutas (app_router.dart)
├── features/        # Funcionalidades separadas por módulo
│   ├── splash/      # SplashScreen
│   ├── auth/        # Login, Registro, Bienvenida
│   ├── home/        # Pantalla principal del usuario
│   ├── exercises/   # Ejercicios interactivos
│   ├── sounds/      # Reproductor de sonidos relajantes
│   ├── profile/     # Perfil del usuario y progreso
│   └── achievements/ # Logros desbloqueables
````

---

## 📥 Instalación y ejecución

Clona el proyecto con:

```bash
# SSH
git clone git@github.com:Pitcher755/MindMate.git

# HTTPS
git clone https://github.com/Pitcher755/MindMate.git
```

Instala las dependencias y corre la app:

```bash
flutter pub get
flutter run
```

---

## 👨‍💻 Contribuciones

Las contribuciones son **bienvenidas** ✨
Si quieres aportar:

1. Haz un **fork** del repo
2. Crea una rama: `git checkout -b feature/nueva-funcionalidad`
3. Haz un commit: `git commit -m "Añadida nueva funcionalidad"`
4. Haz un push: `git push origin feature/nueva-funcionalidad`
5. Crea un **Pull Request** 🚀

---

## 📄 Licencia

Este proyecto está bajo la licencia **MIT**.
Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

# 📘 Documento Técnico

### 🎯 Objetivo del proyecto

Desarrollar una app que funcione como **gestor emocional** y ayude a **manejar la ansiedad** con recursos inmediatos, un enfoque gamificado y seguimiento personal.

---

### 🏛️ Arquitectura Técnica

* **Frontend:** Flutter (arquitectura modular con `features/`)
* **Backend:** Firebase (Auth, Firestore, Storage)
* **Gestión de Estado:** Riverpod (antes GetX considerado)
* **Rutas:** GoRouter
* **Temas:** Soporte para tema claro y oscuro

---

### 📂 Base de datos (Firestore)

Colecciones principales:

* **users/** → información del usuario, perfil, objetivos, progreso
* **exercises/** → técnicas de respiración, mindfulness, journaling
* **challenges/** → retos diarios con metas y recompensas
* **sounds/** → enlaces a Firebase Storage con categorías de audio
* **achievements/** → logros y desbloqueables

---

### 🔑 Autenticación

* Registro con **email/contraseña**
* Opción de login con **Google**
* Flujo de registro paso a paso para personalizar experiencia

---

### 🎮 Gamificación

* Sistema de **retos diarios**
* **Logros** al desbloquear hitos personales
* **Progresión visual** con seguimiento de estado de ánimo

---

### 🎧 Recursos multimedia

* Sonidos almacenados en Firebase Storage (`sounds/`)
* JSON de indexación con enlaces organizados por categorías

---

### 🔮 Roadmap

* [x] Splash + Welcome
* [x] Registro con flujo avanzado
* [ ] Pantalla principal con feed de recursos
* [ ] Ejercicios interactivos conectados a Firestore
* [ ] Reproductor de sonidos con categorías
* [ ] Comunidad y red social interna
* [ ] Publicación en Play Store y App Store

---

🚀 **MindMate: tu compañero emocional en el bolsillo.**



