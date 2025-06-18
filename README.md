# 🧠 MindMate

**MindMate** es una aplicación móvil gamificada para ayudarte a **gestionar la ansiedad**, mejorar tu bienestar emocional y progresar de forma divertida y consciente.  
Actualmente se encuentra en desarrollo como parte de un proyecto completo multiplataforma con Flutter + Firebase.

---

## 🚀 Estado del proyecto

> ⚠️ Proyecto en desarrollo activo.  
> Este repositorio contiene la configuración inicial del proyecto **MindMate**, incluyendo la arquitectura, el sistema de rutas, la Splash Screen y la pantalla de bienvenida.

---

## 🧘 ¿Qué es MindMate?

**MindMate** es tu compañero emocional. La app te ofrece:

- ✅ Técnicas rápidas para aliviar ataques de ansiedad
- 🎯 Retos diarios para reforzar hábitos saludables
- 🧩 Ejercicios interactivos de respiración, mindfulness y journaling
- 🏆 Sistema de logros que desbloqueas con tu progreso
- 📈 Seguimiento emocional y evolución personal
- 🎧 Sonidos relajantes y motivacionales
- 🤝 Comunidad (futura fase) para compartir mejoras y recibir apoyo
- 🔒 Total privacidad y anonimato

---

## 🛠️ Stack Tecnológico

| Tecnología     | Rol                                |
|----------------|-------------------------------------|
| Flutter        | Desarrollo de la app multiplataforma (iOS/Android) |
| Firebase       | Backend (Firestore, Auth, Storage) |
| GetX o GoRouter| Gestión de estado y navegación      |
| Cloud Storage  | Almacenamiento de sonidos y archivos |
| Firestore DB   | Base de datos en tiempo real        |

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
