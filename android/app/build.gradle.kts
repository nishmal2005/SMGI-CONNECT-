import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

// 1. Load keystore properties safely
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.smgi.connect"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // 2. Release Signing Config
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = file(keystoreProperties.getProperty("storeFile"))
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    defaultConfig {
        applicationId = "com.smgi.connect"
        // 3. CHANGED: Hardcoded to 23 to prevent flutter_secure_storage from crashing
        minSdk = flutter.minSdkVersion 
        targetSdk = 36
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
            signingConfig = signingConfigs.getByName("release")
            
            // 4. CHANGED: Disable these to fix the white screen issue
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    buildFeatures {
        buildConfig = true
        resValues   = true      
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

flutter {
    source = "../.."
}
