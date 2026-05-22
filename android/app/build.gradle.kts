plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.card_storage"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.card_storage"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isShrinkResources = true
            isMinifyEnabled = true
        }
    }
}

flutter {
    source = "../.."
}

// Replace the bundled MLKit barcode library (which bakes ~5.8 MB of native
// libs + tflite models into the APK) with the unbundled Play Services variant
// that downloads the model on first use via Google Play Services.
// Trade-off: requires GMS; the very first scan triggers a small background
// download. Remove this block to restore the bundled (offline-capable) version.
configurations.all {
    resolutionStrategy.dependencySubstitution {
        substitute(module("com.google.mlkit:barcode-scanning"))
            .using(module("com.google.android.gms:play-services-mlkit-barcode-scanning:18.3.1"))
    }
}
