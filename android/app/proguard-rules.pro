# TensorFlow Lite keep rules
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**

# General rule to prevent R8 from choking on optional / missing classes in dependencies
-dontwarn org.tensorflow.lite.gpu.**
