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

Y luego  `flutter pub get` para obtener todas las dependencias del proyecto y luego

### Ejecutando en dispositivo fisico
In these two operating systems it is not possible to share your USB device with the container, that is why we must resort to an alternative way.

First you will have to have the platforms tools that contain ADB installed on your host machine and you can download them here

Connect your device via USB and make sure debugging is enabled, then run in your host machine:
adb tcpip 5555
Find the IP address of your device, go to Settings > Wi-Fi > Advanced > IP Address on your device or run adb shell netcfg.
Connect to device using the IP address with the following command:
adb connect xxx.xxx.x.x
Disconnect USB and proceed to open the dev container in vscode.
Now inside your container run the command from step 3 with the same IP address.
Verify if the container can list now your device using adb devices.

flutter devices
flutter run -d 22101320G