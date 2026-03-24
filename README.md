# Pausa

Pausa es una app iOS enfocada en acompañar momentos de estrés cotidiano, sobrecarga mental y ansiedad leve. No es terapia, no hace diagnóstico y no reemplaza apoyo profesional. Su propuesta es más concreta: ayudar a la persona a bajar un poco la intensidad del momento, entender mejor cómo se siente y elegir una siguiente acción útil dentro de la app.

## Propósito

La app busca mover al usuario de:

> "Me siento sobrepasado y no sé qué hacer"

a algo más parecido a:

> "Ya estoy un poco más calmado, entiendo mejor lo que me pasa y sé qué puedo hacer ahora"

El objetivo del MVP es validar recurrencia. Es decir: comprobar si las personas vuelven a usar con frecuencia herramientas breves como check-ins, alivio inmediato, ejercicios guiados, escritura corta, historial y un chat de apoyo liviano.

## Qué hace la app

Pausa ya cubre este flujo principal:

1. Personaliza lo mínimo en onboarding.
2. Lleva al usuario a un home con accesos rápidos y estado reciente.
3. Permite registrar cómo se siente.
4. Sugiere una acción concreta según el momento.
5. Ofrece ayuda inmediata o ejercicios guiados.
6. Deja descargar ideas o emociones en escritura breve.
7. Guarda historial local para que el usuario vea patrones simples.

## Qué incluye hoy

### Onboarding

- nombre o apodo
- cómo le gustaría sentirse
- principal preocupación actual
- flujo paginado con una decisión por pantalla

### Home

- saludo principal
- acceso rápido a `Cómo estás`
- acceso directo a `Alivio inmediato`
- entrada a ejercicios, escritura, historial y chat
- acceso a perfil desde la barra superior
- resumen breve de actividad reciente

### Cómo estás

- selección rápida del estado emocional
- intensidad de estrés
- recomendación contextual
- guardado local del registro

### Alivio inmediato

- acceso rápido a prácticas cortas
- carrusel horizontal con CTA claro
- apertura directa por deep link
- base para widget de acceso rápido

### Ejercicios guiados

- ejercicios breves de respiración, grounding, relajación y pausa
- sesión con círculo animado
- guía visual por fase
- voz opcional para acompañar el ritmo
- feedback simple al terminar: `Sí`, `Un poco`, `No mucho`

### Escritura breve

- no obliga a llenar todos los campos
- permite guardar con cualquier campo que tenga contenido
- lista de entradas guardadas
- detalle legible de cada nota

### Chat de apoyo

- motor local basado en reglas
- reconoce señales de ansiedad, saturación, cansancio o urgencia
- responde con tono calmado
- puede sugerir una ruta dentro de la app
- evita lenguaje clínico o diagnóstico

### Historial

- emociones repetidas
- herramientas más usadas
- sesiones registradas
- lectura simple de patrones recientes

### Perfil

- datos base del usuario
- personalización ligera del contexto emocional inicial

### Widget

- widget `Alivio inmediato`
- abre la app directo en la ruta de ayuda inmediata usando `pausa://immediate-help`

## Qué problema resuelve

La app no intenta cubrir salud mental en general. Se enfoca en un problema concreto: cuando una persona se siente cargada, ansiosa o mentalmente saturada, suele no tener claridad para decidir qué hacer. Pausa reduce esa fricción y convierte ese estado difuso en una acción breve, clara y más humana.

## Para quién está hecha

Principalmente para:

- estudiantes
- personas con trabajo remoto
- profesionales jóvenes
- usuarios con estrés cotidiano o señales de burnout leve
- personas que quieren algo rápido, privado y sin tono clínico

## Qué no intenta ser

Pausa no está pensada como:

- app de terapia
- herramienta diagnóstica
- sustituto de psicoterapia o apoyo profesional
- plataforma social o comunidad
- producto corporativo complejo
- solución médica

## Principios del producto

- Humana, no clínica
- Rápida antes que explicativa
- Simple antes que cargada
- Privada por defecto
- Útil antes que inspiracional
- Calmante sin ser blanda o confusa

## Dirección de UX

La app está siendo empujada hacia una experiencia:

- clara
- cálida
- con poco ruido visual
- con una acción principal por pantalla
- con descubrimiento horizontal en carruseles
- con detalles secundarios en sheets
- con copy corto y más natural para público latino

Se evita:

- bloques largos de texto
- lenguaje abstracto innecesario
- jerarquías visuales confusas
- fricción en momentos de ansiedad

## Contenido de ejercicios

Los ejercicios viven en `Pausa/Core/Utilities/ExerciseLibrary.swift`. Cada ejercicio incluye:

- identificador
- título
- resumen
- duración estimada
- guía corta
- prompt de cierre
- tags rápidos de uso
- nota de cuidado opcional
- metadata de respaldo y origen para modelado interno

La sesión se apoya en `Pausa/Features/Exercises/ExerciseSessionSupport.swift`, que define:

- ritmo visual
- fases del ejercicio
- cues habladas
- variación entre ejercicios respiratorios y no respiratorios

## Arquitectura

La base sigue una estructura modular por capas y features:

```text
Pausa/
  Core/
    Analytics/
    DesignSystem/
    Models/
    Persistence/
    Theme/
    Utilities/
  Features/
    CheckIn/
    Exercises/
    History/
    Home/
    ImmediateHelp/
    Journaling/
    Onboarding/
    Profile/
    SupportChat/
  PausaApp.swift
  ContentView.swift
PausaWidget/
```

### Core

- `Analytics`: eventos y hooks desacoplados
- `DesignSystem`: cards, botones, CTA, indicadores y componentes compartidos
- `Models`: modelos de dominio y modelos SwiftData
- `Persistence`: configuración del contenedor local
- `Theme`: colores, spacing, radios y estilo base
- `Utilities`: librerías y motores como ejercicios, recomendaciones, rutas y chat

### Features

Cada feature concentra su vista y su estado principal:

- `Onboarding`
- `Home`
- `CheckIn`
- `ImmediateHelp`
- `Exercises`
- `Journaling`
- `SupportChat`
- `History`
- `Profile`

## Stack técnico

- Swift
- SwiftUI
- SwiftData
- Observation
- NavigationStack
- WidgetKit
- AVFoundation para cues de voz
- String Catalogs con `Localizable.xcstrings`

No se usan dependencias de terceros.

## Inyección de dependencias y servicios

El punto central de servicios es `AppServices`, definido en `Pausa/Core/Analytics/Analytics.swift`.

Hoy encapsula:

- `analytics` para tracking desacoplado
- `recommendationEngine` para recomendaciones contextuales del check-in
- `supportChatEngine` para respuestas locales del chat

`PausaApp` crea una instancia de `AppServices` y se la pasa a `ContentView`. Desde ahí se inyecta a las features que la necesitan vía inicializador, en lugar de usar singletons o `@Environment` custom.

## Navegación y routing

La navegación se resuelve desde `Pausa/ContentView.swift` con `NavigationStack` y rutas tipadas por `AppRoute`:

- `checkIn`
- `immediateHelp`
- `exercises`
- `exercise`
- `journaling`
- `supportChat`
- `history`
- `profile`

Las pantallas no navegan con `NavigationLink(destination:)`. En su lugar reciben un callback `openRoute` y empujan un `AppRoute` al stack central.

También existe soporte para deep links y serialización de rutas en `Pausa/Core/Utilities/AppRouteStorage.swift`.

Actualmente el deep link soportado es:

- `pausa://immediate-help`

## Persistencia local

La persistencia está centralizada en `Pausa/Core/Persistence/PersistenceController.swift`.

El contenedor SwiftData registra este schema:

- `UserProfile`
- `EmotionalCheckIn`
- `JournalEntry`
- `ExerciseSessionRecord`
- `ToolUsageEvent`
- `ChatMessageRecord`

Los modelos viven en `Pausa/Core/Models/AppModels.swift`.

Actualmente se persiste de forma local:

- perfil de usuario
- respuestas del onboarding
- registros emocionales
- entradas de journaling
- sesiones de ejercicios
- utilidad percibida del ejercicio
- eventos de uso
- historial básico del chat

Existe además un `PreviewSeeder` para poblar previews con datos de ejemplo en memoria.

## Recomendaciones y chat

La lógica de recomendación del check-in vive en `Pausa/Core/Utilities/RecommendationEngine.swift`.

Recibe:

- emoción seleccionada
- nivel de estrés

Y devuelve:

- título de recomendación
- body contextual
- ruta sugerida
- texto del CTA

El chat de apoyo usa `Pausa/Core/Utilities/SupportChatEngine.swift`.

Es un motor local basado en reglas simples y keywords para detectar patrones como:

- ansiedad
- saturación
- intensidad emocional
- urgencia
- sueño

La respuesta incluye copy en español y, cuando corresponde, una ruta sugerida dentro de la app.

## Ejercicios, audio y pacing

Los ejercicios viven en `Pausa/Core/Utilities/ExerciseLibrary.swift`. Cada ejercicio incluye:

- identificador
- título
- resumen
- duración estimada
- detalle
- nivel de evidencia
- contexto de origen
- nota de cuidado opcional
- referencias
- prompt de cierre

La sesión de ejercicio usa dos piezas principales:

- `Pausa/Features/Exercises/ExercisesView.swift`
- `Pausa/Features/Exercises/ExerciseSessionSupport.swift`

Ahí se resuelve:

- temporización de la sesión
- cues por fase
- animación visual continua del orb de respiración
- variación entre ejercicios respiratorios y no respiratorios
- feedback al terminar

El audio de apoyo usa `AVSpeechSynthesizer` mediante `ExerciseCuePlayer`.

Detalles actuales del audio:

- es opcional y controlado por la preferencia `exercise_voice_cues_enabled`
- usa voz `es-MX` con fallback a `es-ES`
- reproduce cues breves según la fase del ejercicio
- se detiene al pausar o abandonar la pantalla

## Analytics

El tracking está centralizado en `Pausa/Core/Analytics/Analytics.swift` y se usa vía `AppServices`, no con llamadas sueltas desde las vistas.

Eventos clave del MVP:

- `onboarding_completed`
- `checkin_completed`
- `immediate_help_used`
- `exercise_started`
- `exercise_completed`
- `journaling_saved`
- `chat_message_sent`
- `home_returned`

El tracker por defecto actual es `ConsoleAnalyticsTracker`, que imprime a consola y opcionalmente persiste eventos en `ToolUsageEvent` cuando recibe un `ModelContext`.

## Localización

Todo el copy visible del producto debe vivir en español y apoyarse en:

- `Pausa/Localizable.xcstrings`
- `Pausa/Core/Utilities/AppStrings.swift`

Reglas actuales:

- evitar copy de producto hardcodeado en vistas
- usar `LocalizedStringResource` a través de `AppStrings`
- mantener un tono breve, claro y humano

## Widget y deep links

El proyecto incluye un widget en `PausaWidget/ImmediateHelpWidget.swift` que abre la app directo en ayuda inmediata.

Piezas relacionadas:

- `PausaWidget/PausaWidgetBundle.swift`
- `PausaWidget-Info.plist`
- `Pausa/Core/Utilities/AppRouteStorage.swift`

El widget:

- usa `WidgetKit`
- soporta `systemSmall` y `systemMedium`
- abre la app con `pausa://immediate-help`
- mantiene un layout propio, sin depender de la navegación interna de la vista widget

## Flujo de arranque

El arranque actual de la app es:

1. `PausaApp` crea `AppServices` y el `ModelContainer`.
2. `ContentView` consulta si existe `UserProfile`.
3. Si no existe perfil, muestra onboarding.
4. Si existe perfil, muestra `HomeView` dentro del `NavigationStack`.
5. Si entra un deep link válido, `ContentView` reconstruye la ruta y la empuja al stack.

## GitFlow

Este repositorio usa una convención simple basada en GitFlow:

- `main`: rama estable
- `develop`: rama principal de desarrollo
- `feature/...`: nuevas funcionalidades
- `release/...`: preparación de una versión
- `hotfix/...`: correcciones urgentes sobre `main`

### Flujo diario

Para trabajo normal, partir desde `develop`:

```bash
git switch develop
git switch -c feature/nombre-de-la-tarea
```

Commit messages recomendados:

- `feat(scope): ...`
- `fix(scope): ...`
- `docs(scope): ...`
- `refactor(scope): ...`
- `chore(scope): ...`

Cuando la feature esté lista:

```bash
git switch develop
git merge feature/nombre-de-la-tarea
git branch -d feature/nombre-de-la-tarea
```

### Release

Para preparar una versión:

```bash
git switch develop
git switch -c release/0.1.0
```

Cuando quede aprobada:

```bash
git switch main
git merge release/0.1.0
git switch develop
git merge release/0.1.0
git branch -d release/0.1.0
```

### Hotfix

Para una corrección urgente en producción:

```bash
git switch main
git switch -c hotfix/descripcion-corta
```

Cuando esté lista:

```bash
git switch main
git merge hotfix/descripcion-corta
git switch develop
git merge hotfix/descripcion-corta
git branch -d hotfix/descripcion-corta
```

## Cómo correr el proyecto

1. Abre `Pausa.xcodeproj`.
2. Selecciona el esquema `Pausa`.
3. Elige un simulador iOS o un iPhone conectado.
4. Ejecuta la app.

Para el widget:

1. Ejecuta la app al menos una vez.
2. En el simulador o dispositivo, añade el widget de `Pausa`.
3. Tócalo para abrir `Alivio inmediato`.

## Build desde terminal

```bash
xcodebuild -project Pausa.xcodeproj -scheme Pausa -destination 'generic/platform=iOS Simulator' -derivedDataPath /tmp/PausaDerived build
```

Build de simulador listo para compartir como `.app`:

```bash
xcodebuild -project Pausa.xcodeproj -scheme Pausa -configuration Debug -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' -derivedDataPath /tmp/PausaDerived build
```

Comprimir el `.app` del simulador:

```bash
ditto -c -k --sequesterRsrc --keepParent /tmp/PausaDerived/Build/Products/Debug-iphonesimulator/Pausa.app /tmp/Pausa.app.zip
```

## Testing

El proyecto incluye pruebas básicas para comportamiento central, en especial:

- mapeo de recomendación de check-in
- consistencia de la librería de ejercicios
- partes del comportamiento esperado del contenido

## Estado actual

El proyecto ya funciona como un MVP realista de App Store en enfoque de producto, aunque sigue habiendo áreas en refinamiento:

- más consistencia de motion y microinteracciones
- más pulido visual entre features
- más cobertura de tests
- validación más fuerte de accesibilidad y Dynamic Type

## Siguientes mejoras razonables

- seguir puliendo copy para público latino
- reforzar la claridad de estados vacíos y feedbacks
- ampliar tests de ViewModels y reglas de chat
- revisar instalación, archive y distribución en dispositivo real
- seguir refinando el widget y su lenguaje visual
