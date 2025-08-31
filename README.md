
# 🧠 MindMate

![Estado](https://img.shields.io/badge/estado-en%20desarrollo-yellow)
![Flutter](https://img.shields.io/badge/Flutter-UI%20Toolkit-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase)
![Riverpod](https://img.shields.io/badge/State-Riverpod-5E3BFF)
![GoRouter](https://img.shields.io/badge/Routing-GoRouter-00A8E8)
![iOS/Android](https://img.shields.io/badge/plataformas-iOS%20%7C%20Android-black)
![Contribuciones](https://img.shields.io/badge/contribuciones-bienvenidas-brightgreen)
![Licencia](https://img.shields.io/badge/licencia-MIT-blue)

---

## 🌱 ¿Qué es MindMate?

**MindMate** es una app móvil **gamificada** para ayudarte a **gestionar la ansiedad**, mejorar tu **bienestar emocional** y seguir tu **evolución** de forma clara y motivadora.  
Construida con **Flutter + Firebase**, y un enfoque modular con **Riverpod** para estado y **GoRouter** para navegación.

---

## ✨ Funcionalidad actual (MVP en curso)

- ✅ **Splash** y **Welcome**  
- ✅ **Autenticación** (pantallas de login/registro, Google button, recuperación de contraseña)  
- ✅ **Home** con **MoodHistoryPreview** y **frases motivacionales** (providers y services reales)  
- ✅ **Seguimiento emocional**:
  - **MoodHistoryFull** (historial completo con filtros: Todo / Semanal / Rango)
  - **MoodWeeklyChart** (últimos **7 días**, **barras por mood** + **emoji centrado arriba de cada barra**)
  - **Toggle fijo** para alternar **Gráfico ↔ Timeline semanal**
  - **Fechas localizadas** según idioma del dispositivo
  - **Gráfico con fondo liso** y altura ajustada (espacio seguro bajo la AppBar)
- ✅ **Theming** (colores y temas personalizados)
- ✅ **Arquitectura modular por features**
- ✅ **Datos reales desde Firebase** para historial y citas (vía `services` + `providers`)

> ⚠️ La vista semanal es la que muestra gráfico/Timeline. El resto del historial se presenta en lista (para no saturar el layout).

---

## 🚧 Roadmap breve (priorizando MVP)

- [ ] Añadir **estadísticas básicas** (promedio semanal, tendencia)  
- [ ] **Accesibilidad y UX** (mejor contraste, tamaños, feedback táctil)  
- [ ] **Offline first** / caché de últimos datos  
- [ ] **Instrumentación** (logs de errores, analítica mínima)  
- [ ] **Tests** (unit, widget, golden)  

---

## 🧱 Estructura del proyecto

```bash
lib
├─ core
│  ├─ app_colors.dart
│  ├─ app_theme.dart
│  ├─ constants.dart
│  └─ utils.dart
├─ features
│  ├─ auth
│  │  ├─ controllers
│  │  │  └─ auth_controller.dart
│  │  ├─ screens
│  │  │  ├─ login_screen.dart
│  │  │  ├─ register_screen.dart
│  │  │  └─ welcome_screen.dart
│  │  ├─ services
│  │  │  └─ auth_service.dart
│  │  └─ widgets
│  │     ├─ forgot_password_dialog.dart
│  │     ├─ google_loading_button.dart
│  │     ├─ login_form.dart
│  │     ├─ register_email_view.dart
│  │     ├─ register_goals_view.dart
│  │     └─ register_profile_view.dart
│  ├─ home
│  │  ├─ provider
│  │  │  ├─ mood_history_provider.dart
│  │  │  └─ mood_quote_provider.dart
│  │  ├─ screen
│  │  │  └─ home_screen.dart
│  │  ├─ services
│  │  │  ├─ mood_history_service.dart
│  │  │  └─ mood_quote_service.dart
│  │  └─ widgets
│  │     ├─ header_widget.dart
│  │     ├─ mood_card.dart
│  │     ├─ mood_history_full.dart
│  │     ├─ mood_history_preview.dart
│  │     ├─ mood_toggle_button.dart
│  │     ├─ mood_weekly_chart.dart
│  │     └─ show_daily_mood_dialog.dart
│  └─ splash
│     └─ splash_screen.dart
├─ models
│  ├─ mood_quote_model.dart
│  └─ user_model.dart
├─ router
│  └─ app_router.dart
└─ main.dart
````

---

## 📥 Instalación rápida

```bash
# Clona el repo
git clone https://github.com/Pitcher755/MindMate.git
cd MindMate

# Dependencias
flutter pub get

# Ejecuta
flutter run
```

### 🔧 Configuración de Firebase (resumen)

1. Crea el proyecto en Firebase (iOS/Android).
2. Activa **Authentication** (email/contraseña y Google si aplica).
3. Crea/Configura **Firestore** y **Storage**.
4. Descarga e incorpora `google-services.json` (Android) y `GoogleService-Info.plist` (iOS).
5. (Opcional) Usa `flutterfire configure` si gestionas `firebase_options.dart`.

> Las colecciones exactas y reglas pueden variar según tu entorno. Revisa `mood_history_service.dart` y `mood_quote_service.dart` para tu modelo de datos actual.

---

## 🧘 Funciones clave (detalle)

* **MoodWeeklyChart**

  * Últimos **7 días** (de hoy hacia atrás)
  * **Barras coloreadas** por mood
  * **Emoji centrado** justo encima de cada barra (overlay calculado por `LayoutBuilder`)
  * **Fondo liso**, sin cuadrícula, con **espacio bajo AppBar**
  * **Toggle fijo** (parte inferior) para alternar a **Timeline** semanal
  * **Fechas localizadas** via `Intl` + `Localizations.localeOf(context)`

* **MoodHistoryFull**

  * Filtros: **Todo**, **Semanal** (usa `MoodWeeklyChart`) y **Rango**
  * **Timeline** con línea central y tarjetas alternas
  * **Datos reales** desde Firebase por medio de `mood_history_provider.dart`

* **Citas motivacionales**

  * Provider + Service (`mood_quote_provider.dart`, `mood_quote_service.dart`)

---

## 👨‍💻 Contribuciones

¡Contribuye sin miedo!

1. Fork
2. Rama: `feature/tu-feature`
3. Commits pequeños y claros
4. PR con explicación breve

**Estilo de código**

* Lints en `analysis_options.yaml`
* Formatea con `flutter format .`
* Revisa con `flutter analyze`

---

## 📄 Licencia

Este proyecto usa **GPL v3.0**. Archivo `LICENSE` en el repo.

---

# 📘 Documento Técnico

## 1. Objetivo

App móvil para **gestión emocional** y **seguimiento de estado de ánimo**, con **Firebase** como backend y **Flutter** (Riverpod + GoRouter) en el frontend.

## 2. Arquitectura

* **Presentación**: Widgets por feature (módulos en `features/`)
* **Estado**: **Riverpod** (`provider/`) con `AsyncValue` para cargas/errores
* **Datos**: `services/` (Firestore/Storage/Auth)
* **Navegación**: **GoRouter** (`router/app_router.dart`)
* **Theming**: `core/app_theme.dart`, `core/app_colors.dart`
* **Utils/constantes**: en `core/`

```
UI (widgets) → Providers (Riverpod) → Services (Firebase) → Firestore/Auth/Storage
```

## 3. Flujo: Historial de ánimo

* `mood_history_service.dart`: lee/escribe datos de Firestore.
* `mood_history_provider.dart`: expone `AsyncValue<List<Map<String, dynamic>>>`.
* `mood_history_preview.dart`: muestra resumen en Home.
* `mood_history_full.dart`: lista completa + filtros + semanal.
* `mood_weekly_chart.dart`: gráfico/Timeline semanal (toggle).

### MoodWeeklyChart (técnico)

* Genera ventana de **7 días** con `List.generate`.
* Mapea cada día con su item (si no hay registro, muestra día vacío).
* Usa `fl_chart` para barras; **emoji overlay** con `Positioned` + `LayoutBuilder`.
* **Altura máxima** controlada (paddings + `maxY`) y **grid apagado**.
* Ejes inferiores localizados: `DateFormat.E(Localizations.localeOf(context).toString())`.

## 4. Autenticación

* `auth_service.dart` (Firebase Auth + Google)
* `auth_controller.dart` coordina el flujo con las pantallas de `auth/screens/`.

## 5. Modelos

* `user_model.dart` y `mood_quote_model.dart` (DTOs/serialización).

## 6. Temas y diseño

* Tokens en `app_colors.dart`
* Esquemas en `app_theme.dart`
* Componentes reusables en `features/*/widgets/`

## 7. Internacionalización de fechas

* `intl` para formatos
* Se usa **locale del sistema** (`Localizations.localeOf(context)`), sin hardcodear `es_ES`.

## 8. Pruebas (plan)

* **Unit**: services y providers
* **Widget**: MoodWeeklyChart (render, toggle, labels)
* **Golden**: UI estable de listas y tarjetas

## 9. Próximos pasos técnicos (corto plazo)

* Refactor de providers a **typed models** en lugar de `Map<String, dynamic>`
* **Error handling** y retries en servicios
* **Memorización**/cache con Riverpod
* Exportación/backup de historial (opcional)

---

## 🔗 Clonado rápido

```bash
# SSH
git clone git@github.com:Pitcher755/MindMate.git

# HTTPS
git clone https://github.com/Pitcher755/MindMate.git
```

---

> 🚀 **MindMate**: tu compañero emocional, siempre contigo.

---
