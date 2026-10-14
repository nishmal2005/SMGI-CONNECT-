import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    // REMOVED: id("kotlin-android") <-- fixes the Kotlin Gradle Plugin warning
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.smgi.connect"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.smgi.connect"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // ── SmartGateway / Juspay client ID ─────────────────────
        val clientId = (rootProject.extra["clientId"] as? String) ?: "hdfcmaster"

        manifestPlaceholders["clientId"] = clientId
        buildConfigField("String", "JUSPAY_CLIENT_ID", "\"$clientId\"")
        resValue("string", "juspay_client_id", clientId)
        // ────────────────────────────────────────────────────────
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // ── Enable the features that defaultConfig uses ─────────
    buildFeatures {
        buildConfig = true
        resValues   = true      // ← THIS FIXES YOUR ERROR
    }
    // ────────────────────────────────────────────────────────
}

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

flutter {
    source = "../.."
}