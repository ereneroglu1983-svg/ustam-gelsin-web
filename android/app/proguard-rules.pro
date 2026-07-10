# --- Agora SDK Kuralları ---
-keep class io.agora.**{*;}
-dontwarn io.agora.**

# --- Flutter Native Kanal (Pigeon) Kuralları ---
# Bu kısım url_launcher ve benzeri eklentilerin haberleşme kanallarının 
# ProGuard tarafından silinmesini engeller.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class * extends io.flutter.plugin.common.PluginRegistry$Plugin { *; }

# --- url_launcher Özel Kuralları ---
-keep class io.flutter.plugins.urllauncher.** { *; }

# --- Genel Eklenti Desteği ---
-dontwarn io.flutter.embedding.**
-keep class io.flutter.embedding.** { *; }