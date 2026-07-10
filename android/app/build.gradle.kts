plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    ndkVersion = "28.2.13676358"
    namespace = "com.ustamgelsin.app.ustam_gelsin"

    compileSdk = 36

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.ustamgelsin.app.ustam_gelsin"
        minSdk = flutter.minSdkVersion // flutter.minSdkVersion yerine sabit 21 kullanmak bağlantı kararlılığı sağlar
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            // Native kanal hatalarını önlemek için release modunda minify'ı test amaçlı kapalı tutabilirsin
            // Eğer minify gerekiyorsa, proguard-rules.pro içine Flutter kurallarını eklediğinden emin ol
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.0")
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}
