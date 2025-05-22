# threedverse_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Docker Setup

Comando para crear la imagen de Docker:
``` bash
docker build -t flutter-dev-android . --no-cache
```

Comando para ejecutar el contenedor de linux en docker con todo el proyecto de flutter previamente configurado:
``` bash
docker run -it --rm -v "%CD%":/app -v "%USERPROFILE%\.gradle":/root/.gradle -v "%USERPROFILE%\.android":/root/.android -v "%USERPROFILE%\.pub-cache":/root/.pub-cache --device /dev/kvm -e ANDROID_SDK_ROOT=/opt/android-sdk -p 8080:8080 -p 5354:5354 flutter-dev-android bash
```

En este punto, puedes ejecutar el comando `flutter doctor` para verificar que todo esté configurado correctamente. 

Y luego  `flutter pub get` para obtener todas las dependencias del proyecto.

### Ejecutando en dispositivo fisico
En Windows/macOS no es posible compartir directamente dispositivos USB con el contenedor, por lo que debemos usar un método alternativo.

## Pasos para configurar:

First you will have to have the platforms tools that contain ADB installed on your host machine and you can download them here

#### 1. Prepara tu máquina host:

- Instala las herramientas de plataforma de Android que incluyen ADB (puedes descargarlas aquí)

#### 2. Configura tu dispositivo:

- Conecta tu dispositivo físico via USB

- Asegúrate de tener habilitada la depuración USB (en Opciones de desarrollador)

#### 3. En tu máquina host (fuera del contenedor) ejecuta:

``` bash
adb tcpip 5555
```

#### 4. Obtén la dirección IP de tu dispositivo:

- Ve a: Ajustes > Wi-Fi > Avanzado > Dirección IP

- O ejecuta en tu host:

``` bash
adb shell netcfg
```

#### 5. Conéctate via red:

``` bash
adb connect xxx.xxx.x.x  # Reemplaza con la IP de tu dispositivo
```

#### 6. Ahora en el contenedor:

- Abre el contenedor en VSCode

- Ejecuta el mismo comando de conexión con la IP:

```bash
adb connect xxx.xxx.x.x
```

- Verifica que el contenedor detecte el dispositivo:

```bash
adb devices
```

7. Finalmente ejecuta Flutter:

``` bash
flutter devices  # Deberías ver tu dispositivo
flutter run -d <ID_DISPOSITIVO>  # Ejemplo: flutter run -d 22101320G
```

Nota importante: Puedes desconectar el cable USB después del paso 5, la conexión se mantendrá via Wi-Fi.