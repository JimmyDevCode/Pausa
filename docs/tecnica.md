# Guía técnica

## Resumen

`Pausa` es una app iOS nativa con un widget complementario. El proyecto está construido con Swift y frameworks de Apple, sin dependencias de terceros.

## Datos del proyecto

- Producto: `Pausa`
- Versión de marketing: `1.0`
- Build: `1`
- Lenguaje principal: `Swift`
- `SWIFT_VERSION`: `5.0`
- SDK base: `iphoneos`
- iOS mínimo: `18.0`
- Dispositivos objetivo: `iPhone` (`TARGETED_DEVICE_FAMILY = 1`)

## Targets y bundle identifiers

- App: `Pausa`
  - bundle id: `jimmy.macedo.Pausa`
- Widget: `PausaWidget`
  - bundle id: `jimmy.macedo.Pausa.widget`
- Tests: `PausaTests`
  - bundle id: `jimmy.macedo.PausaTests`
- UI Tests: `PausaUITests`
  - bundle id: `jimmy.macedo.PausaUITests`

## Stack

- `SwiftUI` para la interfaz
- `SwiftData` para persistencia local
- `Observation` para estado observable
- `WidgetKit` para el widget
- `UserNotifications` para recordatorios locales
- `AVFoundation` para apoyo de voz/cues en ejercicios
- `NavigationStack` para navegación principal
- `TabView` para navegación por intención
- `Localizable.xcstrings` para textos localizados

No se usan librerías externas.

## Arquitectura

La app está organizada por features y un núcleo compartido:

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
  ContentView.swift
  PausaApp.swift
PausaWidget/
```

### Core

- `Analytics`
  - eventos y servicios compartidos
- `DesignSystem`
  - componentes reutilizables como cards, botones y CTAs
- `Models`
  - modelos de dominio y modelos `SwiftData`
- `Persistence`
  - configuración del contenedor y datos preview
- `Theme`
  - colores, tipografía y tokens visuales
- `Utilities`
  - rutas, strings, librería de ejercicios y motor de recomendaciones

### Features

Cada feature concentra su vista principal y su estado asociado:

- `Onboarding`
- `Home`
- `CheckIn`
- `ImmediateHelp`
- `Exercises`
- `Journaling`
- `History`
- `Profile`

## Flujo principal de la app

1. `PausaApp.swift` crea el contenedor y los servicios.
2. `ContentView.swift` decide entre onboarding y app principal.
3. La navegación principal usa `NavigationStack`.
4. La navegación primaria entre secciones usa `TabView`.
5. Cada feature trabaja contra `AppServices` y `SwiftData`.

## Persistencia

La persistencia está resuelta con `SwiftData`.

Modelos actuales:

- `UserProfile`
- `EmotionalCheckIn`
- `JournalEntry`
- `ExerciseSessionRecord`
- `ToolUsageEvent`

Notas:

- Los datos viven localmente.
- `PersistenceController.preview` siembra datos de ejemplo para previews.
- Hoy no hay un plan explícito de migraciones versionadas.

## Navegación y rutas

Las rutas de la app están centralizadas en `AppRoute` y `AppRouteStorage`.

Rutas principales:

- `checkIn`
- `immediateHelp`
- `exercises`
- `exercise(...)`
- `journaling`
- `history`
- `writings`
- `profile`

La app también soporta deep link a ayuda inmediata:

- `pausa://immediate-help`

## Ejercicios y recomendaciones

### Ejercicios

La librería de ejercicios vive en:

- `Pausa/Core/Utilities/ExerciseLibrary.swift`

La sesión guiada y sus fases viven en:

- `Pausa/Features/Exercises/ExerciseSessionSupport.swift`

### Recomendaciones

El motor de recomendación vive en:

- `Pausa/Core/Utilities/RecommendationEngine.swift`

Su salida depende de:

- emoción elegida
- intensidad de estrés

## Widget

El widget vive en `PausaWidget/` y expone acceso rápido a ayuda inmediata.

Archivos principales:

- `PausaWidget/ImmediateHelpWidget.swift`
- `PausaWidget/PausaWidgetBundle.swift`

## Notificaciones

Los recordatorios diarios se gestionan con `UserNotifications` desde:

- `Pausa/Core/Analytics/Analytics.swift`
- `Pausa/Features/Profile/ProfileView.swift`

La app usa recordatorios locales, no push notifications remotas.

## Build y ejecución

### Requisitos

- Xcode con soporte para iOS 18 SDK
- perfil de firma válido si se quiere instalar en dispositivo o compilar con firma normal

### Abrir el proyecto

- archivo principal: `Pausa.xcodeproj`
- esquema principal: `Pausa`

### Comando base

```bash
xcodebuild -scheme Pausa -destination 'generic/platform=iOS' build
```

### Nota de signing

El proyecto usa bundle identifiers reales:

- `jimmy.macedo.Pausa`
- `jimmy.macedo.Pausa.widget`

Si no hay perfiles válidos configurados, `xcodebuild` puede fallar por signing. Para validaciones locales rápidas, puede usarse:

```bash
xcodebuild -scheme Pausa -destination 'generic/platform=iOS' -derivedDataPath /tmp/PausaDerivedData CODE_SIGNING_ALLOWED=NO build
```

## Testing

Targets disponibles:

- `PausaTests`
- `PausaUITests`

Archivos actuales:

- `PausaTests/PausaTests.swift`
- `PausaUITests/PausaUITests.swift`
- `PausaUITests/PausaUITestsLaunchTests.swift`

## Recursos y localización

- textos: `Pausa/Localizable.xcstrings`
- assets: `Pausa/Assets.xcassets`
- launch screen: `Pausa/LaunchScreen.storyboard`

## Estado actual relevante

- app nativa iOS sin dependencias externas
- widget activo
- persistencia local con `SwiftData`
- copy y UX orientados a español latino
- documentación técnica movida a `docs/`
